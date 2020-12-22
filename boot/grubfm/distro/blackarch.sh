export enable_progress_indicator=1;
set kcmdline="archisodevice=/dev/loop0 earlymodules=loop archisobasedir=blackarch";
set vmlinuz_img="(loop)/blackarch/boot/x86_64/vmlinuz-linux";

if test -f (loop)/blackarch/boot/x86_64/initramfs-linux.img;
then
  set initrd_img="(loop)/blackarch/boot/x86_64/initramfs-linux.img";
elif test -f (loop)/blackarch/blackboot/x86_64/archiso.img;
then
  set initrd_img="(loop)/blackarch/boot/x86_64/archiso.img";
fi;

if test -f (loop)/blackarch/boot/intel_ucode.img;
then
    set initrd_img="${initrd_img} (loop)/blackarch/boot/intel_ucode.img";
fi;
if test -f (loop)/blackarch/boot/amd_ucode.img;
then
    set initrd_img="${initrd_img} (loop)/blackarch/boot/amd_ucode.img";
fi;

linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
