# Release name
PRODUCT_RELEASE_NAME := vs995

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# Inherit from our custom product configuration
$(call inherit-product, vendor/omni/config/common.mk)

PRODUCT_PACKAGES += \
	charger_res_images \
	charger

## Device identifier. This must come after all inclusions
TARGET_SCREEN_WIDTH := 1440
TARGET_SCREEN_HEIGHT := 2560
PRODUCT_DEVICE := vs995
PRODUCT_MODEL := LG-VS995
PRODUCT_NAME := omni_vs995
PRODUCT_BRAND := lge
PRODUCT_MANUFACTURER := LGE
PRODUCT_COPY_FILES += device/lge/$(PRODUCT_DEVICE)/recovery.fstab:recovery/root/etc/twrp.flags
PRODUCT_COPY_FILES += bionic/libc/zoneinfo/tzdata:recovery/root/system/usr/share/zoneinfo/tzdata
