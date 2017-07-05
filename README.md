[简体中文](https://github.com/a1ive/grub2-filemanager/blob/master/lang/zh_CN/README.md) 
# grub2-filemanager 
## Preview 
[![preview.png](https://s29.postimg.org/udhuu37nr/preview.png)](https://postimg.org/image/tnz2hq743/)
## Download 
https://github.com/a1ive/grub2-filemanager/releases 
## Build
	git clone https://github.com/a1ive/grub2-filemanager.git
	cd grub2-filemanager
	./build.sh
## Boot 
### i386-pc 
#### GRUB4DOS 
	map --mem /grubfm.iso (0xff)
	map --hook
	chainloader (0xff)
#### GRUB Legacy 
	kernel /memdisk
	initrd /grubfm.iso
#### GRUB 2/BURG 
	linux16 /memdisk iso raw
	initrd16 /grubfm.iso
#### Syslinux 
	LINUX memdisk
	INITRD grubfm.iso
	APPEND iso raw
### x86_64-efi, i386-efi 
#### GRUB 2 
	chainloader /grubfm.efi
#### rEFInd 
	loader /grubfm.efi
#### Systemd-boot 
	efi /grubfm.efi
## Supported distributions 
*    4MLinux
*    Acronis True Image
*    Android-x86(6.0+)
*    antiX
*    Apricity OS
*    Antergos
*    Arch Linux(FAT32 only)
*    ArchBang
*    Archboot
*    Backbox
*    BlackArch
*    Bodhi
*    CDlinux
*    CentOS(FAT32 only)
*    Clonezilla
*    DBAN(Legacy-BIOS only)
*    Debian Live
*    Deepin
*    Devuan Live
*    elementaryOS
*    Fedora(FAT32 only)
*    FreeBSD(bootonly ISO, Legacy-BIOS only)
*    FreeDOS(Legacy-BIOS only)
*    FreeNAS
*    Gentoo
*    GParted Live
*    grml
*    Knoppix
*    Kali Linux
*    KaOS
*    KDE-neon
*    KolibriOS(Legacy-BIOS only)
*    Linux Lite
*    LinuxMint
*    Lubuntu
*    Manjaro
*    Memtest86
*    MiniTool Partition Wizard
*    OpenBSD(Legacy-BIOS only)
*    OpenSUSE
*    Parted Magic
*    PCLinuxOS
*    Peppermint
*    PhoenixOS
*    PIXEL
*    Porteus
*    RemixOS(3.0+)
*    Slackware
*    Slax
*    Slitaz(Legacy-BIOS only)
*    Super Grub2 Disk
*    System Rescue CD
*    Ubuntu
*    Void Linux
*    Wifislax/Wifislax64
*    Windows PE(Legacy-BIOS only)
*    Xubuntu
*    ZorinOS
