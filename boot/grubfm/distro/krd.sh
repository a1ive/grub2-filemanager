set icon="gentoo"
set kcmdline="net.ifnames=0 lang=en";
set initrd_img="(loop)/boot/grub/initrd.xz";
if cpuid -l;
then
  set kernel_postfix="x86_64";
else
  set kernel_postfix="x86";
fi;
echo $"Loading ...";
loopback -d md_initrd
loopback -m md_initrd ${initrd_img};
set search_str="\${SUBDIR}/\${ISOLOOP}";
set replace_str="\${ISOLOOP}          ";
set src_file="(md_initrd)/init";
lua ${prefix}/write.lua;
menuentry $"Kaspersky Rescue Disk. Graphic mode (${kernel_postfix})" --class $icon{
    linux (loop)/boot/grub/k-${kernel_postfix} $kcmdline $linux_extra dostartx;
    initrd (md_initrd);
}

menuentry $"Kaspersky Rescue Disk. Limited graphic mode (${kernel_postfix})" --class $icon{
    linux (loop)/boot/grub/k-${kernel_postfix} $kcmdline $linux_extra dostartx nomodeset;
    initrd (md_initrd);
}

menuentry $"Kaspersky Rescue Disk. Text mode (${kernel_postfix})" --class $icon{
    linux (loop)/boot/grub/k-${kernel_postfix} $kcmdline $linux_extra nox nomodeset;
    initrd (md_initrd);
}

menuentry $"Kaspersky Rescue Disk. Hardware Info (${kernel_postfix})" --class $icon{
    linux (loop)/boot/grub/k-${kernel_postfix} $kcmdline $linux_extra docache loadsrm=000-core.srm,003-kl.srm nox hwinfo docheck;
    initrd (md_initrd);
}
