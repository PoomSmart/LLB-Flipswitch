SDKVERSION = 7.0
ARCHS = armv7

BUNDLE_NAME = LLB
LLB_FILES = Switch.xm
LLB_FRAMEWORKS = AVFoundation
LLB_LIBRARIES = flipswitch
LLB_INSTALL_PATH = /Library/Switches

SUBPROJECTS += LLBToggle

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

before-package::
	sudo chown -R root:wheel $(THEOS_STAGING_DIR)
	sudo chmod 755 $(THEOS_STAGING_DIR)
	sudo chmod 666 $(THEOS_STAGING_DIR)/Library/Switches/LLB.bundle/*.pdf
