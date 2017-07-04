set icon="slackware";
set vmlinuz_img="(loop)/CDlinux/bzImage";
set initrd_img="(loop)/CDlinux/initrd*";
regexp --set=cdl_dir '^(.*)/.*$' "$isofile"
regexp --set=cdl_img '^.*/(.*)$' "$isofile"
set linux_extra="CDL_IMG=${cdl_img} CDL_DIR=${cdl_dir}";
set kcmdline="";
if [ "${lang}" == "zh_CN" ]; then
	kcmdline="${kcmdline} CDL_LANG=zh_CN.UTF-8";
fi;
if test -f $vmlinuz_img -a -f $initrd_img; then
	menuentry $"Boot CDlinux From ISO" --class $icon{
		linux $vmlinuz_img $kcmdline $linux_extra;
		initrd $initrd_img;
	}
fi;
