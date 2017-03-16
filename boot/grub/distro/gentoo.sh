set icon="gnu-linux";
set vmlinuz_img="(loop)/isolinux/gentoo64";
set initrd_img="initrd (loop)/isolinux/gentoo64.xz";
set loopiso="isoboot=$isofile";
menuentry "作为 Gentoo x86_64 LiveDVD 启动" --class $icon{
	set kcmdline="root=/dev/ram0 init=/linuxrc dokeymap aufs looptype=squashfs loop=/image.squashfs cdroot console=tty1";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
