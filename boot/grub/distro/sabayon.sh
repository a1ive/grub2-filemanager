set icon="gentoo";
set vmlinuz_img="(loop)/boot/sabayon";
set initrd_img="(loop)/boot/sabayon.igz";
set loopiso="isoboot=$isofile";
menuentry $"Boot Sabayon From ISO" --class $icon{
	set kcmdline="overlayfs cdroot splash --";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
