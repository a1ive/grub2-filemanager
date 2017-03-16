set icon="porteus";
set vmlinuz_img="(loop)/boot/syslinux/vmlinuz";
set initrd_img="(loop)/boot/syslinux/initrd*";
if test -f (loop)/porteus/vmlinuz; then
	set vmlinuz_img="(loop)/porteus/vmlinuz";
	set initrd_img="(loop)/porteus/initrd*";
fi
set loopiso="from=$isofile";
menuentry "作为 Porteus LiveCD 启动" --class $icon{
	set kcmdline="norootcopy nomagic";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}