set vmlinuz_img="(loop)/syslinux/alt0/vmlinuz";
set initrd_img="(loop)/syslinux/alt0/full.cz";
set kcmdline="noeject fastboot live lowmem showopts quiet splash live_rw stagename=live";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
