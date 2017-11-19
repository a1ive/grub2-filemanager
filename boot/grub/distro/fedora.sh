set icon="fedora";
set vmlinuz_img="(loop)/isolinux/vmlinuz*";
set initrd_img="(loop)/isolinux/initrd*";
if test -f (loop)/boot/vmlinuz -a -f (loop)/boot/initrd; then
	vmlinuz_img=(loop)/boot/vmlinuz;
	initrd_img=(loop)/boot/initrd;
fi;
if test -f (loop)/images/pxeboot/vmlinuz*; then
	menuentry $"Boot Fedora/CentOS From ISO (Installation CD)" --class $icon{
		linux (loop)/images/pxeboot/vmlinuz* boot=images quiet iso-scan/filename="$iso_path" inst.stage2=hd:UUID="$iso_uuid";
		initrd (loop)/images/pxeboot/initrd*;
	}
fi;
if test -f $vmlinuz_img -a -f $initrd_img; then
	menuentry $"Boot Fedora From ISO (Live CD)" --class $icon{
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
fi;