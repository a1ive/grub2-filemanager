if [ -f "${theme_menu}" ];
then
  export theme=${theme_menu};
fi;

videomode -c mode_current;

source (${user})/boot.cfg;
source ${prefix}/global.sh;
