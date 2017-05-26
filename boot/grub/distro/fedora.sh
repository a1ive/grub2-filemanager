set icon="fedora";
set vmlinuz_img="(loop)/isolinux/vmlinuz*";
set initrd_img="(loop)/isolinux/initrd*";
set linux_extra="root=live:CDLABEL=$devlbl iso-scan/filename=$isofile";
if test -f (loop)/images/pxeboot/vmlinuz*; then
			menuentry $"Boot Fedora/CentOS From ISO (Installation CD)" --class $icon{
				linux (loop)/images/pxeboot/vmlinuz* boot=images quiet iso-scan/filename="$isofile" inst.stage2=hd:UUID="$loopuuid";
				initrd (loop)/images/pxeboot/initrd*;
			}
fi
menuentry $"Boot Fedora Live From ISO (Live CD)" --class $icon{
	set kcmdline="rd.live.image quiet";
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}
menuentry $"Boot Fedora From ISO (Live CD, Fail Safe)" --class $icon{
	set kcmdline="rd.live.image nomodeset";
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}
menuentry $"Boot Fedora From ISO (Live CD, Rescue)" --class $icon{
	set kcmdline="rd.live.image rescue";
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}