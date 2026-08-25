THEOS_PACKAGE_SCHEME = rootless
TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = xgesture

xgesture_FILES = Tweak.xm
xgesture_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

clean::
	rm -rf .theos packages
