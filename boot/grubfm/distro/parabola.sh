export enable_progress_indicator=1;
set vmlinuz_img="(loop)/parabola/boot/x86_64/vmlinuz*";
set kcmdline="earlymodules=loop";

if test -f (loop)/parabola/boot/x86_64/initramfs-linux.img;
then
  set initrd_img="(loop)/parabola/boot/x86_64/initramfs-linux.img";
elif test -f (loop)/parabola/boot/x86_64/parabolaiso.img;
then
  set initrd_img="(loop)/parabola/boot/x86_64/parabolaiso.img";
fi;

linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
