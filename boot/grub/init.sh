# Grub2-FileManager
# Copyright (C) 2016,2017,2018  A1ive.
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
if [ "$grub_platform" = "pc" ]; then
	bqcat ${prefix}/insmod.lst modlist
else
	modlist="all_video video_bochs video_cirrus efi_gop efi_uga gfxterm gfxterm_background gfxmenu jpeg png tga font";
	search -s -f -q /efi/microsoft/boot/bootmgfw.efi;
	if regexp 'i386' "$grub_cpu"; then
		search -s -f -q /efi/boot/bootia32.efi;
	else
		search -s -f -q /efi/boot/bootx64.efi;
	fi;
fi;
for module in $modlist; do
	insmod $module;
done;
export enable_progress_indicator=0;
export grub_disable_esc="1";
loadfont ${prefix}/fonts/unicode.xz;
export locale_dir=${prefix}/locale;
export secondary_locale_dir=${prefix}/locale/fm;
source ${prefix}/lang.sh; export lang;
export gfxmode=1024x768;
export gfxpayload=keep;
terminal_output gfxterm;
set color_normal=white/black;
set color_highlight=black/white;
export encoding="utf8";
export enable_sort="1";
lua $prefix/main.lua;
