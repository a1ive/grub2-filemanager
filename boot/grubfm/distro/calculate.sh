set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/initrd";
set kcmdline="vga=791 init=/linuxrc rd.live.squashimg=livecd.squashfs nodevfs quiet noresume splash=silent,theme:calculate console=tty1";
linux $vmlinuz_img $kcmdline $linux_extra;
initrd $initrd_img;
