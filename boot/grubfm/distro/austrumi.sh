set icon="slackware"
set kcmdline="rcutree.rcu_idle_gp_delay=1 lang_en dousb aa=/dev/loop1";
set kernel_img="(loop)/austrumi/bzImage"
set initrd_img="(loop)/austrumi/initrd.gz";
echo $"Loading ...";
loopback -d md_initrd
loopback -m md_initrd ${initrd_img};

set search_str="if test %-f \$CD/austrumi/austrumi.fs; then";
set replace_str="if [ %-f \$CD\$sr ]; then losetup \$aa \$CD\$sr";
set src_file="(md_initrd)/init";
lua ${prefix}/write.lua;

set search_str="echo \"    Austrumi found at \$device\"";
set replace_str="CD=\$bb; device=loop1; mount \$aa \$bb ";
set src_file="(md_initrd)/init";
lua ${prefix}/write.lua;

set search_str="# fdisk %-l | grep ^/dev | cut %-c6%-9";
set replace_str="bb=/mnt/loop1; mkdir \$bb; echo \$bb ";
set src_file="(md_initrd)/init";
lua ${prefix}/write.lua;

menuentry $"1. Run from RAM / Eject USB" --class $icon{
    linux ${kernel_img} $kcmdline $linux_extra emb_user;
    initrd (md_initrd);
}

menuentry $"2. Do not eject USB" --class $icon{
    linux ${kernel_img} $kcmdline $linux_extra emb_user nocache;
    initrd (md_initrd);
}

menuentry $"3. Superuser" --class $icon{
    linux ${kernel_img} $kcmdline $linux_extra;
    initrd (md_initrd);
}

menuentry $"4. Text mode" --class $icon{
    linux ${kernel_img} $kcmdline $linux_extra emb_user text;
    initrd (md_initrd);
}
