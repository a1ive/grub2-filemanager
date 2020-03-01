set vmlinuz_img="(loop)/CDlinux/bzImage";
set initrd_img="(loop)/CDlinux/initrd*";
set kcmdline="";
if [ "${lang}" = "zh_CN" ]; then
    kcmdline="${kcmdline} CDL_LANG=zh_CN.UTF-8";
fi;
if test -f $vmlinuz_img -a -f $initrd_img; then
    linux $vmlinuz_img $kcmdline $linux_extra;
    initrd $initrd_img;
fi;
