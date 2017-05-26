set icon="archlinux";
set imgdevpath="/dev/disk/by-uuid/$devuuid";
if test -f (loop)/parabola/boot/x86_64/vmlinuz* -a -f (loop)/parabola/boot/x86_64/parabolaiso.img; then
	set vmlinuz_img="(loop)/parabola/boot/x86_64/vmlinuz*";
	set initrd_img="(loop)/parabola/boot/x86_64/parabolaiso.img";
	set kcmdline="earlymodules=loop";
	set linux_extra="img_dev=$imgdevpath img_loop=$isofile parabolaisolabel=$devlbl";
	menuentry $"Boot Parabola GNU/Linux From ISO" --class $icon{
		linux $vmlinuz_img $kcmdline $linux_extra;
		initrd $initrd_img;
	}
fi

