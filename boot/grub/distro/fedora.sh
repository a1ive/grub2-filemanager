set icon="fedora";
set vmlinuz_img="(loop)/isolinux/vmlinuz*";
set initrd_img="(loop)/isolinux/initrd*";
set loopiso="root=live:CDLABEL=$devlbl iso-scan/filename=$isofile";
if test -f (loop)/images/pxeboot/vmlinuz*; then
			menuentry "作为 Fedora 安装光盘 启动" --class $icon{
				linux (loop)/images/pxeboot/vmlinuz* boot=images quiet iso-scan/filename="$isofile" inst.stage2=hd:UUID="$loopuuid";
				initrd (loop)/images/pxeboot/initrd*;
			}
fi
menuentry "作为 Fedora LiveCD 启动" --class $icon{
	set kcmdline="rd.live.image quiet";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Fedora LiveCD 启动 (安全模式)" --class $icon{
	set kcmdline="rd.live.image nomodeset";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}
menuentry "作为 Fedora LiveCD 启动 (救援模式)" --class $icon{
	set kcmdline="rd.live.image rescue";
	linux $vmlinuz_img $kcmdline $loopiso;
	initrd $initrd_img;
}