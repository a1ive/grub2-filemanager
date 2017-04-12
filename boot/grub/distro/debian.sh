set icon="debian";
set vmlinuz_img="(loop)/live/vmlinuz*";
set initrd_img="(loop)/live/initrd*";
set loopiso="findiso=${isofile}";
if test -f (loop)/GParted*; then
	menuentry "作为 GParted LiveCD 启动" --class pmagic{
	set kcmdline="boot=live config union=overlay username=user";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
fi
menuentry "作为 Debian LiveCD 启动" --class $icon{
	set kcmdline="boot=live config";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Debian LiveCD 启动 (安全模式)" --class $icon{
	set kcmdline="boot=live components memtest noapic noapm nodma nomce nolapic nomodeset nosmp nosplash";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}