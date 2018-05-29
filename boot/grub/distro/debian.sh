set icon="debian";
if test -f (loop)/live/vmlinuz; then
	set vmlinuz_img="(loop)/live/vmlinuz";
else
	set vmlinuz_img="(loop)/live/vmlinuz*";
fi;
if test -f (loop)/live/initrd.img; then
	set initrd_img="(loop)/live/initrd.img";
else
	set initrd_img="(loop)/live/initrd.*";
fi;
function CHSLocale {
	echo "是否使用简体中文？按[Y]选择简体中文，按其他键使用默认语言。";
	getkey key;
	if [ "$key" = "121" ]; then
		kcmdline="${kcmdline} locales=zh_CN.UTF-8";
	fi;
}
function ReadUsername {
	echo $"Please input the username. Default:user Super User:root Devuan:devuan";
	read username;
	if test -z "$username"; then
		username="user";
	fi;
	kcmdline="${kcmdline} username=${username}";
}
menuentry $"Debian Live" --class $icon{
	set kcmdline="boot=live config";
	if [ "${lang}" = "zh_CN" ]; then
		CHSLocale;
	fi;
	ReadUsername;
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}
menuentry $"Debian Live union=overlay (Clonezilla/GParted)" --class $icon{
	set kcmdline="boot=live config union=overlay";
	if [ "${lang}" = "zh_CN" ]; then
		CHSLocale;
	fi;
	ReadUsername;
	linux $vmlinuz_img $kcmdline $linux_extra;
	initrd $initrd_img;
}
