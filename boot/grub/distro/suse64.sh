set icon="opensuse";
set vmlinuz_img="(loop)/boot/x86_64/loader/linux";
set initrd_img="(loop)/boot/x86_64/loader/initrd";
set imgdevpath="/dev/disk/by-uuid/$devuuid";
set linux_extra="isofrom_system=$isofile isofrom_device=$imgdevpath";
menuentry $"Boot OpenSuSE From ISO" --class $icon{
	set kcmdline=" ";
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}