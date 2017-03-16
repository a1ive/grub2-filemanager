set icon="wifislax";
set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/initrd*";
if test -f (loop)/wifislax/vmlinuz*; then
	set vmlinuz_img="(loop)/wifislax/vmlinuz*";
	set initrd_img="(loop)/wifislax/initrd*";
fi
set loopiso="from=$isofile";
if test -d (loop)/wifislax64; then
	menuentry "作为 Wifislax64 LiveCD 启动" --class $icon{
		set kcmdline="kbd=us tz=Asia/Shanghai locale=en_US.utf8 rw";
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
else
	menuentry "作为 Wifislax LiveCD 启动" --class $icon{
		set kcmdline="noload=006-Xfce load=English";
		linux $vmlinuz_img $kcmdline $loopiso;
		initrd $initrd_img;
	}
fi