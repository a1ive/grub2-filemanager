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
# memdisk iso|floppy|harddisk $file
function memdisk{
	set memdisk=$prefix/memdisk;
	linux16 $memdisk $1 raw;
	echo "Loading $file_name [type=$1]";
	enable_progress_indicator=1;
	initrd16 "$2";
	boot;
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
		menuentry $"Back" --class go-previous{
			if ! regexp --set=lpath '(^.*)/.*$' "$path"; then
				lpath="";
			fi
			path="$lpath"; export path; configfile $prefix/main.sh;
		}
		fm_path="$path"; lua $prefix/enum_file.lua;
		for name in $d_list; do
			file_name="${path}/${name}";
			menuentry "${name}" "$file_name" --class dir{
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
	menuentry $"Back"  --class go-previous{
		export path; configfile $prefix/main.sh;
	}
	if regexp 'cfg' $file_type; then
		menuentry $"Open As Grub2 Menu"  --class cfg{
			regexp --set=root '^\(([0-9a-zA-Z,]+)\).*$' "$file_name";
			configfile "$file_name";
		}
		menuentry $"Open As Syslinux Menu"  --class cfg{
			regexp --set=root '^\(([0-9a-zA-Z,]+)\).*$' "$file_name";
			syslinux_configfile $file_name;
		}
	elif regexp 'lst' $file_type; then
		if regexp 'pc' $grub_platform; then
			menuentry $"Open As GRUB4DOS Menu"  --class cfg{
				set g4d_param="config";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
			}
		else
			menuentry $"Open As GRUB-Legacy Menu"  --class cfg{
				regexp --set=root '^\(([0-9a-zA-Z,]+)\).*$' "$file_name";
				legacy_configfile "$file_name";
			}
		fi;
	elif regexp 'lua' $file_type; then
		menuentry $"Open As Lua Script"  --class lua{
			regexp --set=root '^\(([0-9a-zA-Z,]+)\).*$' "$file_name";
			main_ops="llua"; export main_ops;
			export path; configfile $prefix/main.sh;
		}
	elif regexp 'efi' $file_type; then
		if regexp 'efi' $grub_platform; then
			menuentry $"Open As EFI"  --class uefi{
				chainloader "$file_name";
			}
		fi
	elif regexp 'image' $file_type; then
		menuentry $"Open As Image" --class png{
			background_image "$file_name";
			echo -n $"Press [ESC] to continue...";
			sleep --interruptible 999;
			background_image ${prefix}/themes/slack/black.png;
		}
	elif regexp 'disk' $file_type; then
		menuentry $"Mount Image" --class img{
			loopback img "$file_name";
			path=""; export path; configfile $prefix/main.sh;
		}
		if regexp 'pc' $grub_platform; then
			menuentry $"Boot Floppy Image (GRUB4DOS MEM)" --class img{
				set g4d_param="fd mem";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
			}
			menuentry $"Boot Floppy Image (GRUB4DOS)" --class img{
				set g4d_param="fd";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
			}
			menuentry $"Boot Floppy Image (memdisk)" --class img{
				memdisk floppy "$file_name";
			}
			menuentry $"Boot Hard Drive Image (GRUB4DOS MEM)" --class img{
				set g4d_param="hd mem";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
			}
			menuentry $"Boot Hard Drive Image (GRUB4DOS)" --class img{
				set g4d_param="hd";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
			}
			menuentry $"Boot Hard Drive Image (memdisk)" --class img{
				memdisk harddisk "$file_name";
			}
		fi;
	elif regexp 'fba' $file_type; then
		menuentry $"Mount Image" --class img{
			loopback ud "$file_name";
			path="(ud)"; export path; configfile $prefix/main.sh;
		}
	elif regexp 'tar' $file_type; then
		menuentry $"Open As Archiver" --class 7z{
			loopback tar "$file_name";
			path="(tar)"; export path; configfile $prefix/main.sh;
		}
	elif regexp 'wim' $file_type; then
		if regexp 'pc' $grub_platform; then
			if search -f /NTBOOT.MOD/NTBOOT.NT6; then
				menuentry $"Boot NT6.x WIM (NTBOOT)" --class wim{
					set g4d_param="ntboot";
					lua $prefix/g4d_path.lua;
					linux $grub4dos --config-file=$g4dcmd;
				}
			fi;
			if search -f /NTBOOT.MOD/NTBOOT.PE1; then
				menuentry $"Boot NT5.x WIM (NTBOOT)" --class wim{
					set g4d_param="peboot";
					lua $prefix/g4d_path.lua;
					linux $grub4dos --config-file=$g4dcmd;
				}
			fi;
		fi;
	elif regexp 'wpe' $file_type; then
		if regexp 'pc' $grub_platform; then
			if search -f /NTBOOT.MOD/NTBOOT.PE1; then
				menuentry $"Boot NT5.x PE (NTBOOT)" --class windows{
					set g4d_param="peboot";
					lua $prefix/g4d_path.lua;
					linux $grub4dos --config-file=$g4dcmd;
				}
			fi;
		fi;
	elif regexp 'vhd' $file_type; then
		if regexp 'pc' $grub_platform; then
			if search -f /NTBOOT.MOD/NTBOOT.NT6; then
				menuentry $"Boot Windows NT6.x VHD/VHDX (NTBOOT)" --class img{
					set g4d_param="ntboot";
					lua $prefix/g4d_path.lua;
					linux $grub4dos --config-file=$g4dcmd;
				}
			fi;
		fi;
	elif regexp 'iso' $file_type; then
		loopback loop "$file_name";
		menuentry $"Mount ISO"  --class iso{
			path="(loop)"; export path; configfile $prefix/main.sh;
		}
		source $prefix/isoboot.sh;
		CheckLinuxType;
		if regexp 'pc' $grub_platform; then
			menuentry $"Boot ISO (GRUB4DOS)" --class iso{
				set g4d_param="cd";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
			}
			menuentry $"Boot ISO (Easy2Boot)" --class iso{
				source $prefix/easy2boot.sh;
			}
			menuentry $"Boot ISO (GRUB4DOS MEM)" --class iso{
				set g4d_param="cd mem";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
			}
			menuentry $"Boot ISO (memdisk)" --class iso{
				memdisk iso "$file_name";
			}
		else
			if regexp 'i386' "$grub_cpu"; then
				set efi_file="bootia32.efi";
			else
				set efi_file="bootx64.efi";
			fi;
			if test -f "(loop)/efi/boot/${efi_file}"; then
				menuentry $"Boot EFI Files" --class uefi{
					chainloader (loop)/efi/boot/${efi_file};
				}
			fi;
		fi;
	elif regexp 'pf2' $file_type; then
		menuentry $"Open As Font" --class pf2{
			loadfont "$file_name";
		}
	elif regexp 'mod' $file_type; then
		menuentry $"Insert Grub2 Module" --class mod{
			insmod "$file_name";
		}
	fi;
	if regexp 'pc' $grub_platform; then
		if file --is-x86-bios-bootsector "$file_name"; then
			menuentry $"Chainload BIOS Boot Sector"  --class bin{
				chainloader --force "$file_name";
			}
		elif regexp '.*\/[0-9a-zA-Z]+[lL][dD][rR]$' "$file_name"; then
			menuentry $"Chainload NTLDR"  --class wim{
				ntldr "$file_name";
			}
		elif regexp '.*\/[bB][oO][oO][tT][mM][gG][rR]$' "$file_name"; then
			menuentry $"Chainload BOOTMGR"  --class wim{
				ntldr "$file_name";
			}
		fi;
		menuentry $"Open As GRUB4DOS MOD"  --class bin{
			set g4d_param="command";
			lua $prefix/g4d_path.lua;
			linux $grub4dos --config-file=$g4dcmd;
		}
	fi;
	if file --is-x86-multiboot "$file_name"; then
		menuentry $"Boot Multiboot Kernel"  --class exe{
			multiboot "$file_name";
		}
	elif file --is-x86-multiboot2 "$file_name"; then
		menuentry $"Boot Multiboot2 Kernel"  --class exe{
			multiboot2 "$file_name";
		}
	elif file --is-x86-linux "$file_name"; then
		menuentry $"Boot Linux Kernel"  --class exe{
			if regexp 'pc' $grub_platform; then
				linux16 "$file_name";
			else
				linux "$file_name";
			fi;
		}
	fi;
	menuentry $"Open As Text"  --class txt{
		main_ops="text"; export main_ops;
		configfile $prefix/main.sh;
	}
	menuentry $"File Info"  --class info{
		set pager=1;
		echo "Path"; echo "$file_name";
		echo "CRC32"; crc32 "$file_name";
		echo "hexdump"; hexdump "$file_name";
		echo -n $"Press [ESC] to continue...";
		sleep --interruptible 999;
	}
	hiddenmenu;
}

set grub4dos=$prefix/grub.exe; export grub4dos;
set theme=${prefix}/themes/slack/theme.txt; export theme;
if test -z "$main_ops"; then
	main;
elif regexp 'open' "$main_ops"; then
	unset main_ops;
	open;
elif regexp 'llua' "$main_ops"; then
	main_ops="open"; export main_ops;
	lua "$file_name";
	echo -n $"Press [ESC] to continue...";
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
		main_ops="open"; export main_ops; configfile $prefix/main.sh;
	}
	lua $prefix/cat_file.lua;
fi;
