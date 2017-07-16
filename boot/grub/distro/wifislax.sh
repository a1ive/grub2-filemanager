set icon="wifislax";
set vmlinuz_img="(loop)/boot/vmlinuz";
set initrd_img="(loop)/boot/initrd*";
if test -f (loop)/wifislax/vmlinuz*; then
	set vmlinuz_img="(loop)/wifislax/vmlinuz*";
	set initrd_img="(loop)/wifislax/initrd*";
fi

if test -d (loop)/wifislax64; then
	menuentry $"Boot Wifislax From ISO" --class $icon{
		set linux_extra="livemedia=/dev/disk/by-uuid/${devuuid}:${isofile}";
		set kcmdline="kbd=us tz=Asia/Shanghai locale=en_US.utf8 rw";
		linux $vmlinuz_img $kcmdline $linux_extra;
		initrd $initrd_img;
	}
elif test -d (loop)/wifislax; then
	menuentry $"Boot Wifislax From ISO" --class $icon{
		set linux_extra="from=$isofile";
		set kcmdline="noload=006-Xfce load=English";
		linux $vmlinuz_img $kcmdline $linux_extra;
		initrd $initrd_img;
	}
elif test -d (loop)/wifiway; then
	menuentry $"Boot Wifiway From ISO" --class $icon{
		set linux_extra="from=$isofile";
		set kcmdline="";
		if [ "$grub_platform" == "pc" ]; then
			kcmdline="${kcmdline} autoexec=telinit~4 vga=788 noload=efi";
		fi;
		linux $vmlinuz_img $kcmdline $linux_extra;
		initrd $initrd_img;
	}
fi