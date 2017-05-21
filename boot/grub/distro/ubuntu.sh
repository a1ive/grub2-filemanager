set icon="ubuntu";
set vmlinuz_img="(loop)/casper/vmlinuz*";
set initrd_img="(loop)/casper/initrd*";
set loopiso="iso-scan/filename=${isofile}";
function CHSLocale {
	echo "是否使用简体中文？按[Y]选择简体中文，按其他键使用默认语言。";
	getkey key;
	if [ "$key" == "121" ]; then
		kcmdline="${kcmdline} locale=zh_CN.UTF-8";
	fi;
}
menuentry "作为 Ubuntu LiveCD 启动" --class $icon{
	set kcmdline="boot=casper noprompt noeject";
	CHSLocale;
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Ubuntu LiveCD 启动 (persistent)" --class $icon{
	set kcmdline="boot=casper noprompt noeject persistent";
	CHSLocale;
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}