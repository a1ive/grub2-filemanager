set icon="archlinux"
set imgdevpath="/dev/disk/by-uuid/$devuuid";
set kcmdline="archisodevice=/dev/loop0";
set loopiso="img_dev=$imgdevpath img_loop=$isofile";
menuentry "作为 Arch Linux LiveCD 启动 (x86_64)" --class $icon{
	linux (loop)/arch/boot/x86_64/vmlinuz* $kcmdline $loopiso;
	initrd (loop)/arch/boot/x86_64/archiso.img;
}
menuentry "作为 Arch Linux LiveCD 启动 (i686)" --class $icon{
	linux (loop)/arch/boot/i686/vmlinuz* $kcmdline $loopiso;
	initrd (loop)/arch/boot/i686/archiso.img;
}
