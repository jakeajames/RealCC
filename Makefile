DEBUG = 0
#GO_EASY_ON_ME := 1
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
ARCHS = arm64

#THEOS_DEVICE_IP = 192.168.0.17

TWEAK_NAME = RealCC
RealCC_FILES = Tweak.xm
RealCC_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
