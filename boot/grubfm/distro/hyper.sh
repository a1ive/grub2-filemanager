export enable_progress_indicator=1;
set vmlinuz_img="(loop)/hyperbola/boot/x86_64/vmlinuz";
set kcmdline="hyperisobasedir=hyperbola earlymodules=loop";

if test -f (loop)/hyperbola/boot/x86_64/initramfs-linux.img;
then
  set initrd_img="(loop)/hyperbola/boot/x86_64/initramfs-linux.img";
elif test -f (loop)/hyperbola/boot/x86_64/hyperiso.img;
then
  set initrd_img="(loop)/hyperbola/boot/x86_64/hyperiso.img";
fi;

linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
