set icon="4m";
set vmlinuz_img="(loop)/boot/bzImage";
set initrd_img="(loop)/boot/initrd.gz";
menuentry "作为 4MLinux ISO 启动" --class $icon{
	set kcmdline="root=/dev/ram0 vga=normal";
	linux $vmlinuz_img $kcmdline;
	initrd $initrd_img;
}
menuentry "作为 4MLinux ISO 启动 (VESA Framebuffer)" --class $icon{
	set kcmdline="root=/dev/ram0 vga=ask";
	linux $vmlinuz_img $kcmdline;
	initrd $initrd_img;
}
set initrd2="(loop)/boot/initrd2.gz"
if test -f $initrd2; then
	menuentry "作为 4MLinux ISO 启动 (Legacy Installer)" --class $icon{
		set kcmdline="root=/dev/ram0 vga=normal";
		linux $vmlinuz_img $kcmdline;
		initrd $initrd2;
	}
fi;