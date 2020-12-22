set icon="archlinux"
set kcmdline="archisobasedir=sysresccd";
set vmlinuz_img="(loop)/sysresccd/boot/x86_64/vmlinuz";
set initrd_img="(loop)/sysresccd/boot/x86_64/sysresccd.img";

if test -f (loop)/sysresccd/boot/intel_ucode.img;
then
  set initrd_img="${initrd_img} (loop)/sysresccd/boot/intel_ucode.img";
fi;
if test -f (loop)/sysresccd/boot/amd_ucode.img;
then
  set initrd_img="${initrd_img} (loop)/sysresccd/boot/amd_ucode.img";
fi;

menuentry "Boot SystemRescueCd using default options" {
  export enable_progress_indicator=1;
  linux $vmlinuz_img $kcmdline $linux_extra;
  initrd $initrd_img;
}

menuentry "Boot SystemRescueCd and copy system to RAM" {
  export enable_progress_indicator=1;
  linux $vmlinuz_img $kcmdline $linux_extra copytoram;
  initrd $initrd_img;
}
