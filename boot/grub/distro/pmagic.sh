set icon="pmagic";
set vmlinuz_img="(loop)/pmagic/bzImage";
set vmlinuz_img64="(loop)/pmagic/bzImage64";
set initrd_img="(loop)/pmagic/initrd.img (loop)/pmagic/fu.img (loop)/pmagic/m32.img";
set initrd_img64="(loop)/pmagic/initrd.img (loop)/pmagic/fu.img (loop)/pmagic/m64.img";
set loopiso="iso_filename=$isofile";
menuentry "作为 Parted Magic LiveCD 启动 (x86_64)" --class $icon{
	set kcmdline="eject=no load_ramdisk=1";
	linux $vmlinuz_img64 $kcmdline $loopiso;
	initrd $initrd_img64;
}
menuentry "作为 Parted Magic LiveCD 启动 (i686)" --class $icon{
	set kcmdline="eject=no load_ramdisk=1";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}