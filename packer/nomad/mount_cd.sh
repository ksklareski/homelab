#!/bin/bash

ls /var/log/firstboot.log || touch /var/log/firstboot.log
echo 'Log file created'
echo 'Creating mount directory'
ls /mnt/cdrom || mkdir -p /mnt/cdrom
echo 'Mounting cdrom'
mount /dev/sr0 /mnt/cdrom
echo 'Running script'
bash /mnt/cdrom/runtime.sh
echo 'Removing systemd service'
systemctl disable firstboot.service && rm -f /etc/systemd/system/firstboot.service
echo 'Unmounting cd'
umount /mnt/cdrom
echo 'Removing this script'
rm -f /tmp/mount_cd.sh
echo 'Ejecting cdrom'
eject