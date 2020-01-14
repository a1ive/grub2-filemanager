if test -f (loop)/live/vmlinuz; then
    export vmlinuz_img="(loop)/live/vmlinuz";
else
    export vmlinuz_img="(loop)/live/vmlinuz*";
fi;
if test -f (loop)/live/initrd.img; then
    export initrd_img="(loop)/live/initrd.img";
else
    export initrd_img="(loop)/live/initrd*";
fi;
if [ "${lang}" = "zh_CN" ]; then
    export debian_locale="locales=zh_CN.UTF-8";
elif [ "${lang}" = "zh_TW" ]; then
    export debian_locale="locales=zh_TW.UTF-8";
else
    export debian_locale="";
fi;
export debian_user="username=user";
export debian_union="";
export debian_toram="";
configfile ${prefix}/distro/debmenu.sh;