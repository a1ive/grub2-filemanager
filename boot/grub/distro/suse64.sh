set icon="opensuse";
set vmlinuz_img="(loop)/boot/*/loader/linux";
set initrd_img="(loop)/boot/*/loader/initrd";
menuentry $"OpenSUSE Tumbleweed Live" --class $icon{
	set kcmdline="";
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}
menuentry $"OpenSUSE Installation" {
	linux $vmlinuz_img install=hd:$iso_path splash=silent showopts;
	initrd $initrd_img;
}
menuentry "Upgrade" {
	linux $vmlinuz_img install=hd:$iso_path splash=silent upgrade=1 showopts;
	initrd $initrd_img;
}
menuentry "Rescue System" {
	linux $vmlinuz_img install=hd:$iso_path splash=silent rescue=1 showopts;
	initrd $initrd_img;
}