set vmlinuz_img="(loop)/isolinux/pentoo";
set initrd_img="(loop)/isolinux/pentoo.xz";
set kcmdline="root=/dev/ram0 init=/linuxrc nox nodhcp aufs max_loop=256 dokeymap looptype=squashfs loop=/image.squashfs cdroot video=uvesafb:mtrr:3,ywrap,1024x768-16 usbcore.autosuspend=1 console=tty0 net.ifnames=0";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
