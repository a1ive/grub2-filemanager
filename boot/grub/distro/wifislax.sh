set icon="wifislax";
set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/initrd*";
if test -f (loop)/wifislax/vmlinuz*; then
	set vmlinuz_img="(loop)/wifislax/vmlinuz*";
	set initrd_img="(loop)/wifislax/initrd*";
fi

if test -d (loop)/wifislax64; then
	menuentry $"Boot Wifislax From ISO" --class $icon{
		set loopiso="livemedia=/dev/disk/by-uuid/${devuuid}:${isofile}";
		set kcmdline="kbd=us tz=Asia/Shanghai locale=en_US.utf8 rw";
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
else
	menuentry $"Boot Wifislax From ISO" --class $icon{
		set loopiso="from=$isofile";
		set kcmdline="noload=006-Xfce load=English";
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
fi