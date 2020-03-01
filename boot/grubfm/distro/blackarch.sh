set kcmdline="archisodevice=/dev/loop0 earlymodules=loop archisobasedir=blackarch";
if test -f (loop)/blackarch/boot/x86_64/vmlinuz* -a -f (loop)/blackarch/boot/x86_64/archiso.img; then
    set vmlinuz_img="(loop)/blackarch/boot/x86_64/vmlinuz*";
    set initrd_img="(loop)/blackarch/boot/x86_64/archiso.img";
else
    set vmlinuz_img="(loop)/blackarch/boot/i386/vmlinuz*";
    set initrd_img="(loop)/blackarch/boot/i386/archiso.img";
fi;
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
