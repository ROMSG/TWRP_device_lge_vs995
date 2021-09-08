#!/sbin/sh
if !  mountpoint /system; then
	mount -o ro /system
fi
if [ -d /system/system ]; then
	export GSI=true
	mkdir /gsi
	mount --bind /system/system /gsi
fi

while ! mountpoint  /data; do
	if [ -z "$GSI" ]; then
		export system=/system
	else #if system as root treat /system/system (bind mounted at /gsi) as /system
		export system=/gsi
	fi
	if ! mountpoint /system; then #mount system if not already mounted
      		mount /system -o ro
	fi
#Remove /vendor if not present	
	if [ "`blkid /dev/block/bootdevice/by-name/vendor`" ]; then
    		if [ -L /vendor ]; then
        	rm /vendor
   	 fi
   		sed -i '5i\/vendor		ext4	/dev/block/bootdevice/by-name/vendor	flags=backup=1;wipeingui' /etc/twrp.fstab
    		sed -i '6i\/vendor_image	emmc	/dev/block/bootdevice/by-name/vendor	flags=backup=0;flashimg=1' /etc/twrp.fstab
		fi
			mkdir /vendor
		fi
                mount /dev/block/bootdevice/by-name/vendor /vendor -t ext4 -o ro
        else
		if [ -d /vendor ]; then
			rmdir /vendor
		fi
		if [ ! -L /vendor ]; then
        		ln -s $system/vendor /vendor #if no vendor partition symlink it

		fi
        fi
        if [ -f $system/bin/qseecomd ]; then
#                start sys_qseecomd
		if [ -z "$(pidof qseecomd)" ]; then #make sure it isnt already running
			LD_LIBRARY_PATH='$system/lib64:$system/lib' PATH='$system/bin' $system/bin/qseecomd &
		fi
        else
#                start ven_qseecomd
		if [ -z "$(pidof qseecomd)" ]; then
			LD_LIBRARY_PATH='/vendor/lib64:$system/lib64:/vendor/lib:$system/lib' PATH='/vendor/bin:$system/bin' /vendor/bin/qseecomd &
		fi
        fi
	if [ ! -z "$GSI" ]; then
		if [ -z "(pidof vold)" ]; then
			start gsi_vold
		fi
	fi
done
#data now mounted. Clean up
if [ ! -z "$GSI" ]; then
	umount /gsi
fi
umount /system
