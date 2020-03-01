set vmlinuz_img="(loop)/boot/isolinux/vmlinuz";
set initrd_img="(loop)/boot/isolinux/instroot";
set kcmdline="vga=791";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
