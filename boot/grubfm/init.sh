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

export pager=0;
cat --set=modlist ${prefix}/insmod.lst;
for module in ${modlist};
do
  insmod ${module};
done;
export enable_progress_indicator=0;
export grub_secureboot=$"Not available";
if [ "${grub_platform}" = "efi" ];
then
  search -s -f -q /efi/microsoft/boot/bootmgfw.efi;
  if [ "${grub_cpu}" = "i386" ];
  then
    export EFI_ARCH="ia32";
  elif [ "${grub_cpu}" = "arm64" ];
  then
    export EFI_ARCH="aa64";
  else
    export EFI_ARCH="x64";
  fi;
  search -s -f -q /efi/boot/boot${EFI_ARCH}.efi;
  getenv -t uint8 SecureBoot grub_secureboot;
  if [ "${grub_secureboot}" = "1" ];
  then
    export grub_secureboot=$"Enabled";
    sbpolicy -i;
  fi;
  if [ "${grub_secureboot}" = "0" ];
  then
    export grub_secureboot=$"Disabled";
  fi;
  # enable mouse/touchpad
  # terminal_input --append mouse;
else
  search -s -f -q /fmldr;
fi;

if cpuid -l;
then
  export CPU=64;
else
  export CPU=32;
fi
stat -r -q -s RAM;
export RAM;

loadfont ${prefix}/fonts/unicode.xz;

export locale_dir=${prefix}/locale;
export secondary_locale_dir=${prefix}/locale/fm;

source ${prefix}/lang.sh;

export grub_disable_esc="1";
export gfxmode=1024x768;
export gfxpayload=keep;
terminal_output gfxterm;
export color_normal=white/black;
export color_highlight=black/white;

if [ "${grub_mb_firmware}" = "unknown" ];
then
  terminal_input at_keyboard;
fi;

search --set=aioboot -f -q -n /AIO/grub/grub.cfg;
export aioboot;
search --set=ventoy -f -q -n /ventoy/ventoy.cpio;
export ventoy;

export theme_std=${prefix}/themes/slack/theme.txt;
export theme_fm=${prefix}/themes/slack/fm.txt;
export theme_info=${prefix}/themes/slack/info.txt;
export theme_hw_grub=${prefix}/themes/slack/hwinfo/grub.txt;
export theme_hw_cpu=${prefix}/themes/slack/hwinfo/cpu.txt;
export theme_hw_ram=${prefix}/themes/slack/hwinfo/ram.txt;
export theme_hw_board=${prefix}/themes/slack/hwinfo/board.txt;

export theme=${theme_std};

search --set=user -f -q /boot/grubfm/config;
export user;
if [ -n "${user}" ];
then
  grubfm_set -u "${user}";
  source (${user})/boot/grubfm/config;
fi;

export grubfm_lang="${lang}";

if [ -z "${aioboot}" -a -z "${ventoy}" ];
then
  source ${prefix}/pxeinit.sh;
  net_detect;
fi;
if [ "${grub_netboot}" = "1" ];
then
  configfile ${prefix}/netboot.sh;
else
  grubfm;
fi;
