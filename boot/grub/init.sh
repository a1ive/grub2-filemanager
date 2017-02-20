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

set pager=1
insmod all_video; insmod video_bochs; insmod video_cirrus;
insmod efi_gop; insmod efi_uga;
insmod gfxterm; insmod gfxterm_background; insmod gfxmenu;
insmod jpeg; insmod png; insmod tga;
insmod font;
insmod gzio; insmod xzio;
insmod fat;
insmod loopback;
insmod regexp;

search -s -f -q /efi/boot/bootx64.efi

loadfont ${prefix}/fonts/unicode.pf2.xz

set locale_dir=${prefix}/locale; export locale_dir

set lang=zh_CN; export lang

set gfxmode=auto; export gfxmode
set gfxpayload=keep; export gfxpayload
terminal_output gfxterm

set color_normal=white/black
set color_highlight=black/white

set theme=${prefix}/themes/slack/theme.txt; export theme

configfile $prefix/main.sh;
