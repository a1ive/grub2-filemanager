#!/usr/bin/env sh
echo -n "checking for gettext ... "
if [ -e "$(which msgfmt)" ]
then
	echo "ok"
else
	echo "not found\nPlease install gettext."
	exit
fi
echo -n "checking for mkisofs ... "
if [ -e "$(which mkisofs)" ]
then
	echo "ok"
	geniso=$(which mkisofs)
else
	echo -n "not found\nchecking for genisoimage ... "
	if [ -e "$(which genisoimage)" ]
	then
		echo "ok"
		geniso=$(which genisoimage)
	else
		echo "not found\nPlease install mkisofs or genisoimage."
		exit
	fi
fi
echo -n "checking for grub ... "
if [ -e "$(which grub-mkimage)" ]
then
	echo "ok"
else
	echo "not found"
	case "$( uname -m )" in
		i?86) mkimage="./bin/grub-mkimage32"
		;;
		x86_64) mkimage="./bin/grub-mkimage64"
		;;
	esac
fi