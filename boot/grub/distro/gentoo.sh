set icon="gentoo";
set vmlinuz_img="(loop)/isolinux/gentoo";
set initrd_img="(loop)/isolinux/gentoo.xz";
if test -f (loop)/isolinux/gentoo64; then
	vmlinuz_img="(loop)/isolinux/gentoo64";
	initrd_img="(loop)/isolinux/gentoo64.xz";
fi
set loopiso="isoboot=$isofile";
menuentry $"Boot Gentoo From ISO" --class $icon{
	set kcmdline="root=/dev/ram0 init=/linuxrc dokeymap aufs looptype=squashfs loop=/image.squashfs cdroot console=tty1";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
