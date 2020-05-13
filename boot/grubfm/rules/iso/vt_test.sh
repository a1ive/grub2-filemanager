source ${prefix}/func.sh;

function load_vt
{
  if search --set=vt_root --file /ventoy/ventoy.cpio;
  then
    set vtoy_path=($vt_root)/ventoy;
  else
    loopback -d ventoy;
    loopback ventoy "${prefix}/ventoy.gz";
    set vtoy_path="(ventoy)/ventoy";
  fi;
  set grubfm_test=1;
}

function check_vt
{
  if [ "$grub_platform" = "efi" -a "$grub_cpu" = "i386" ];
  then
    return;
  fi;
  probe --set=fs -f "${grubfm_device}";
  if [ "${fs}" != "fat" -a "${fs}" != "exfat" -a "${fs}" != "ntfs" ];
  then
    return;
  fi;
  load_vt;
}

check_vt;
