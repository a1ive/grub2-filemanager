set icon="archlinux";
set imgdevpath="/dev/disk/by-uuid/$devuuid";
if test -f (loop)/arch/boot/x86_64/vmlinuz* -a -f (loop)/arch/boot/x86_64/archiso.img; then
	set vmlinuz_img="(loop)/arch/boot/x86_64/vmlinuz*";
	set initrd_img="(loop)/arch/boot/x86_64/archiso.img";
	set kcmdline="archisodevice=/dev/loop0 earlymodules=loop";
	set loopiso="img_dev=$imgdevpath img_loop=$isofile archisolabel=$devlbl";
	menuentry "作为 Arch Linux LiveCD 启动" --class $icon{
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
fi
if test -f (loop)/boot/vmlinuz_x86_64 -a -f (loop)/boot/initramfs_x86_64.img; then
	set vmlinuz_img="(loop)/boot/vmlinuz_x86_64";
	set initrd_img="(loop)/boot/initramfs_x86_64.img";
	set loopiso="iso_loop_dev=$imgdevpath iso_loop_path=$isofile";
	menuentry "作为 Archboot ISO 启动" --class $icon{
		linux $vmlinuz_img $loopiso;
		initrd $initrd_img;
	}
fi
if test -f (loop)/arch/boot/vmlinuz* -a -f (loop)/arch/boot/archiso.img; then
	set vmlinuz_img="(loop)/arch/boot/vmlinuz*";
	set initrd_img="(loop)/arch/boot/archiso.img";
	set kcmdline="archisobasedir=arch earlymodules=loop modules-load=loop";
	set loopiso="img_dev=$imgdevpath img_loop=$isofile archisolabel=$devlbl";
	menuentry "作为 Arch Linux LiveCD 启动" --class $icon{
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
fi
