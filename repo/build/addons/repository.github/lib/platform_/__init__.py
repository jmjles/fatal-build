import logging

from . import kodi_platform
from . import os_platform
from .definitions import PlatformError, Arch, System, Platform, SHARED_LIB_EXTENSIONS, EXECUTABLE_EXTENSIONS


def dump_platform():
    return "Kodi platform: " + kodi_platform.dump_platform() + "\n" + os_platform.dump_platform()


def get_platform():
    try:
        return kodi_platform.get_platform()
    except PlatformError:
        return os_platform.get_platform()


try:
    PLATFORM = get_platform()
    SHARED_LIB_EXTENSION = SHARED_LIB_EXTENSIONS.get(PLATFORM.system, "")
    EXECUTABLE_EXTENSION = EXECUTABLE_EXTENSIONS.get(PLATFORM.system, "")
except Exception as _e:
    logging.fatal(_e, exc_info=True)
    logging.fatal(dump_platform())
    raise _e


def get_platform_arch(sep="-"):
    return PLATFORM.system + sep + PLATFORM.arch


__all__ = ["PlatformError", "Arch", "System", "Platform",
           "dump_platform", "get_platform", "get_platform_arch",
           "PLATFORM", "SHARED_LIB_EXTENSION", "EXECUTABLE_EXTENSION"]
