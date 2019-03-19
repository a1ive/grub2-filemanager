set icon="debian";
set vmlinuz_img="(loop)/antiX/vmlinuz";
set initrd_img="(loop)/antiX/initrd.gz";
menuentry $"antiX Live" --class $icon{
    set kcmdline="splash=v disable=lx";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}
menuentry $"antiX Fail Safe" --class $icon{
    set kcmdline="splash=v disable=lx nomodeset failsafe";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}
