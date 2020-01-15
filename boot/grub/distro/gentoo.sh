set vmlinuz_img="(loop)/isolinux/gentoo";
set initrd_img="(loop)/isolinux/gentoo.xz";
if test -f (loop)/isolinux/gentoo64; then
    vmlinuz_img="(loop)/isolinux/gentoo64";
    initrd_img="(loop)/isolinux/gentoo64.xz";
fi
set kcmdline="root=/dev/ram0 init=/linuxrc dokeymap aufs looptype=squashfs loop=/image.squashfs cdroot console=tty1";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
