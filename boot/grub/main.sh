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
	hiddenentry "Reboot" --hotkey=r{
		reboot;
	}
	hiddenentry "Halt" --hotkey=h{
		halt;
	}
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
				fi;
				menuentry "$device [$fs] $label" "$device" --class $icon{
					path="$2"; export path; configfile $prefix/main.sh;
				}
				unset label;unset fs;
			fi;
		done;
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
				lua $prefix/get_name.lua;
				path="$file_name"; export path; configfile $prefix/main.sh;
			}
		done;
		for name in $f_list; do
			if ! regexp --set=file_extn '^.*\.(.*$)' "$name"; then
				file_extn="";
			fi;
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
		done;
	fi;
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
		if regexp 'efi' $grub_platform; then
			menuentry "作为EFI可执行文件运行"  --class uefi{
				chainloader "$file_name";
			}
		fi
	elif regexp 'image' $file_type; then
		menuentry "作为图像打开" --class png{
			background_image "$file_name";
			echo -n "Press [ESC] to continue...";
			sleep --interruptible 999;
			background_image ${prefix}/themes/slack/black.png;
		}
	elif regexp 'disk' $file_type; then
		menuentry "挂载镜像" --class img{
			loopback img "$file_name";
			path=""; export path; configfile $prefix/main.sh;
		}
		if regexp 'pc' $grub_platform; then
			menuentry "使用memdisk加载为软盘" --class img{
				linux16 $prefix/tools/memdisk floppy raw;
				echo "Loading $file_name";
				initrd16 "$file_name";
			}
			menuentry "使用GRUB4DOS加载为软盘" --class img{
				set map_dev="(fd0)";
				lua $prefix/g4d_path.lua;
				linux $prefix/tools/grub.exe --config-file=$g4dcmd;
			}
			menuentry "使用memdisk加载为硬盘" --class img{
				linux16 $prefix/tools/memdisk harddisk raw;
				echo "Loading $file_name";
				initrd16 "$file_name";
			}
			menuentry "使用GRUB4DOS加载为硬盘" --class img{
				set map_dev="(hd0)";
				lua $prefix/g4d_path.lua;
				linux $prefix/tools/grub.exe --config-file=$g4dcmd;
			}
		fi;
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
		if regexp 'pc' $grub_platform; then
			menuentry "使用memdisk加载ISO" --class iso{
				loopback -d loop;
				linux16 $prefix/tools/memdisk iso raw;
				initrd16 "$file_name";
			}
			menuentry "使用GRUB4DOS加载ISO" --class iso{
				set map_dev="(hd32)";
				lua $prefix/g4d_path.lua;
				linux $prefix/tools/grub.exe --config-file=$g4dcmd;
			}
		else
			if regexp 'efi32' "$grub_firmware"; then
				set efi_file="bootia32.efi";
			else
				set efi_file="bootx64.efi";
			fi;
			if test -f "(loop)/efi/boot/${efi_file}"; then
				menuentry "仅加载EFI文件" --class uefi{
					chainloader (loop)/efi/boot/${efi_file};
				}
			fi;
		fi;
	elif regexp 'pf2' $file_type; then
		menuentry "加载pf2字库文件" --class pf2{
			loadfont "$file_name";
		}
	elif regexp 'mod' $file_type; then
		menuentry "加载GRUB 2模块" --class mod{
			insmod "$file_name";
		}
	fi;
	if regexp 'pc' $grub_platform; then
		if file --is-x86-bios-bootsector "$file_name"; then
			menuentry "作为BIOS引导扇区加载"  --class bin{
				chainloader --force "$file_name";
			}
		elif regexp '.*\/[0-9a-zA-Z]+[lL][dD][rR]$' "$file_name"; then
			menuentry "作为NTLDR加载"  --class wim{
				ntldr "$file_name";
			}
		elif regexp '.*\/[bB][oO][oO][tT][mM][gG][rR]$' "$file_name"; then
			menuentry "作为BOOTMGR加载"  --class wim{
				ntldr "$file_name";
			}
		fi;
	fi;
	if file --is-x86-multiboot "$file_name"; then
		menuentry "作为multiboot内核加载"  --class exe{
			multiboot "$file_name";
		}
	elif file --is-x86-multiboot2 "$file_name"; then
		menuentry "作为multiboot2内核加载"  --class exe{
			multiboot2 "$file_name";
		}
	elif file --is-x86-linux "$file_name"; then
		menuentry "作为linux内核加载"  --class exe{
			if regexp 'pc' $grub_platform; then
				linux16 "$file_name";
			else
				linux "$file_name";
			fi;
		}
	fi;
	menuentry "查看文本内容"  --class txt{
		main_ops="text"; export main_ops;
		configfile $prefix/main.sh;
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
	set theme=${prefix}/themes/slack/theme.txt; export theme;
	main;
elif regexp 'open' "$main_ops"; then
	set theme=${prefix}/themes/slack/theme.txt; export theme;
	unset main_ops;
	open;
elif regexp 'llua' "$main_ops"; then
	main_ops="open"; export main_ops;
	lua "$file_name";
	echo -n "Press [ESC] to continue...";
	sleep --interruptible 999;
	export path; configfile $prefix/main.sh;
elif regexp 'text' "$main_ops"; then
	theme=${prefix}/themes/slack/text.txt
	hiddenentry " " --hotkey=n{
		if [ "$encoding" = "gbk" ]; then
			encoding="utf8";
		else
			encoding="gbk";
		fi
		export encoding;
		configfile $prefix/main.sh;
	}
	hiddenentry " " --hotkey=q{
		theme=${prefix}/themes/slack/theme.txt; export theme;
		main_ops="open"; export main_ops; configfile $prefix/main.sh;
	}
	lua $prefix/cat_file.lua;
fi;
