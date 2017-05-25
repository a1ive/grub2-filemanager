set icon="slax";
set loopiso="from=${isofile}";
set vmlinuz_img="(loop)/slax/boot/vmlinuz";
set initrd_img="(loop)/slax/boot/initr*";
if test -f (loop)/boot/vmlinuz; then
	vmlinuz_img="(loop)/slax/boot/vmlinuz";
	initrd_img="(loop)/slax/boot/initr*";
fi
menuentry $"Boot Slax From ISO" --class $icon{
	set kcmdline="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 slax.flags=xmode";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}