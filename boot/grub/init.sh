# Grub2-FileManager
# Copyright (C) 2016,2017  A1ive.
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

set pager=0; export pager;
set debug= ; export debug;
if regexp 'pc' "$grub_platform"; then
	modlist="all_video bitmap bitmap_scale blocklist bsd cat cmp cpuid crc datetime dd disk drivemap elf file getkey gfxmenu gfxterm gfxterm_background gfxterm_menu gptsync hashsum hexdump jpeg loadenv lsapm macho memdisk multiboot multiboot2 net offsetio parttool png procfs progress random search_fs_uuid search_label sendkey squash4 syslinuxcfg terminfo tga time trig true vbe vga video video_bochs video_cirrus video_colors video_fb videoinfo xnu";
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
set enable_progress_indicator=0; export enable_progress_indicator;
loadfont ${prefix}/fonts/unicode.xz;
set locale_dir=${prefix}/locale;set secondary_locale_dir=${prefix}/locale/fm;
export locale_dir; export secondary_locale_dir;
source ${prefix}/lang.sh; export lang;
set gfxmode=1024x768; export gfxmode;
set gfxpayload=keep; export gfxpayload;
terminal_output gfxterm;
set color_normal=white/black;
set color_highlight=black/white;
set encoding="utf8"; export encoding;
set enable_sort=1; export enable_sort;
set action="genlst"; export action;
configfile $prefix/clean.sh;
