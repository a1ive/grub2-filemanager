
# build_pe WIM_FILE
function bootpe {
  if wimtools --is64 --index=2 "${1}";
  then
    set sfx="(install)/sfx64.exe";
  else
    set sfx="(install)/sfx32.exe";
  fi;
  set lang=en_US;
  terminal_output console;
  loopback wimboot ${prefix}/wimboot.xz;
  loopback install ${prefix}/explorer.xz;
  wimboot  --testmode=no \
            @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
            @:sfx64.exe:${sfx} \
            @:winpeshl.ini:(install)/winpeshl.ini \
            @:boot.wim:"${1}";
}

export distro="Windows PE";

menuentry $"Boot ${distro} From ISO" --class nt6 {
  loopback -d loop;
  loopback loop "${grubfm_file}";
  set wim="(loop)/sources/boot.wim";
  set wim32="(loop)/x86/sources/boot.wim";
  set wim64="(loop)/x64/sources/boot.wim";
  if [ -f "${wim32}" -a "${grub_cpu}" = "i386" ];
  then
    bootpe "${wim32}";
  elif [ -f "${wim64}" -a "${grub_cpu}" = "x86_64" ];
  then
    bootpe "${wim64}";
  else
    bootpe "${wim}";
  fi;
}
