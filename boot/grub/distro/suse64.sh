set icon="opensuse";
set vmlinuz_img="(loop)/boot/x86_64/loader/linux";
set initrd_img="(loop)/boot/x86_64/loader/initrd";
set imgdevpath="/dev/disk/by-uuid/$devuuid";
set loopiso="isofrom_system=$isofile isofrom_device=$imgdevpath";
menuentry "作为 OpenSUSE x86_64 LiveCD 启动" --class $icon{
	set kcmdline=" ";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}