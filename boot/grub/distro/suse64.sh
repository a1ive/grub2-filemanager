set icon="opensuse";
set vmlinuz_img="(loop)/boot/*/loader/linux";
set initrd_img="(loop)/boot/*/loader/initrd";
set kcmdline="showopts"
menuentry $"OpenSUSE Live" --class $icon{
    set kcmdline="";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}
menuentry $"OpenSUSE Installation" --class $icon{
    linux $vmlinuz_img install=hd:$iso_path splash=silent showopts;
    initrd $initrd_img;
}
menuentry "Upgrade" --class $icon{
    linux $vmlinuz_img install=hd:$iso_path splash=silent upgrade=1 showopts;
    initrd $initrd_img;
}
menuentry "Rescue System" --class $icon{
    linux $vmlinuz_img install=hd:$iso_path splash=silent rescue=1 showopts;
    initrd $initrd_img;
}