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

# if [ -f "${theme_fm}" ];
# then
#   export theme=${theme_fm};
# fi;

hiddenentry "---- HOTKEY MENU ----" {
  echo;
}

hiddenentry "[F1] HELP" --hotkey f1 {
  configfile ${prefix}/help.sh;
}

if [ -n "${user_menu}" ];
then
	hiddenentry "[F2] BOOT MENU" --hotkey f2 {
	  configfile ${prefix}/menu.sh;
	}

	hiddenentry "[F3] FILE MANAGER" --hotkey f3 {
	  export theme=${theme_fm};
	  if [ -n "${grubfm_current_path}" ];
	  then
		grubfm "${grubfm_current_path}";
	  else
		grubfm;
	  fi;
	}

	hiddenentry "[F4] OS DETECT" --hotkey f4 {
	  configfile ${prefix}/osdetect.sh;
	}

	hiddenentry "[F5] SETTINGS" --hotkey f5 {
	  configfile ${prefix}/settings.sh;
	}

	hiddenentry "[F6] PXE BOOT MENU" --hotkey f6 {
	  configfile ${prefix}/netboot.sh;
	}

	hiddenentry "[F7] POWER OFF" --hotkey f7 {
	  configfile ${prefix}/power.sh;
	}
else
	hiddenentry "[F2] FILE MANAGER" --hotkey f2 {
	  export theme=${theme_fm};
	  if [ -n "${grubfm_current_path}" ];
	  then
		grubfm "${grubfm_current_path}";
	  else
		grubfm;
	  fi;
	}

	hiddenentry "[F3] OS DETECT" --hotkey f3 {
	  configfile ${prefix}/osdetect.sh;
	}

	hiddenentry "[F4] SETTINGS" --hotkey f4 {
	  configfile ${prefix}/settings.sh;
	}

	hiddenentry "[F5] PXE BOOT MENU" --hotkey f5 {
	  configfile ${prefix}/netboot.sh;
	}

	hiddenentry "[F6] POWER OFF" --hotkey f6 {
	  configfile ${prefix}/power.sh;
	}
fi;
