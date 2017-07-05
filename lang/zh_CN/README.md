# grub2-filemanager
## 关于 
Grub2文件管理器 -- 对GNU/Linux更友好的"RUN模块" 
## 功能 
1. 启动 efi,iso,img,Linux kernel,Multiboot kernel 文件
2. 挂载 iso,img,tar,gz,xz 查看内容 
3. 查看文本文件内容, 支持 GBK/UTF-8 编码 
4. 浏览 jpg,png,tga 图片 
5. 加载 GRUB 2,Syslinux 菜单 
6. 执行 Lua 脚本 
## 下载 
https://github.com/a1ive/grub2-filemanager/releases 
## 构建
	git clone https://github.com/a1ive/grub2-filemanager.git
	cd grub2-filemanager
	./build.sh
## 启动 
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
## 支持列表 
*    4MLinux
*    Acronis True Image
*    Android-x86(6.0及以上版本)
*    antiX
*    Apricity OS
*    Antergos
*    Arch Linux(仅FAT32)
*    ArchBang
*    Archboot
*    Backbox
*    BlackArch
*    Bodhi
*    CDlinux
*    CentOS(仅FAT32)
*    Clonezilla
*    DBAN(系统仅支持Legacy-BIOS)
*    Debian Live
*    Deepin
*    Devuan Live(请手动输入用户名devuan)
*    elementaryOS
*    Fedora(仅FAT32)
*    FreeBSD(bootonly ISO, 系统仅支持Legacy-BIOS)
*    FreeDOS(系统仅支持Legacy-BIOS)
*    FreeNAS
*    Gentoo
*    GParted Live
*    grml
*    Knoppix
*    Kali Linux
*    KaOS
*    KDE-neon
*    KolibriOS(系统仅支持Legacy-BIOS)
*    Linux Lite
*    LinuxMint
*    Lubuntu
*    Manjaro
*    Memtest86
*    MiniTool Partition Wizard
*    OpenBSD(系统仅支持Legacy-BIOS)
*    OpenSUSE
*    Parted Magic
*    PCLinuxOS
*    Peppermint
*    PhoenixOS
*    PIXEL
*    Porteus
*    RemixOS(3.0及以上版本)
*    Slackware
*    Slax
*    Slitaz(系统仅支持Legacy-BIOS)
*    Super Grub2 Disk
*    System Rescue CD
*    Ubuntu
*    Void Linux
*    Wifislax/Wifislax64
*    Windows PE(仅Legacy-BIOS)
*    Xubuntu
*    ZorinOS
## 源码 
GRUB2-MOD: https://github.com/a1ive/grub2-mod 
## 类似项目 
*	[Multiboot USB](http://mbusb.aguslr.com/) 
*	[grub-iso-boot](https://github.com/Jimmy-Z/grub-iso-boot) 
*	[grub-iso-multiboot](https://github.com/mpolitzer/grub-iso-multiboot) 
*	[GLIM](https://github.com/thias/glim) 
*	[Easy2Boot](http://www.easy2boot.com/) 
*	[GRUB2 File Explorer](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=320715) 
*	[RUN](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=191301) 
*	[G4D AUTOMENU](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=203607) 