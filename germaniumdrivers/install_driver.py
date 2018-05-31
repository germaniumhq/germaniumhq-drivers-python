import os
import pkg_resources
import stat

try:
    import urllib.request as urllib2
except ImportError:
    import urllib2

from . import driver_registry
from .driver_registry import get_internal_driver_path, is_driver_up_to_date
from .configurable_settings import get_germanium_drivers_folder, is_ms_edge_license_agreed


def install_driver(platform, browser):
    "https://az813057.vo.msecnd.net/eulas/webdriver-eula.pdf . If "
                    "you agree with it, you can either: 1. export GERMANIUM_I_AGREE_TO_MS_EDGE_LICENSE "
                    "into the environment, or 2. call germaniumdrivers.i_agree_to_ms_edge_license(). "
                    "Afterwards Germanium will download the drivers for you automatically. By default the "
                    "download will be in a temporary file, but you can configure the location using the "
                    "GERMANIUM_DRIVERS_FOLDER environment variable.")
