import os
import pkgutil
import stat

from .driver_registry import get_driver_name, get_internal_driver_path, is_driver_up_to_date


def install_driver(platform, browser):
    """
    Installs the driver into a new folder that will also be added into the path.
    :param platform:
    :param browser:
    :return:
    """
    driver_name = get_driver_name(platform, browser)
    internal_driver_path = get_internal_driver_path(platform, browser)
    drivers_folder = get_drivers_folder()

    os.makedirs(drivers_folder, exist_ok=True)

    path_folders = os.environ['PATH'].split(os.pathsep)
    path_folders.insert(0, drivers_folder)
    os.environ['PATH'] = os.pathsep.join(path_folders)

    full_path_to_driver = os.path.join(drivers_folder, driver_name)

    if is_driver_up_to_date(platform, browser, full_path_to_driver):
        return full_path_to_driver

    data = pkgutil.get_data(__name__, internal_driver_path)
    new_file = open(full_path_to_driver, 'wb')
    new_file.write(data)
    new_file.close()

    if platform.operating_system == "linux" or platform.operating_system == "mac":
        new_file_stat = os.stat(full_path_to_driver)
        os.chmod(full_path_to_driver, new_file_stat.st_mode | stat.S_IEXEC)

    return full_path_to_driver


def get_drivers_folder():
    print("STUB: get_drivers_folder(): /tmp")
    return "/tmp/germanium-drivers/"
