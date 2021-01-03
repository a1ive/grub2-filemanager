# Grub2-FileManager
# Copyright (C) 2020  A1ive.
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

function calc_volt {
  # bit 7 = 1 (0x80h)
  # the remaining seven bits of the field are set to
  # contain the processor’s current voltage times 10.
  # bit 7 = 0 Legacy mode
  # bit 0 - 5V
  # bit 1 - 3.3V
  # bit 2 - 2.9V
  set tmp="${1}";
  if [ "${tmp}" -ge "0x80" ];
  then
    expr --set=tmp "${tmp} - 0x80";
    expr --set=tmp_div "${tmp} / 10";
    expr --set=tmp_mod "${tmp} % 10";
    set cpu_volt="${tmp_div}.${tmp_mod}V";
  else
    set cpu_volt="";
    expr --set=tmp0 "${tmp} & 0x01";
    expr --set=tmp1 "${tmp} & 0x02";
    expr --set=tmp2 "${tmp} & 0x04";
    if [ "${tmp0}" -gt "0" ];
    then
      set cpu_volt="${cpu_volt}5V "
    fi;
    if [ "${tmp1}" -gt "0" ];
    then
      set cpu_volt="${cpu_volt}3.3V "
    fi;
    if [ "${tmp2}" -gt "0" ];
    then
      set cpu_volt="${cpu_volt}2.9V "
    fi;
  fi;
}

function check_cpu {
  set cpu_brand=$"Unknown ${grub_cpu} CPU";
  set cpu_vendor=$"unknown";
  set cpu_long=$"unknown";
  set cpu_pae=$"unknown";
  set cpu_vme=$"unknown";
  set cpu_pse=$"unknown";
  set cpu_tsc=$"unknown";
  set cpu_msr=$"unknown";
  set cpu_mtrr=$"unknown";
  set cpu_ins=$"unknown";
  set cpu_temp=$"unknown";
  set cpu_hyperv=$"unknown";
  set cpu_vmsign="-";
  set cpu_socket="-";
  set cpu_type="-";
  set cpu_cur_speed="-";
  set cpu_max_speed="-";
  set cpu_clock="-";
  set cpu_volt="-";
  set cpu_volt_raw="0";
  smbios -t 4 -s 0x10 --set=cpu_brand;
  smbios -t 4 -s 0x07 --set=cpu_vendor;
  smbios -t 4 -s 0x04 --set=cpu_socket;
  smbios -t 4 -w 0x16 --set=cpu_cur_speed;
  smbios -t 4 -w 0x14 --set=cpu_max_speed;
  smbios -t 4 -w 0x12 --set=cpu_clock;
  smbios -t 4 -b 0x11 --set=cpu_volt_raw;
  calc_volt "${cpu_volt_raw}";
  if type cpuid;
  then
    cpuid -l --set=cpu_long;
    cpuid -p --set=cpu_pae;
    if cpuid --hypervisor --set=cpu_hyperv;
    then
      cpuid --vmsign --set=cpu_vmsign;
    fi;
    cpuid --brand --set=cpu_brand;
    cpuid --vendor --set=cpu_vendor;
    cpuid --vme --set=cpu_vme;
    cpuid --pse --set=cpu_pse;
    cpuid --tsc --set=cpu_tsc;
    cpuid --msr --set=cpu_msr;
    cpuid --mtrr --set=cpu_mtrr;
    if [ cpuid --mmx ];
    then
      set cpu_ins="MMX ";
    fi;
    if [ cpuid --sse ];
    then
      set cpu_ins="${cpu_ins}SSE ";
    fi;
    if [ cpuid --sse2 ];
    then
      set cpu_ins="${cpu_ins}SSE2 ";
    fi;
    if [ cpuid --sse3 ];
    then
      set cpu_ins="${cpu_ins}SSE3 ";
    fi;
    if [ cpuid --vmx ];
    then
      set cpu_ins="${cpu_ins}VT-x";
    fi;
  fi;
}

function check_ram_no {
  set no="${1}";
  eval "set ram${no}_size=0";
#  eval "set ram${no}_serial=-";
  eval "set ram${no}_speed=-";
  eval "set ram${no}_vendor=-";
  eval "set ram${no}_volt=-";
  set tmp=0;
  set ver=0;
  smbios -t 17 -w 0x0c -m "${no}" --set=tmp;
  if [ "${tmp}" = "0" ];
  then
    return;
  elif [ "${tmp}" -eq "0xffff" ];
  then
    return;
  elif [ "${tmp}" -eq "0x7fff" ];
  then
    return;
  elif [ "${tmp}" -ge "0x8000" ];
  then
    expr --set=tmp "${tmp} - 0x8000";
    eval "set ram${no}_size=${tmp}KB";
  else
    eval "set ram${no}_size=${tmp}MB";
  fi;
  smbios -t 17 -b 0x01 -m "${no}" --set=ver;
  if [ "${ver}" -lt "0x1b" ]; # v2.3
  then
    return;
  fi;
  smbios -t 17 -w 0x15 -m "${no}" --set=tmp;
  eval "set ram${no}_speed=${tmp}MHz";
  smbios -t 17 -s 0x17 -m "${no}" --set=tmp;
  eval "set ram${no}_vendor=${tmp}";
#  smbios -t 17 -s 0x18 -m "${no}" --set=tmp;
#  eval "set ram${no}_serial=${tmp}";
  if [ "${ver}" -lt "0x28" ]; # v2.8
  then
    return;
  fi;
  smbios -t 17 -w 0x26 -m "${no}" --set=tmp;
  eval "set ram${no}_volt=${tmp}mV";
}

