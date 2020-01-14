set icon="gnu-linux";
set vmlinuz_img="(loop)/syslinux/kernel/bzImage";
set initrd_img="(loop)/syslinux/kernel/initramfs.*";
menuentry "Plop Linux framebuffer mode" --class $icon{
    set kcmdline="vga=0x317";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}
menuentry "Plop Linux text mode" --class $icon{
    set kcmdline="vga=1 nomodeset";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}
menuentry "Plop Linux text mode + copy2ram" --class $icon{
    set kcmdline="vga=1 nomodeset copy2ram";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}
menuentry "Plop Linux framebuffer mode + copy2ram" --class $icon{
    set kcmdline="vga=0x317 nomodeset copy2ram";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}