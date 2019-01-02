TARGET = iphone:latest:11.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RealCC
RealCC_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk
