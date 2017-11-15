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

# memdisk iso|floppy|harddisk $file
function memdisk{
	set memdisk=$prefix/memdisk;
	linux16 $memdisk $1 raw;
	echo "Loading $file_name [type=$1]";
	enable_progress_indicator=1;
	initrd16 "$2";
	boot;
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
			if regexp '^\([hcf]d[0-9]*.*$' "$file_name"; then
				menuentry $"Open As GRUB4DOS Menu"  --class cfg{
					set g4d_param="config";
					lua $prefix/g4d_path.lua;
					linux $grub4dos --config-file=$g4dcmd;
				}
			fi;
		fi;
		menuentry $"Open As GRUB-Legacy Menu"  --class cfg{
			regexp --set=root '^\(([0-9a-zA-Z,]+)\).*$' "$file_name";
			legacy_configfile "$file_name";
		}
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
			menuentry $"Boot Floppy Image (GRUB4DOS)" --class img{
				set g4d_param="fd";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
				if [ "$rd" == "1" ]; then
					enable_progress_indicator=1;
					initrd "$file_name";
				fi;
			}
			menuentry $"Boot Floppy Image (memdisk)" --class img{
				memdisk floppy "$file_name";
			}
			menuentry $"Boot Hard Drive Image (GRUB4DOS)" --class img{
				set g4d_param="hd";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
				if [ "$rd" == "1" ]; then
					enable_progress_indicator=1;
					initrd "$file_name";
				fi;
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
			if search -f /wimboot; then
				menuentry $"Boot NT6.x WIM (wimboot)" --class wim{
					terminal_output console;
					enable_progress_indicator=1;
					loopback wimboot /wimboot;
					linux16 (wimboot)/wimboot gui;
					echo "loading wim ..."
					initrd16 newc:bootmgr:(wimboot)/bootmgr newc:bcd:(wimboot)/bcd newc:boot.sdi:(wimboot)/boot.sdi newc:boot.wim:$file_name;
				}
			fi;
			if regexp '^\([hc]d[0-9]*.*$' "$file_name"; then
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
		fi;
	elif regexp 'wpe' $file_type; then
		if regexp 'pc' $grub_platform; then
			if regexp '^\([hc]d[0-9]*.*$' "$file_name"; then
				if search -f /NTBOOT.MOD/NTBOOT.PE1; then
					menuentry $"Boot NT5.x PE (NTBOOT)" --class windows{
						set g4d_param="peboot";
						lua $prefix/g4d_path.lua;
						linux $grub4dos --config-file=$g4dcmd;
					}
				fi;
			fi;
		fi;
	elif regexp 'vhd' $file_type; then
		if regexp 'pc' $grub_platform; then
			if regexp '^\(hd[0-9]*.*$' "$file_name"; then
				if search -f /NTBOOT.MOD/NTBOOT.NT6; then
					menuentry $"Boot Windows NT6.x VHD/VHDX (NTBOOT)" --class img{
						set g4d_param="ntboot";
						lua $prefix/g4d_path.lua;
						linux $grub4dos --config-file=$g4dcmd;
					}
				fi;
			fi;
		fi;
	elif regexp 'iso' $file_type; then
		unset efi_file;
		if ! regexp '^\(loop.*$' "$file_name"; then
			loopback loop "$file_name";
			menuentry $"Mount ISO"  --class iso{
				path="(loop)"; export path; configfile $prefix/main.sh;
			}
			source $prefix/isoboot.sh;
			CheckLinuxType;
			if regexp 'i386' "$grub_cpu"; then
					set efi_file="bootia32.efi";
			else
					set efi_file="bootx64.efi";
			fi;
		fi;
		if regexp 'pc' $grub_platform; then
			menuentry $"Boot ISO (GRUB4DOS)" --class iso{
				set g4d_param="cd";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
				if [ "$rd" == "1" ]; then
					enable_progress_indicator=1;
					initrd "$file_name";
				fi;
			}
			if regexp '^\(hd[0-9]*.*$' "$file_name"; then
				menuentry $"Boot ISO (Easy2Boot)" --class iso{
					source $prefix/easy2boot.sh;
				}
			fi;
			menuentry $"Boot ISO (memdisk)" --class iso{
				memdisk iso "$file_name";
			}
		else
			if test -f "(loop)/efi/boot/${efi_file}"; then
				menuentry $"Boot EFI Files" --class uefi{
					chainloader (loop)/efi/boot/${efi_file};
				}
			fi;
		fi;
	elif regexp 'ipxe' $file_type; then
		if regexp 'pc' $grub_platform; then
			menuentry $"Open As iPXE Script" --class net{
				linux16 $prefix/ipxe.lkrn;
				initrd16 "$file_name";
			}
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
		if regexp '^\([hcf]d[0-9]*.*$' "$file_name"; then
			menuentry $"Open As GRUB4DOS MOD"  --class bin{
				set g4d_param="command";
				lua $prefix/g4d_path.lua;
				linux $grub4dos --config-file=$g4dcmd;
			}
		fi;
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
		echo "File Path : $file_name";
		lua $prefix/file_info.lua;
		echo "File Size : $file_size";
		enable_progress_indicator=1;
		echo "CRC32 : "; crc32 "$file_name";
		enable_progress_indicator=0;
		echo "hexdump"; hexdump "$file_name";
		echo -n $"Press [ESC] to continue...";
		getkey;
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
