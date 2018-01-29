include $(THEOS)/makefiles/common.mk
export ARCHS = arm64
TWEAK_NAME = RealCC
RealCC_FILES = Tweak.xm
RealCC_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk

PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

_THEOS_INTERNAL_PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

after-install::
	install.exec "killall -9 SpringBoard"
