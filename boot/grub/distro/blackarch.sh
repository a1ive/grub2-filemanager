set icon="archlinux";
set imgdevpath="/dev/disk/by-uuid/$devuuid";
if test -f (loop)/blackarch/boot/x86_64/vmlinuz* -a -f (loop)/blackarch/boot/x86_64/archiso.img; then
	set vmlinuz_img="(loop)/blackarch/boot/x86_64/vmlinuz*";
	set initrd_img="(loop)/blackarch/boot/x86_64/archiso.img";
	set kcmdline="archisodevice=/dev/loop0 earlymodules=loop archisobasedir=blackarch";
	set linux_extra="img_dev=$imgdevpath img_loop=$isofile archisolabel=$devlbl";
	menuentry $"Boot BlackArch From ISO (x86_64)" --class $icon{
		linux $vmlinuz_img $kcmdline $linux_extra;
		initrd $initrd_img;
	}
fi
if test -f (loop)/blackarch/boot/i386/vmlinuz* -a -f (loop)/blackarch/boot/i386/archiso.img; then
	set vmlinuz_img="(loop)/blackarch/boot/i386/vmlinuz*";
	set initrd_img="(loop)/blackarch/boot/i386/archiso.img";
	set kcmdline="archisodevice=/dev/loop0 earlymodules=loop archisobasedir=blackarch";
	set linux_extra="img_dev=$imgdevpath img_loop=$isofile archisolabel=$devlbl";
	menuentry $"Boot BlackArch From ISO (i386)" --class $icon{
		linux $vmlinuz_img $kcmdline $linux_extra;
		initrd $initrd_img;
	}
fi