export enable_progress_indicator=1;
if test -f (loop)/arch/boot/x86_64/vmlinuz*;
then
  set vmlinuz_img="(loop)/arch/boot/x86_64/vmlinuz*";
  set kcmdline="archisodevice=/dev/loop0 earlymodules=loop";
elif test -f (loop)/boot/vmlinuz_x86_64;
then
  set vmlinuz_img="(loop)/boot/vmlinuz_x86_64";
  set kcmdline="";
elif test -f (loop)/arch/boot/vmlinuz*;
then
  set vmlinuz_img="(loop)/arch/boot/vmlinuz*";
  set kcmdline="archisobasedir=arch earlymodules=loop modules-load=loop";
fi;

if test -f (loop)/arch/boot/x86_64/initramfs-linux.img;
then
  set initrd_img="(loop)/arch/boot/x86_64/initramfs-linux.img";
elif test -f (loop)/arch/boot/x86_64/archiso.img;
then
  set initrd_img="(loop)/arch/boot/x86_64/archiso.img";
elif test -f (loop)/boot/initramfs_x86_64.img;
then
  set initrd_img="(loop)/boot/initramfs_x86_64.img";
elif test -f (loop)/arch/boot/archiso.img;
then
  set initrd_img="(loop)/arch/boot/archiso.img";
fi;

if test -f (loop)/arch/boot/intel_ucode.img;
then
  set initrd_img="${initrd_img} (loop)/arch/boot/intel_ucode.img";
fi;
if test -f (loop)/arch/boot/amd_ucode.img;
then
  set initrd_img="${initrd_img} (loop)/arch/boot/amd_ucode.img";
fi;

linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
