LZMA_BIN := /usr/bin/lzma

## binary output path
PHILZ_TOUCH_LOCALPATH := $(call my-dir)
PHILZ_LOCALPATH := $(PHILZ_TOUCH_LOCALPATH)
PHILZ_OUT_PATH := $(TARGET_RECOVERY_ROOT_OUT)/../../philz_out
PHILZ_DEVICE_NAME   := $(shell echo $(TARGET_PRODUCT) | cut -d _ -f 2)
PHILZ_ZIP_FILE      := $(PHILZ_OUT_PATH)/philz_touch_$(PHILZ_BUILD)-$(PHILZ_DEVICE_NAME).zip

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
    $(recovery_ramdisk) \
    $(recovery_kernel)
	@echo ----- Compressing recovery ramdisk with lzma ------
	$(LZMA_BIN) -f $(recovery_uncompressed_ramdisk)
	$(hide) cp $(recovery_uncompressed_ramdisk).lzma $(recovery_ramdisk)
	@echo ----- Making recovery image ------
	$(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	@echo ----- Made recovery image -------- $@
	$(hide) cp $@ /media/sf_D/android/recovery-$(PHILZ_BUILD).img
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo ----- Making Philz Touch $(PHILZ_BUILD) Recovery Zip... ----- 
	@echo ----- Using recovery image -------- $@
	$(hide) mkdir -p $(PHILZ_OUT_PATH)
	@echo ----- Install ---- $(PHILZ_ZIP_FILE)
	$(hide) $(PHILZ_LOCALPATH)/tools/android_building.sh $(PHILZ_LOCALPATH) $(PHILZ_OUT_PATH) \
	$(PHILZ_BUILD) $(PHILZ_DEVICE_NAME) $@

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)

