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
set debug=off;
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
        export grub_secureboot=$"Disabled";
    else
        export grub_secureboot=$"Enabled";
    fi;
else
    search -s -f -q /fmldr;
    export grub_secureboot=$"Not available";
fi;

if cpuid -l;
then
  export CPU=64;
else
  export CPU=32;
fi

loadfont ${prefix}/fonts/unicode.xz;
loadfont ${prefix}/fonts/dosvga.pf2;

export locale_dir=${prefix}/locale;
export secondary_locale_dir=${prefix}/locale/fm;

source ${prefix}/lang.sh;

export grub_disable_esc="1";
export gfxmode=1024x768;
export gfxpayload=keep;
terminal_output gfxterm;
set color_normal=white/black;
set color_highlight=black/white;

#Uncomment the next line to enable animation
#export grub_frame_speed=110;
#Uncomment the next line to enable sound
#export grub_sound_speed=110;
#export grub_sound_start="220 277 330 440 185 220 277 370 294 370 440 587 330 415 494 659";
#export grub_sound_select="880 0 880 0 880 698 1046";
#Uncomment below code and copy samples/splash/* to boot/grub/themes/slack/ to load Windows 10 splash screen
#set theme=$prefix/themes/slack/splash10.txt
export theme=${prefix}/themes/slack/theme.txt;
#set timeout=7
#menuentry "" {
source ${prefix}/pxeinit.sh;
net_detect;
if [ "${grub_netboot}" = "1" ];
then
  configfile ${prefix}/netboot.sh;
else
  grubfm;
fi;
#}
