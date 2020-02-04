set icon="gentoo"
set kcmdline="scandelay=1";
set initrd_img="(loop)/isolinux/initram.igz"
menuentry $"Boot System Rescue CD From ISO (x86_64)" --class $icon{
    linux (loop)/isolinux/rescue64 $kcmdline $linux_extra;
    initrd $initrd_img;
}
menuentry $"Boot System Rescue CD From ISO (i686)" --class $icon{
    linux (loop)/isolinux/rescue32 $kcmdline $linux_extra;
    initrd $initrd_img;
}