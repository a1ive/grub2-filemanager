source ${prefix}/func.sh;

set theme=${theme_info};

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
