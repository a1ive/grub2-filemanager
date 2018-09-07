menuentry $"Debian Live" --class $icon{
	set kcmdline="boot=live config";
	linux $vmlinuz_img $kcmdline $debian_user $debian_union $debian_locale $linux_extra;
	initrd $initrd_img;
}
menuentry $"Devuan Live" --class $icon{
	set kcmdline="boot=live config username=devuan";
	linux $vmlinuz_img $kcmdline $debian_union $debian_locale $linux_extra;
	initrd $initrd_img;
}
menuentry $"Tails Live" --class $icon{
	set kcmdline="boot=live config live-media=removable nopersistence noprompt timezone=Etc/UTC block.events_dfl_poll_msecs=1000 splash noautologin module=Tails slab_nomerge slub_debug=FZP mce=0 vsyscall=none page_poison=1 union=aufs";
	linux $vmlinuz_img $kcmdline $debian_locale $linux_extra;
	initrd $initrd_img;
}
if [ "${debian_user}" == "username=root" ]; then
	menuentry "[+] Root Login"{
		set debian_user="username=user";
		configfile ${prefix}/distro/debmenu.sh;
	}
	else
	menuentry "[ ] Root Login"{
		set debian_user="username=root";
		configfile ${prefix}/distro/debmenu.sh
	}
fi;
if [ "${debian_union}" == "union=overlay" ]; then
	menuentry "[+] Overlay"{
		set debian_union="";
		configfile ${prefix}/distro/debmenu.sh;
	}
	else
	menuentry "[ ] Overlay"{
		set debian_union="union=overlay";
		configfile ${prefix}/distro/debmenu.sh
	}
fi;
if [ "${debian_locale}" == "locales=zh_CN.UTF-8" ]; then
	menuentry "[+] Simplified Chinese locale"{
		set debian_locale="";
		configfile ${prefix}/distro/debmenu.sh;
	}
	else
	menuentry "[ ] Simplified Chinese locale"{
		set debian_union="locales=zh_CN.UTF-8";
		configfile ${prefix}/distro/debmenu.sh
	}
fi;