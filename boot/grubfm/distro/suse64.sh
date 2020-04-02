set icon="opensuse";
set vmlinuz_img="(loop)/boot/*/loader/linux";
set initrd_img="(loop)/boot/*/loader/initrd";

if [ -d (loop)/LiveOS ];
then
    set kcmdline="rd.live.image splash=silent";
fi;

menuentry $"openSUSE Live" --class $icon{
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
}
menuentry $"openSUSE Live Failsafe" --class $icon{
    linux $vmlinuz_img $kcmdline ide=nodma apm=off noresume edd=off nomodeset 3 $linux_extra;
    initrd $initrd_img;
}
