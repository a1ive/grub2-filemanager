# Grub2-FileManager
# Copyright (C) 2016,2017,2018,2019,2020  A1ive.
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

source ${prefix}/func.sh;

function iso_detect {
  unset icon;
  unset distro;
  unset src;
  unset linux_extra;
  probe --set=rootuuid -u "(${grubfm_device})";
  probe --set=looplabel -q --label (loop);
  probe --set=loopuuid -u (loop);
  if [ -f (loop)/casper/vmlinuz* ];
  then
    export linux_extra="iso-scan/filename=${grubfm_path}";
    export icon=ubuntu;
    export distro="Ubuntu";
    export src=ubuntu;
  elif [ -d (loop)/arch ];
  then
    if [ -f (loop)/boot/vmlinuz_* ];
    then
      export linux_extra="iso_loop_dev=/dev/disk/by-uuid/${rootuuid} iso_loop_path=${grubfm_path}";
    else
      export linux_extra="img_dev=/dev/disk/by-uuid/${rootuuid} img_loop=${grubfm_path} archisolabel=${looplabel}";
    fi;
    export icon=archlinux;
    export distro="Arch Linux";
    export src=archlinux;
  elif [ -d (loop)/parabola ];
  then
    export linux_extra="img_dev=/dev/disk/by-uuid/${rootuuid} img_loop=${grubfm_path} parabolaisolabel=${looplabel}";
    export icon=archlinux;
    export distro="Parabola";
    export src=parabola;
  elif [ -d (loop)/blackarch ];
  then
    export linux_extra="img_dev=/dev/disk/by-uuid/${rootuuid} img_loop=${grubfm_path} archisolabel=${looplabel}";
    export icon=archlinux;
    export distro="BlackArch";
    export src=blackarch;
  elif [ -d (loop)/hyperbola ];
  then
    export linux_extra="img_dev=/dev/disk/by-uuid/${rootuuid} img_loop=${grubfm_path} hyperisolabel=${looplabel}";
    export icon=archlinux;
    export distro="Hyperbola";
    export src=hyper;
  elif [ -d (loop)/kdeos ];
  then
    export linux_extra="img_dev=/dev/disk/by-uuid/${rootuuid} img_loop=${grubfm_path} kdeisolabel=${looplabel}";
    export icon=kaos;
    export distro="KaOS";
    export src=kaos;
  elif [ -d (loop)/manjaro ];
  then
    export linux_extra="img_dev=/dev/disk/by-uuid/${rootuuid} img_loop=${grubfm_path} misolabel=${looplabel}";
    export icon=manjaro;
    export distro="Manjaro";
    export src=manjaro;
  elif [ -d (loop)/chakra ];
  then
    export linux_extra="img_dev=/dev/disk/by-uuid/${rootuuid} img_loop=${grubfm_path} chakraisolabel=${looplabel}";
    export icon=chakra;
    export distro="Chakra";
    export src=chakra;
  elif [ -d (loop)/siduction ];
  then
    export linux_extra="fromiso=${grubfm_path}";
    export icon=siduction;
    export distro="siduction";
    export src=siduction;
  elif [ -f (loop)/sysrcd.dat ];
  then
    export linux_extra="isoloop=${grubfm_path}";
    export icon=gentoo;
    export distro="System Rescue CD";
    export src=sysrcd;
  elif [ -d (loop)/sysresccd ];
  then
    export linux_extra="img_dev=/dev/disk/by-uuid/${rootuuid} img_loop=${grubfm_path} archisolabel=${looplabel}";
    export icon=archlinux;
    export distro="System Rescue CD";
    export src=sysresccd;
  elif [ -f (loop)/ipfire*.media ];
  then
    export linux_extra="bootfromiso=${grubfm_path}";
    export icon=ipfire;
    export distro="IPFire";
    export src=ipfire;
  elif [ -f (loop)/isolinux/vmlinuz -a -f (loop)/isolinux/initrd.gz -a -f (loop)/livecd.sqfs ];
  then
    export linux_extra="root=UUID=${rootuuid} isoboot=${grubfm_path}";
    export icon=pclinuxos;
    export distro="PCLinuxOS";
    export src=pclinuxos;
  elif [ -f (loop)/livecd.squashfs ];
  then
    export linux_extra="isoboot=${grubfm_path} root=live:LABEL=${looplabel} iso-scan/filename=${grubfm_path}";
    export icon=gnu-linux;
    export distro="Calculate Linux";
    export src=calculate;
  elif [ -f (loop)/kernel -a -f (loop)/initrd.img -a -f (loop)/system.sfs ];
  then
    export linux_extra="iso-scan/filename=${grubfm_path}";
    export icon=android;
    export distro="Android-x86";
    export src=android;
  elif [ -d (loop)/porteus ];
  then
    export linux_extra="from=${grubfm_path}";
    export icon=porteus;
    export distro="Porteus";
    export src=porteus;
  elif [ -d (loop)/slax ];
  then
    export linux_extra="from=${grubfm_path}";
    export icon=slax;
    export distro="Slax";
    export src=slax;
  elif [ -d (loop)/wifislax ];
  then
    export linux_extra="from=${grubfm_path}";
    export icon=wifislax;
    export distro="Wifislax";
    export src=wifislax;
  elif [ -d (loop)/wifislax64 ];
  then
    export linux_extra="livemedia=/dev/disk/by-uuid/${rootuuid}:${grubfm_path}";
    export icon=wifislax;
    export distro="Wifislax64";
    export src=wifislax;
  elif [ -d (loop)/wifiway ];
  then
    export linux_extra="from=${grubfm_path}";
    export icon=wifislax;
    export distro="Wifiway";
    export src=wifislax;
  elif [ -d (loop)/pmagic ];
  then
    export linux_extra="iso_filename=${grubfm_path}";
    export icon=pmagic;
    export distro="Parted Magic";
    export src=pmagic;
  elif [ -d (loop)/ploplinux ];
  then
    export linux_extra="iso_filename=${grubfm_path}";
    export icon=gnu-linux;
    export distro="Plop Linux";
    export src=plop;
  elif [ -d (loop)/liveslak ];
  then
    export linux_extra="livemedia=scandev:${grubfm_path}";
    export icon=slackware;
    export distro="Slackware Live";
    export src=liveslack;
  elif [ -d (loop)/antix ];
  then
    export linux_extra="fromiso=${grubfm_path} from=hd,usb";
    export icon=debian;
    export distro="antiX";
    export src=antix;
  elif [ -d (loop)/live ];
  then
    export linux_extra="findiso=${grubfm_path}";
    export icon=debian;
    export distro="Debian";
    export src=debian;
  elif [ -f (loop)/isolinux/gentoo* ];
  then
    export linux_extra="isoboot=${grubfm_path}";
    export icon=gentoo;
    export distro="Gentoo";
    export src=gentoo;
  elif [ -f (loop)/isolinux/pentoo ];
  then
    export linux_extra="isoboot=${grubfm_path}";
    export icon=gentoo;
    export distro="Pentoo";
    export src=pentoo;
  elif [ -f (loop)/boot/sabayon ];
  then
    export linux_extra="isoboot=${grubfm_path}";
    export icon=sabayon;
    export distro="Sabayon";
    export src=sabayon;
  elif [ -f (loop)/boot/core.gz -o -f (loop)/boot/corepure64.gz ];
  then
    export linux_extra="iso=UUID=${rootuuid}${grubfm_path}";
    export icon=gnu-linux;
    export distro="TinyCore";
    export src=tinycore;
  elif [ -d (loop)/LiveOS ];
  then
    export linux_extra="root=live:CDLABEL=${looplabel} iso-scan/filename=${grubfm_path}";
    export icon=fedora;
    export distro="Fedora";
    export src=fedora;
  elif [ -f (loop)/images/pxeboot/vmlinuz ];
  then
    export linux_extra="inst.stage2=hd:UUID=${loopuuid} iso-scan/filename=${grubfm_path}";
    export icon=fedora;
    export distro="Fedora";
    export src=fedora;
  elif [ -f (loop)/boot/x86_64/loader/linux -o -f (loop)/boot/i*86/loader/linux ];
  then
    export linux_extra="isofrom_system=${grubfm_path} isofrom_device=/dev/disk/by-uuid/${rootuuid}";
    export icon=opensuse;
    export distro="OpenSUSE";
    export src=suse64;
  elif [ -f (loop)/boot/isolinux/minirt.gz ];
  then
    export linux_extra="bootfrom=/dev/disk/by-uuid/${rootuuid}${grubfm_path}";
    export icon=knoppix;
    export distro="Knoppix";
    export src=knoppix;
  elif [ -f (loop)/boot/kernel/kernel* -o -f (loop)/boot/kernel/kfreebsd.gz ];
  then
    export linux_extra="${grubfm_file}";
    export icon=freebsd;
    export distro="FreeBSD";
    export src=freebsd;
  fi;
}

iso_detect;
if [ -n "${src}" ];
then
  menuentry $"Boot ${distro} from ISO" --class ${icon} {
    configfile ${prefix}/distro/${src}.sh;
  }
fi;
