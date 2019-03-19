set gfxpayload=1024x768x32,1024x768;
if test -f (loop,msdos1)/dat10.dat -a -f (loop,msdos1)/dat11.dat -a -f (loop,msdos1)/dat12.dat; then
    linux (loop,msdos1)/dat10.dat lang=zh_CN force_modules=usbhid quiet;
    initrd (loop,msdos1)/dat11.dat (loop,msdos1)/dat12.dat;
fi;
if test -f (loop)/dat8.dat -a -f (loop)/abr64ker.dat -a -f (loop)/abr64ram.dat; then
    loopback ElTorito (loop)228+380000;
    linux (ElTorito)/abr64ker.dat product=bootagent media_for_windows quiet;
    initrd (ElTorito)/abr64ram.dat (ElTorito)/dat8.dat;
fi;

if test -f (loop)/dat4.dat -a -f (loop)/dat5.dat; then
    loopback ElTorito (loop)220+161792;
    linux (ElTorito)/dat5.dat quiet;
    initrd (ElTorito)/dat4.dat;
fi;

