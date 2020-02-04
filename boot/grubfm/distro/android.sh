export vmlinuz_img="(loop)/kernel";
export initrd_img="(loop)/initrd.img";
export android_selinux="androidboot.selinux=permissive";
export android_hardware=" ";
configfile ${prefix}/distro/andmenu.sh;
