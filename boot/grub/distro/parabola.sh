set icon="archlinux";
set imgdevpath="/dev/disk/by-uuid/$devuuid";
if test -f (loop)/parabola/boot/x86_64/vmlinuz* -a -f (loop)/parabola/boot/x86_64/parabolaiso.img; then
	set vmlinuz_img="(loop)/parabola/boot/x86_64/vmlinuz*";
	set initrd_img="(loop)/parabola/boot/x86_64/parabolaiso.img";
	set kcmdline="earlymodules=loop";
	set loopiso="img_dev=$imgdevpath img_loop=$isofile parabolaisolabel=$devlbl";
	menuentry "作为 Parabola GNU/Linux LiveCD 启动" --class $icon{
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
fi

