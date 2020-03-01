menuentry $"Android-x86 Live" --class android{
    set kcmdline="root=/dev/ram0";
    linux $vmlinuz_img $kcmdline $android_selinux $android_hardware $linux_extra;
    initrd $initrd_img;
}
if [ "${android_selinux}" = " " ]; then
    menuentry "[ ] androidboot.selinux=permissive"{
        export android_selinux="androidboot.selinux=permissive";
        configfile ${prefix}/distro/andmenu.sh
    }
else
    menuentry "[+] androidboot.selinux=permissive"{
        export android_selinux=" ";
        configfile ${prefix}/distro/andmenu.sh;
    }
fi;
if [ "${android_hardware}" = " " ]; then
    menuentry "[ ] androidboot.hardware=android_x86"{
        export android_hardware="androidboot.hardware=android_x86";
        configfile ${prefix}/distro/andmenu.sh
    }
else
    menuentry "[+] androidboot.hardware=android_x86"{
        export android_hardware=" ";
        configfile ${prefix}/distro/andmenu.sh;
    }
fi;
