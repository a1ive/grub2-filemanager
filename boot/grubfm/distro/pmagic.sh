set icon="pmagic";
set vmlinuz_img="(loop)/pmagic/bzImage";
set vmlinuz_img64="(loop)/pmagic/bzImage64";
set initrd_img="(loop)/pmagic/initrd.img (loop)/pmagic/fu.img (loop)/pmagic/m32.img";
set initrd_img64="(loop)/pmagic/initrd.img (loop)/pmagic/fu.img (loop)/pmagic/m64.img";
menuentry $"Parted Magic (x86_64)" --class $icon{
    set kcmdline="eject=no load_ramdisk=1";
    linux $vmlinuz_img64 $kcmdline $linux_extra;
    initrd $initrd_img64;
}
menuentry $"Parted Magic (i686)" --class $icon{
    set kcmdline="eject=no load_ramdisk=1";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}