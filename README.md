[简体中文](https://a1ive.github.io/grub2-filemanager/) 

# grub2-filemanager 
[![Build Status](https://travis-ci.com/a1ive/grub2-filemanager.svg?branch=master)](https://travis-ci.com/a1ive/grub2-filemanager) ![](https://img.shields.io/github/license/a1ive/grub2-filemanager.svg?style=flat) ![](https://img.shields.io/github/downloads/a1ive/grub2-filemanager/total.svg?style=flat) ![](https://img.shields.io/github/release/a1ive/grub2-filemanager.svg?style=flat) 
## Preview 
![preview.png](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/preview.png)
## Download 
https://github.com/a1ive/grub2-filemanager/releases 
## Build
	git clone https://github.com/a1ive/grub2-filemanager.git
	cd grub2-filemanager
	./build.sh
## Boot 
### i386-pc 
DO NOT boot grubfm.iso with memdisk!  
#### GRUB4DOS 
	map --mem /grubfm.iso (0xff)
	map --hook
	chainloader (0xff)
#### GRUB 2
	linux /loadfm  
	initrd /grubfm.iso  
### x86_64-efi 
#### [Secure Boot](https://github.com/a1ive/grub2-filemanager/blob/master/secureboot/sb.md) 

#### GRUB 2 

	chainloader /grubfmx64.efi
#### rEFInd 
	loader /grubfmx64.efi
#### Systemd-boot 
	efi /grubfmx64.efi
## Supported distros 

*    4MLinux
*    Acronis True Image
*    Android-x86 (6.0+)
*    antiX
*    Apricity OS
*    Antergos
*    Arch Linux (FAT32 only)
*    ArchBang
*    Archboot
*    Backbox
*    BlackArch
*    Bodhi
*    Calculate Linux
*    CDlinux
*    CentOS (FAT32 only)
*    Clonezilla
*    Condres OS
*    CyanogenMod (LineageOS)
*    DBAN (Legacy-BIOS only)
*    Debian Live
*    Debian/kFreeBSD
*    Deepin (< 15.6)
*    Devuan Live
*    elementaryOS
*    Elive
*    ExTiX
*    Fedora (FAT32 only)
*    FreeBSD (Legacy-BIOS only)
*    FreeDOS (Legacy-BIOS only)
*    FreeNAS
*    Gentoo
*    GParted Live
*    grml
*    HelenOS (Legacy-BIOS only)
*    IPFire
*    Knoppix
*    Kali Linux
*    KaOS
*    KDE-neon
*    KolibriOS (Legacy-BIOS only)
*    Linux Lite
*    LinuxMint
*    Lubuntu
*    Manjaro
*    Memtest86
*    MiniTool Partition Wizard
*    MX Linux
*    NetBSD (Legacy-BIOS only)
*    OpenBSD (Legacy-BIOS only)
*    OpenSUSE
*    OpenSUSE Tumbleweed
*    OpenMandriva
*    Parted Magic
*    PCLinuxOS
*    Peppermint
*    pfSense
*    PhoenixOS
*    PIXEL
*    Plop Linux Live
*    Porteus
*    Q4OS
*    Redcore Linux
*    RemixOS (3.0+)
*    siduction
*    Slackware
*    Slax
*    Slitaz (Legacy-BIOS only)
*    SmartOS (Legacy-BIOS only)
*    Solus
*    Super Grub2 Disk
*    System Rescue CD
*    Tails
*    Ubuntu
*    Void Linux
*    Wifislax/Wifislax64
*    Wifiway
*    Windows PE (Legacy-BIOS only)
*    Xubuntu
*    ZorinOS
## Source code 
GRUB2: https://github.com/a1ive/grub 

PreLoader: https://github.com/a1ive/PreLoader 

## Similar projects 
*	[Multiboot USB](http://mbusb.aguslr.com/) 
*	[grub-iso-boot](https://github.com/Jimmy-Z/grub-iso-boot) 
*	[grub-iso-multiboot](https://github.com/mpolitzer/grub-iso-multiboot) 
*	[GLIM](https://github.com/thias/glim) 
*	[Easy2Boot](http://www.easy2boot.com/) 
*	[GRUB2 File Explorer](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=320715) 
*	[RUN](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=191301) 
*	[G4D AUTOMENU](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=203607) 
