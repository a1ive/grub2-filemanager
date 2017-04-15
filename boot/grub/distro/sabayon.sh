set icon="gentoo";
set vmlinuz_img="(loop)/boot/sabayon";
set initrd_img="(loop)/boot/sabayon.igz";
set loopiso="isoboot=$isofile";
menuentry "作为 Sabayon LiveDVD 启动" --class $icon{
	set kcmdline="overlayfs cdroot splash --";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
