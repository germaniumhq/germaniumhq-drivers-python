import os
import pkg_resources
import stat

from .driver_registry import get_driver_name, get_internal_driver_path, is_driver_up_to_date
from .configurable_settings import get_germanium_drivers_folder


def install_driver(platform, browser):
    """
    Installs the driver into a new folder that will also be added into the path.
    :param platform:
    :param browser:
    :return:
    """
    driver_name = get_driver_name(platform, browser)
    internal_driver_path = get_internal_driver_path(platform, browser)
    drivers_folder = get_germanium_drivers_folder()

    if os.path.exists(drivers_folder):
        if not os.path.isdir(drivers_folder):
            raise Exception("The drivers folder %s, exists already but is not a file. "
                            "Please specify a different location using the "
                            "GERMANIUM_DRIVERS_FOLDER environment variable." % drivers_folder)
    else:
        os.makedirs(drivers_folder)

    path_folders = os.environ['PATH'].split(os.pathsep)
    path_folders.insert(0, drivers_folder)
    os.environ['PATH'] = os.pathsep.join(path_folders)

    full_path_to_driver = os.path.join(drivers_folder, driver_name)

    if is_driver_up_to_date(platform, browser, full_path_to_driver):
        return full_path_to_driver

    data = pkg_resources.resource_stream(__name__, internal_driver_path).read()

    # if the driver already exists, we're going to try to remove it first, otherwise
    # Java complains.
    if os.path.exists(full_path_to_driver):
        os.remove(full_path_to_driver)

    new_file = open(full_path_to_driver, 'wb')
    new_file.write(data)
    new_file.close()

    if platform.operating_system == "linux" or platform.operating_system == "mac":
        new_file_stat = os.stat(full_path_to_driver)
        os.chmod(full_path_to_driver, new_file_stat.st_mode | stat.S_IEXEC)

    return full_path_to_driver
