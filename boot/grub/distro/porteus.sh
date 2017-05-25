set icon="porteus";
set vmlinuz_img="(loop)/boot/syslinux/vmlinuz";
set initrd_img="(loop)/boot/syslinux/initrd*";
if test -f (loop)/porteus/vmlinuz; then
	set vmlinuz_img="(loop)/porteus/vmlinuz";
	set initrd_img="(loop)/porteus/initrd*";
fi
set loopiso="from=$isofile";
menuentry $"Boot Porteus From ISO" --class $icon{
	set kcmdline="norootcopy nomagic";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}