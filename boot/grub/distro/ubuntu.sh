set icon="ubuntu";
set vmlinuz_img="(loop)/casper/vmlinuz*";
set initrd_img="(loop)/casper/initrd*";
set loopiso="iso-scan/filename=${isofile}";
menuentry "作为 Ubuntu LiveCD 启动" --class $icon{
	set kcmdline="boot=casper noprompt noeject";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}