include $(THEOS)/makefiles/common.mk
export ARCHS = arm64
TWEAK_NAME = RealCC
RealCC_FILES = Tweak.xm
RealCC_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
