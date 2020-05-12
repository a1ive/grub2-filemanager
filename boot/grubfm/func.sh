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
  set g4d_path="${1}";
  lua ${prefix}/g4d_path.lua;
}

function unmap_cd {
  for dev in (cd*);
  do
    if [ -e ${dev} ];
    then
      map -x ${dev};
    fi;
  done;
}

regexp --set=1:grubfm_path '(/.*)$' "${grubfm_file}";
regexp --set=1:grubfm_dir '^(.*/).*$' "${grubfm_path}";
regexp --set=1:grubfm_device '^\(([0-9a-zA-Z,]+)\)/.*' "${grubfm_file}";
regexp --set=1:grubfm_disk '([chf]d[0-9]+)[0-9,]*' "${grubfm_device}";
regexp --set=1:grubfm_name '^.*/(.*)$' "${grubfm_file}";
unset grubfm_filename;
unset grubfm_fileext;
regexp --set=1:grubfm_filename '^(.*)\.(.*)$' "${grubfm_name}";
regexp --set=1:grubfm_fileext '^.*\.(.*)$' "${grubfm_name}";
