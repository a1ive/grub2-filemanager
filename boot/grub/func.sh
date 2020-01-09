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

function to_g4d_path {
  if regexp --set=1:num '^\(hd[0-9]+,[a-zA-Z]*([0-9]+)\).*' "${1}";
  then
    # (hdx,msdosy) (hdx,gpty) (hdx,y)
    expr --set=num "${num} - 1";
    regexp --set=1:path_1 --set=2:path_2 '^(\(hd[0-9]+,)[a-zA-Z]*[0-9]+(\).*)' "${1}";
    set g4d_path="${path_1}${num}${path_2}";
  elif regexp '^\([chf]d[0-9]*\).*' "${1}";
  then
    # (hd) (cd) (fd) (hdx) (cdx) (fdx)
    set g4d_path="${1}";
  else
    unset g4d_path;
  fi;
}

regexp --set=1:grubfm_path '(/.*)$' "${grubfm_file}";
regexp --set=1:grubfm_dir '^(.*/).*$' "${grubfm_path}";
regexp --set=1:grubfm_device '^\(([0-9a-zA-Z,]+)\)/.*' "${grubfm_file}";
regexp --set=1:grubfm_disk '(hd[0-9]+),msdos[1-3]' "${grubfm_device}";
regexp --set=1:grubfm_name '^.*/(.*)$' "${grubfm_file}";
regexp --set=1:grubfm_filename '^(.*)\.(.*)$' "${grubfm_name}";
regexp --set=1:grubfm_fileext '^.*\.(.*)$' "${grubfm_name}";
