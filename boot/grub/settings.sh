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
menuentry "编码设置(D): $encoding" --class settings --hotkey=d {
	if [ "$encoding" = "gbk" ]; then
		encoding="utf8";
	else
		encoding="gbk";
	fi
	export encoding;
	configfile $prefix/settings.sh;
}
submenu "分辨率设置(R):  $gfxmode" --class settings --hotkey=r {
	terminal_output console
	menuentry "[0] AUTO DETECT" --hotkey=0{
		set gfxmode=auto
		terminal_output gfxterm
		configfile $prefix/settings.sh;	
	}
	menuentry "[1] 640x480" --hotkey=1{
		set gfxmode=640x480
		terminal_output gfxterm
		configfile $prefix/settings.sh;	
	}
	menuentry "[2] 800x600" --hotkey=2{
		set gfxmode=800x600
		terminal_output gfxterm
		configfile $prefix/settings.sh;
	}
	menuentry "[3] 1024x768" --hotkey=3{
		set gfxmode=1024x768
		terminal_output gfxterm
		configfile $prefix/settings.sh;
	}
	menuentry "[4] 1280x1024" --hotkey=4{
		set gfxmode=1280x1024
		terminal_output gfxterm
		configfile $prefix/settings.sh;
	}
	menuentry "[5] 1366x768" --hotkey=5{
		set gfxmode=1366x768
		terminal_output gfxterm
		configfile $prefix/settings.sh;
	}
	menuentry "[6] 1600x1200" --hotkey=6{
		set gfxmode=1600x1200
		terminal_output gfxterm
		configfile $prefix/settings.sh;
	}
	menuentry "[7] 1920x1080" --hotkey=7{
		set gfxmode=1920x1080
		terminal_output gfxterm
		configfile $prefix/settings.sh;
	}
	menuentry "[8] 1920x1440" --hotkey=8{
		set gfxmode=1920x1440
		terminal_output gfxterm
		configfile $prefix/settings.sh;
	}
	menuentry "[9] 2160x1440" --hotkey=9{
		set gfxmode=2160x1440
		terminal_output gfxterm
		configfile $prefix/settings.sh;
	}
}
if regexp 'efi' "$grub_platform"; then
	menuentry "EFI固件设置(F)" --class settings --hotkey=f {
		fwsetup;
	}
fi
menuentry "返回(B)" --class go-previous --hotkey=b {
	configfile $prefix/main.sh;
}