source ${prefix}/func.sh;

if [ -f "${theme_info}" ];
then
  export theme=${theme_info};
fi;

stat -s size -z "${grubfm_file}";
stat -s info "${grubfm_file}";
regexp -s 1:hsize -s 2:offset '^([0-9a-zA-Z\.]+) [0-9] ([0-9]+)$' "${info}";

menuentry $"File Info -- Press [ENTER] to back" --class info {
  grubfm_open "${grubfm_file}";
}

menuentry "${grubfm_name}" --class file {
  grubfm_open "${grubfm_file}";
}

menuentry $"Type: ${grubfm_fileext}" --class cfg {
  grubfm_open "${grubfm_file}";
}

menuentry $"Path:" --class dir {
  grubfm_open "${grubfm_file}";
}

menuentry "  ${grubfm_file}" {
  grubfm_open "${grubfm_file}";
}

menuentry $"Size: ${hsize} (${size})" --class hdd {
  grubfm_open "${grubfm_file}";
}

menuentry $"Offset on disk: ${offset}" --class hdd {
  grubfm_open "${grubfm_file}";
}

probe --set=fs -f "${grubfm_device}";
if [ "${fs}" = "fat" -o "${fs}" = "exfat" -o "${fs}" = "ntfs" ];
then
  stat --set=frag -c "${grubfm_file}";
  if [ "${frag}" = "1" ];
  then
    menuentry $"File is contiguous." --class frag {
      grubfm_open "${grubfm_file}";
    }
  fi;
  if [ "${frag}" -gt 1 ];
  then
    menuentry $"File is non-contiguous. (${frag} fragments)" --class frag {
      grubfm_open "${grubfm_file}";
    }
  fi;
fi;
