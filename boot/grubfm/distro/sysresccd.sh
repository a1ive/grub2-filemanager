set icon="archlinux"
set kcmdline="archisobasedir=sysresccd";
set vmlinuz_img="(loop)/sysresccd/boot/x86_64/vmlinuz";
set initrd_img="(loop)/sysresccd/boot/intel_ucode.img (loop)/sysresccd/boot/amd_ucode.img (loop)/sysresccd/boot/x86_64/sysresccd.img"

menuentry "Boot SystemRescueCd using default options" {
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}

menuentry "Boot SystemRescueCd and copy system to RAM" {
    linux $vmlinuz_img $kcmdline $linux_extra copytoram;
    initrd $initrd_img;
}
