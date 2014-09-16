#!/bin/bash
PHILZ_LOCAL_PATH=$(readlink -f $1)
PHILZ_OUT_PATH=$(readlink -f $2)
PHILZ_BUILD=$3
PHILZ_DEVICE_NAME=$4
PHILZ_FILENAME=philz_touch_$PHILZ_BUILD-$PHILZ_DEVICE_NAME
PHILZ_ZIP_FILE=$PHILZ_FILENAME.zip
PHILZ_TAR_FILE=$PHILZ_FILENAME.tar
PHILZ_RECOVERY_IMG=$(readlink -f $5)
PHILZ_UPDATER_SCRIPT=$PHILZ_LOCAL_PATH/../$PHILZ_DEVICE_NAME/updater-script

if [ ! -f $PHILZ_RECOVERY_IMG ]; then
    echo "0"
    exit
fi

mkdir -p "$PHILZ_OUT_PATH/zip_src"
rm -f "$PHILZ_OUT_PATH/$PHILZ_ZIP_FILE"

cp -r $PHILZ_LOCAL_PATH/tools/META-INF $PHILZ_OUT_PATH/zip_src/
if [ -f $PHILZ_UPDATER_SCRIPT ]; then
	cp $PHILZ_UPDATER_SCRIPT $PHILZ_OUT_PATH/zip_src/META-INF/com/google/android/
fi

cp $PHILZ_RECOVERY_IMG $PHILZ_OUT_PATH/zip_src/

# Create zip installer
cd $PHILZ_OUT_PATH/zip_src
zip -r9q $PHILZ_OUT_PATH/$PHILZ_ZIP_FILE .
cp $PHILZ_OUT_PATH/$PHILZ_ZIP_FILE /media/sf_D/android/kitchen/Philz/

# Create ODIN tar file
tar -H ustar -c recovery.img > $PHILZ_OUT_PATH/$PHILZ_TAR_FILE
md5sum -t $PHILZ_OUT_PATH/$PHILZ_TAR_FILE >> $PHILZ_OUT_PATH/$PHILZ_TAR_FILE
mv $PHILZ_OUT_PATH/$PHILZ_TAR_FILE $PHILZ_OUT_PATH/$PHILZ_TAR_FILE.md5
cp $PHILZ_OUT_PATH/$PHILZ_TAR_FILE.md5 /media/sf_D/android/kitchen/Philz/
#echo 1
