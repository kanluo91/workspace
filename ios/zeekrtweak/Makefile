TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard
export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2222

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = zeekrtweak

zeekrtweak_FILES = Tweak.x
zeekrtweak_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
