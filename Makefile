ARCHS = arm64 arm64e
TARGET = iphone:clang:12.2:12.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = xgesture

xgesture_FILES = $(wildcard *.xm *.m)
xgesture_FILES = Tweak.xm
xgesture_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

clean::
	rm -rf .theos packages