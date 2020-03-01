set icon="chakra";
set vmlinuz_img="(loop)/manjaro/boot/*/vmlinuz*";
set initrd_img="(loop)/manjaro/boot/*/initramfs*";
menuentry $"Chakra" --class $icon{
    set kcmdline="earlymodules=loop nonfree=no xdriver=no";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}
menuentry $"Chakra (non-free drivers)" --class $icon{
    set kcmdline="earlymodules=loop nonfree=yes xdriver=no radeon.modeset=0 nouveau.modeset=0 i915.modeset=1 showopts";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}
