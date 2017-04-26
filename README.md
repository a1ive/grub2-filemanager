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
## 源码 
许可协议: GNU GPL v3.0 
修改版GRUB: https://github.com/a1ive/grub2-mod
