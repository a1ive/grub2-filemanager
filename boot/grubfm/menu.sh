if [ -f "${theme_menu}" ];
then
  export theme=${theme_menu};
fi;

videomode -c mode_current;

if [ -n "${user_menu}" ];
then
  source (${user_menu})/boot/grubfm/menu.cfg;
fi;

source ${prefix}/global.sh;
