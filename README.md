[简体中文](https://a1ive.github.io/grub2-filemanager/) 

# grub2-filemanager 
![](https://img.shields.io/github/license/a1ive/grub2-filemanager.svg?style=flat) ![](https://img.shields.io/github/downloads/a1ive/grub2-filemanager/total.svg?style=flat) ![](https://img.shields.io/github/release/a1ive/grub2-filemanager.svg?style=flat) [![Crowdin](https://badges.crowdin.net/grub2-filemanager/localized.svg)](https://crowdin.com/project/grub2-filemanager)

## Preview

![preview.png](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/preview.png)

| Type                                                         | i386-pc | i386-efi | x86_64-efi |
| :----------------------------------------------------------- | :-----: | :------: | :--------: |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/iso.png)WinPE ISO |    ✔️    |    ✔️     |     ✔️      |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/linux.png)Linux ISO |    ✔️    |    ✔️     |     ✔️      |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/android.png)Android ISO |    ✔️    |    ✔️     |     ✔️      |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/bsd.png)BSD ISO |    ✔️    |    ❌     |     ❌      |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/img.png)IMG (Disk Image) |    ✔️    |    ✔️     |     ✔️      |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/vhd.png)VHD |    ✔️    |    ✔️     |     ✔️      |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/nt6.png)WinPE WIM |    ✔️    |    ✔️     |     ✔️      |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/nt5.png)NT5 WinPE |    ✔️    |    ❌     |     ❌      |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/kernel.png)Linux/Multiboot Kernel |    ✔️    |    ✔️     |     ✔️      |
| ![img](https://github.com/a1ive/grub2-filemanager/raw/gh-pages/images/efi.png)EFI Application |    ❌    |    ✔️     |     ✔️      |

## Download

https://github.com/a1ive/grub2-filemanager/releases 
## Build
	git clone https://github.com/a1ive/grub2-filemanager.git
	cd grub2-filemanager
	./update_grub2.sh
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

#### GRUB 2 

	chainloader /grubfmx64.efi
#### rEFInd 
	loader /grubfmx64.efi
#### Systemd-boot 
	efi /grubfmx64.efi
## Source code 
GRUB2: https://github.com/a1ive/grub 

## Help to translate 

[Crowdin](https://crowdin.com/project/grub2-filemanager) 

## Similar projects 
*	[Multiboot USB](http://mbusb.aguslr.com/) 
*	[grub-iso-boot](https://github.com/Jimmy-Z/grub-iso-boot) 
*	[grub-iso-multiboot](https://github.com/mpolitzer/grub-iso-multiboot) 
*	[GLIM](https://github.com/thias/glim) 
*	[Easy2Boot](http://www.easy2boot.com/) 
*	[GRUB2 File Explorer](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=320715) 
*	[RUN](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=191301) 
*	[G4D AUTOMENU](http://bbs.wuyou.net/forum.php?mod=viewthread&tid=203607) 
