set icon="slax";
set loopiso="from=${isofile}";
set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/initrd*";
menuentry "作为 Slax LiveCD 启动" --class $icon{
	set kcmdline="load_ramdisk=1 prompt_ramdisk=0 rw printk.time=0 slax.flags=xmode";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}