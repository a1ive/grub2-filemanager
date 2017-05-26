set icon="gentoo";
set vmlinuz_img="(loop)/boot/sabayon";
set initrd_img="(loop)/boot/sabayon.igz";
set linux_extra="isoboot=$isofile";
menuentry $"Boot Sabayon From ISO" --class $icon{
	set kcmdline="overlayfs cdroot splash --";
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}
