set icon="gnu-linux";
set imgdevpath="/dev/disk/by-uuid/$devuuid";
if test -f (loop)/kdeos/boot/x86_64/kdeosiso -a -f (loop)/kdeos/boot/x86_64/kdeosiso.img; then
	set vmlinuz_img="(loop)/kdeos/boot/x86_64/kdeosiso";
	set initrd_img="(loop)/kdeos/boot/x86_64/kdeosiso.img";
	set kcmdline="kdeosisodevice=/dev/loop0 earlymodules=loop";
	set linux_extra="img_dev=$imgdevpath img_loop=$isofile kdeisolabel=$devlbl";
	menuentry $"Boot KaOS From ISO" --class $icon{
		linux $vmlinuz_img $kcmdline $linux_extra;
		initrd $initrd_img;
	}
fi;

