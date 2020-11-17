set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/initrd*";
if test -d (loop)/wifislax64; then
    set kcmdline="kbd=us tz=Asia/Shanghai locale=en_US.utf8 rw";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
elif test -d (loop)/wifislax; then
    if test -f (loop)/wifislax/vmlinuz*; then
        set vmlinuz_img="(loop)/wifislax/vmlinuz*";
        set initrd_img="(loop)/wifislax/initrd*";
    fi;
    set kcmdline="noload=006-Xfce load=English";
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
elif test -d (loop)/wifiway; then
    set kcmdline="";
    if [ "$grub_platform" != "efi" ]; then
        kcmdline="${kcmdline} autoexec=telinit~4 vga=788 noload=efi";
    fi;
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
fi;
