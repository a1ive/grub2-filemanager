# Grub2-FileManager
# Copyright (C) 2016,2017,2018,2019,2020  A1ive.
#
# Grub2-FileManager is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Grub2-FileManager is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Grub2-FileManager.  If not, see <http://www.gnu.org/licenses/>.

set pager=0;
cat --set=modlist ${prefix}/insmod.lst;
for module in ${modlist};
do
    insmod ${module};
done;
export enable_progress_indicator=0;

if [ "${grub_platform}" = "efi" ];
then
    search -s -f -q /efi/microsoft/boot/bootmgfw.efi;
    if [ "${grub_cpu}" = "i386" ];
    then
        search -s -f -q /efi/boot/bootia32.efi;
    else
        search -s -f -q /efi/boot/bootx64.efi;
    fi;
    efiload ${prefix}/CrScreenshotDxe.efi;
    getenv -t uint8 SecureBoot grub_secureboot;
    if [ "${grub_secureboot}" = "0" ];
    then
        export grub_secureboot="Disabled";
    else
        export grub_secureboot="Enabled";
    fi;
else
    search -s -f -q /fmldr;
    export grub_secureboot="Not available";
fi;

if cpuid -l;
then
  export CPU=64;
else
  export CPU=32;
fi

loadfont ${prefix}/fonts/unicode.xz;

export locale_dir=${prefix}/locale;
export secondary_locale_dir=${prefix}/locale/fm;

source ${prefix}/lang.sh;

export grub_disable_esc="1";
export gfxmode=1024x768;
export gfxpayload=keep;
terminal_output gfxterm;
set color_normal=white/black;
set color_highlight=black/white;

export theme_std=${prefix}/themes/slack/theme.txt;
export theme_fm=${prefix}/themes/slack/fm.txt;
export theme_open=${prefix}/themes/slack/open.txt;
export theme_help=${prefix}/themes/slack/help.txt;
export theme_info=${prefix}/themes/slack/info.txt;
export theme_settings=${prefix}/themes/slack/settings.txt;
export theme_osdetect=${prefix}/themes/slack/osdetect.txt;
export theme_netboot=${prefix}/themes/slack/netboot.txt;
export theme_power=${prefix}/themes/slack/power.txt;

export theme=${theme_std};

search --set=user -f -q /boot/grubfm/config;
if [ -n "${user}" ];
then
  grubfm_set -u "${user}";
  source (${user})/boot/grubfm/config;
fi;

search --set=user_menu -f -q /boot/grubfm/menu.cfg;
if [ -n "${user_menu}" ];
then
  export theme_std=${prefix}/themes/slack/theme_um.txt;
  export theme_fm=${prefix}/themes/slack/fm_um.txt;
  export theme_open=${prefix}/themes/slack/open_um.txt;
  export theme_help=${prefix}/themes/slack/help_um.txt;
  export theme_info=${prefix}/themes/slack/info_um.txt;
  export theme_settings=${prefix}/themes/slack/settings_um.txt;
  export theme_user_menu=${prefix}/themes/slack/user_menu.txt;
  export theme_osdetect=${prefix}/themes/slack/osdetect_um.txt;
  export theme_netboot=${prefix}/themes/slack/netboot_um.txt;
  export theme_power=${prefix}/themes/slack/power_um.txt;
  grubfm_set -u "${user_menu}";
  configfile ${prefix}/user_menu.sh
fi;

source ${prefix}/pxeinit.sh;
net_detect;
if [ "${grub_netboot}" = "1" ];
then
  configfile ${prefix}/netboot.sh;
else
  export theme=${theme_fm};
  grubfm;
fi;

