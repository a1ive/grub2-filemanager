set icon="4m";
set vmlinuz_img="(loop)/boot/bzImage";
set initrd_img="(loop)/boot/initrd.gz";
menuentry $"Boot 4MLinux From ISO" --class $icon{
	set kcmdline="root=/dev/ram0 vga=normal";
	linux $vmlinuz_img $kcmdline;
	initrd $initrd_img;
}
