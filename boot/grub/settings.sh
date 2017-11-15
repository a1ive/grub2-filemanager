# Grub2-FileManager
# Copyright (C) 2017  A1ive.
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
unset open_sesame;
set theme=${prefix}/themes/slack/extern.txt; export theme;
function setgfx{
	set gfxmode="$1";
	terminal_output gfxterm;
	configfile $prefix/settings.sh;
}
menuentry $"Encoding: $encoding" --class settings {
	if [ "$encoding" = "gbk" ]; then
		encoding="utf8";
	else
		encoding="gbk";
	fi
	export encoding;
	configfile $prefix/settings.sh;
}
menuentry $"Sort files by name: $enable_sort" --class settings {
	if [ "$enable_sort" = "1" ]; then
		enable_sort="0";
	else
		enable_sort="1";
	fi
	export enable_sort;
	configfile $prefix/settings.sh;
}
submenu $"Resolution (R):  $gfxmode" --class settings --hotkey=r {
	terminal_output console
	menuentry "[0] AUTO DETECT" --hotkey=0{
		setgfx "auto";
	}
	menuentry "[1] 640x480" --hotkey=1{
		setgfx "640x480";
	}
	menuentry "[2] 1024x768" --hotkey=2{
		setgfx "1024x768";
	}
	menuentry "[3] 1280x1024" --hotkey=3{
		setgfx "1280x1024";
	}
	menuentry "[4] 1366x768" --hotkey=4{
		setgfx "1366x768";
	}
	menuentry "[5] 1600x1200" --hotkey=5{
		setgfx "1600x1200";
	}
	menuentry "[6] 1920x1080" --hotkey=6{
		setgfx "1920x1080";
	}
	menuentry "[7] 1920x1440" --hotkey=7{
		setgfx "1920x1440";
	}
	menuentry "[8] 2160x1440" --hotkey=8{
		setgfx "2160x1440";
	}
}
if regexp 'efi' "$grub_platform"; then
	menuentry $"EFI Firmware Setup" --class settings {
		fwsetup;
	}
fi
menuentry $"Back" --class go-previous {
	configfile $prefix/clean.sh;
}