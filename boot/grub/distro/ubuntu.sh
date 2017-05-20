set icon="ubuntu";
set vmlinuz_img="(loop)/casper/vmlinuz*";
set initrd_img="(loop)/casper/initrd*";
set loopiso="iso-scan/filename=${isofile}";
menuentry "作为 Ubuntu LiveCD 启动" --class $icon{
	set kcmdline="boot=casper noprompt noeject";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Ubuntu LiveCD 启动 (简体中文)" --class $icon{
	set kcmdline="boot=casper noprompt noeject locale=zh_CN.UTF-8";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Ubuntu LiveCD 启动 (persistent)" --class $icon{
	set kcmdline="boot=casper noprompt noeject persistent";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Ubuntu LiveCD 启动 (简体中文 persistent)" --class $icon{
	set kcmdline="boot=casper noprompt noeject persistent locale=zh_CN.UTF-8";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
