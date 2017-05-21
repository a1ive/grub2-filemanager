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
set loopiso="findiso=${isofile}";
function CHSLocale {
	echo "是否使用简体中文？按[Y]选择简体中文，按其他键使用默认语言。";
	getkey key;
	if [ "$key" == "121" ]; then
		kcmdline="${kcmdline} locales=zh_CN.UTF-8";
	fi;
}
function ReadUsername {
	echo "请输入登录用户名？默认:user 超级用户:root Devuan:devuan";
	read username;
	if test -z "$username"; then
		username="user";
	fi;
	kcmdline="${kcmdline} username=${username}";
}
menuentry "作为 Debian LiveCD 启动" --class $icon{
	set kcmdline="boot=live config";
	CHSLocale;
	ReadUsername;
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Debian Overlay CD 启动 (适用于 Clonezilla/GParted)" --class $icon{
	set kcmdline="boot=live config union=overlay";
	CHSLocale;
	ReadUsername;
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Debian LiveCD 启动 (安全模式)" --class $icon{
	set kcmdline="boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}