function check_ram {
  check_ram_no 1;
  check_ram_no 2;
  check_ram_no 3;
  check_ram_no 4;
}

function check_acpi {
  set acpi_ver="-";
  set acpi_oemid="-";
  stat -q -z -s tmp (proc)/acpi_rsdp;
  if [ "${tmp}" = "0" ];
  then
    return;
  fi;
  hexdump -q -s 9 -n 6 (proc)/acpi_rsdp tmp;
  set acpi_oemid="${tmp}";
  hexdump -q -s 15 -n 1 (proc)/acpi_rsdp tmp;
  regexp -s tmp '\\x(.*)' ${tmp};
  expr -s acpi_ver "v${tmp}";
}

function check_smbios {
  set smbios_ver="-";
  set smbios3_file="(proc)/smbios3";
  set smbios_file="(proc)/smbios";
  stat -q -z -s tmp3 (proc)/smbios3;
  stat -q -z -s tmp (proc)/smbios;
  if [ "${tmp3}" -gt "0" ];
  then
    hexdump -q -s 7 -n 1 (proc)/smbios3 ver_major;
    hexdump -q -s 8 -n 1 (proc)/smbios3 ver_minor;
  elif [ "${tmp}" -gt "0" ];
  then
    hexdump -q -s 6 -n 1 (proc)/smbios ver_major;
    hexdump -q -s 7 -n 1 (proc)/smbios ver_minor;
  fi;
  regexp -s ver_major '\\x(.*)' ${ver_major};
  regexp -s ver_minor '\\x(.*)' ${ver_minor};
  expr -s ver_major "${ver_major}";
  expr -s ver_minor "${ver_minor}";
  set smbios_ver="${ver_major}.${ver_minor}";
}

function check_board {
  set system_vendor="-";
  smbios -t 1 -s 0x04 --set=system_vendor;
  set system_product="-";
  smbios -t 1 -s 0x05 --set=system_product;
  set system_version="-";
  smbios -t 1 -s 0x06 --set=system_version;

  set board_vendor="-";
  smbios -t 2 -s 0x04 --set=board_vendor;
  set board_product="-";
  smbios -t 2 -s 0x05 --set=board_product;
  set board_version="-";
  smbios -t 2 -s 0x06 --set=board_version;

  set bios_vendor="-";
  smbios -t 0 -s 0x04 --set=bios_vendor;
  set bios_version="-";
  smbios -t 0 -s 0x05 --set=bios_ver;
  set bios_date="-";
  smbios -t 0 -s 0x08 --set=bios_date;
  set bios_size="-";
  smbios -t 0 -b 0x09 --set=bios_size;

  check_acpi;
  check_smbios;
}

function hwinfo_set_theme {
  if [ -f "${1}" ];
  then
    export theme=${1};
  else
    unset theme;
  fi;
}

videomode -c mode_current;

if [ "${mode_current}" != "0x0" -a -n "${theme}" ];
then
  if [ "${hwinfo_op}" = "cpu" ];
  then
    check_cpu;
    hwinfo_set_theme "${theme_hw_cpu}";
  elif [ "${hwinfo_op}" = "ram" ];
  then
    check_ram;
    hwinfo_set_theme "${theme_hw_ram}";
  elif [ "${hwinfo_op}" = "board" ];
  then
    check_board;
    hwinfo_set_theme "${theme_hw_board}";
  else
    hwinfo_set_theme "${theme_hw_grub}";
  fi;
  unset hwinfo_op;

  menuentry $"GRUB (G)" --class grub --hotkey=g {
    configfile ${prefix}/hwinfo.sh;
  }

  menuentry $"CPU (U)" --class cpu --hotkey=u {
    export hwinfo_op=cpu;
    configfile ${prefix}/hwinfo.sh;
  }

  menuentry $"RAM (R)" --class ram --hotkey=r {
    export hwinfo_op=ram;
    configfile ${prefix}/hwinfo.sh;
  }

  menuentry $"MAINBOARD (B)" --class board --hotkey=b {
    export hwinfo_op=board;
    configfile ${prefix}/hwinfo.sh;
  }

  hiddenentry " " --hotkey f2 {
    if [ -n "${grubfm_current_path}" ];
    then
      grubfm "${grubfm_current_path}";
    else
      grubfm;
    fi;
  }

  hiddenentry " " --hotkey f3 {
    configfile ${prefix}/osdetect.sh;
  }

  hiddenentry " " --hotkey f4 {
    configfile ${prefix}/settings.sh;
  }

  hiddenentry " " --hotkey f5 {
    configfile ${prefix}/util.sh;
  }

  hiddenentry " " --hotkey f6 {
    configfile ${prefix}/power.sh;
  }
else
  menuentry $"Hotkeys" {
    echo;
  }

  menuentry $"F1 - Help" {
    echo;
  }

  menuentry $"F2 - File Manager" --hotkey f2 {
    if [ -n "${grubfm_current_path}" ];
    then
      grubfm "${grubfm_current_path}";
    else
      grubfm;
    fi;
  }

  menuentry $"F3 - OS Detect" --hotkey f3 {
    configfile ${prefix}/osdetect.sh;
  }

  menuentry $"F4 - Settings" --hotkey f4 {
    configfile ${prefix}/settings.sh;
  }

  menuentry $"F5 - Multiboot Toolkits" --hotkey f5 {
    configfile ${prefix}/util.sh;
  }

  menuentry $"F6 - Power Off" --hotkey f6 {
    configfile ${prefix}/power.sh;
  }
fi;


