set icon="gnu-linux";
set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/core.gz";
set linux_extra="iso=UUID=${devuuid}${isofile}";
menuentry $"Boot TinyCore From ISO" --class $icon{
	set kcmdline="max_loop=256";
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}