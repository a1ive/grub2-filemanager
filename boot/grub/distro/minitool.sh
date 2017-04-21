set icon="pmagic";
set vmlinuz_img="(loop)/casper/vmlinuz*";
set initrd_img="(loop)/casper/tinycore.gz";
set loopiso=" ";
menuentry "作为 MiniTool Partition Wizard ISO 启动" --class $icon{
	set kcmdline="ramdisk_size=409600 root=/dev/ram0 rw";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
