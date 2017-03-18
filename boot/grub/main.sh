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
function hiddenmenu {
	hiddenentry "Settings" --hotkey=s {
		configfile $prefix/settings.sh;
	}
	hiddenentry "Lua" --hotkey=l {
		lua;
	}
	hiddenentry "Boot" --hotkey=b {
		configfile $prefix/boot.sh;
	}
	#hiddenentry "GRUB Shell" --hotkey=c;
}
function main{
	if test -z "$path"; then
		for device in (*); do
			if test -d "$device"; then
				icon="img";
				probe --set=fs -f "$device";
				probe --set=label -l -q "$device";
				if test "$fs" = "udf" -o "$fs" = "iso9660"; then
					icon="iso";
				elif test "$device" = "(memdisk)" -o "$device" = "(proc)"; then
					continue;
				elif test -w "$device"; then
					icon="hdd";
				fi
				menuentry "$device [$fs] $label" "$device" --class $icon{
					path="$2"; export path; configfile $prefix/main.sh;
				}
				unset label;unset fs;
			fi
		done
	else
		default=1;
		menuentry "返回" --class go-previous{
			if ! regexp --set=lpath '(^.*)/.*$' "$path"; then
				lpath="";
			fi
			path="$lpath"; export path; configfile $prefix/main.sh;
		}
		fm_path="$path"; lua $prefix/enum_file.lua;
		for name in $d_list; do
			file_name="${path}/${name}";
			menuentry "$name" "$file_name" --class dir{
				file_name="$2";
				echo "selected $file_name";
				lua $prefix/get_name.lua;
				echo "real path $file_name";
				path="$file_name"; export path; configfile $prefix/main.sh;
			}
		done
		for name in $f_list; do
			if ! regexp --set=file_extn '^.*\.(.*$)' "$name"; then
				file_extn="";
			fi
			file_name="${path}/${name}";
			lua $prefix/check_type.lua;
			menuentry "$name" "$path" "$file_type" --class $file_icon {
				file_name="$1"; 
				lua $prefix/get_name.lua;
				file_name="$2/${file_name}"; export file_name;
				file_type="$3"; export file_type;
				main_ops="open"; export main_ops;
				export path; configfile $prefix/main.sh;
			}
		done
	fi
	hiddenmenu;
}
function open{
	menuentry "返回"  --class go-previous{
		export path; configfile $prefix/main.sh;
	}
	if regexp 'cfg' $file_type; then
		menuentry "作为Grub2菜单打开"  --class cfg{
			regexp --set=root '^\(([0-9a-zA-Z,]+)\).*$' "$file_name";
			configfile "$file_name";
		}
		menuentry "作为Syslinux菜单打开"  --class cfg{
			regexp --set=root '^\(([0-9a-zA-Z,]+)\).*$' "$file_name";
			syslinux_configfile $file_name;
		}
	elif regexp 'lua' $file_type; then
		menuentry "作为Lua脚本加载"  --class lua{
			regexp --set=root '^\(([0-9a-zA-Z,]+)\).*$' "$file_name";
			main_ops="llua"; export main_ops;
			export path; configfile $prefix/main.sh;
		}
	elif regexp 'efi' $file_type; then
		menuentry "作为EFI可执行文件运行"  --class uefi{
			chainloader "$file_name";
		}
	elif regexp 'image' $file_type; then
		menuentry "作为图像打开" --class png{
			background_image "$file_name";
			echo -n "Press [ESC] to continue...";
			sleep --interruptible 999;
			background_image ${prefix}/themes/slack/black.png
		}
	elif regexp 'disk' $file_type; then
		menuentry "挂载镜像" --class img{
			loopback img "$file_name";
			path=""; export path; configfile $prefix/main.sh;
		}
	elif regexp 'tar' $file_type; then
		menuentry "作为压缩文件打开" --class 7z{
			loopback tar "$file_name";
			path="(tar)"; export path; configfile $prefix/main.sh;
		}
	elif regexp 'iso' $file_type; then
		loopback loop "$file_name";
		menuentry "查看ISO内容"  --class iso{
			path="(loop)"; export path; configfile $prefix/main.sh;
		}
		source $prefix/isoboot.sh;
		CheckLinuxType;
		if test -f (loop)/efi/boot/bootx64.efi; then
			menuentry "运行bootx64.efi (不推荐)" --class iso{
				chainloader (loop)/efi/boot/bootx64.efi;
			}
		fi
	fi
	menuentry "查看文本内容"  --class txt{
		lua $prefix/cat_file.lua;
	}
	menuentry "查看文件信息"  --class info{
		set pager=1;
		echo "Path"; echo "$file_name";
		echo "CRC32"; crc32 "$file_name";
		echo "hexdump"; hexdump "$file_name";
		echo -n "Press [ESC] to continue...";
		sleep --interruptible 999;
	}
	hiddenmenu;
}

if test -z "$main_ops"; then
	main;
elif regexp 'open' "$main_ops"; then
	unset main_ops;
	open;
elif regexp 'llua' "$main_ops"; then
	main_ops="open"; export main_ops;
	lua "$file_name";
	echo -n "Press [ESC] to continue...";
	sleep --interruptible 999;
	export path; configfile $prefix/main.sh;
fi
