xrdb -merge ~/.Xresources

# xset dpms 0 0 0  # disable standby, suspend, and off
# xset s 0 0  # disable screen saver blanking

# capslock as ctrl key
setxkbmap gb -option ctrl:nocaps

# xbindkeys

# hide mouse cursor when inactive
unclutter &

# adjusts the color temperature of your screen according to your surroundings.
# use latitude and longitude of London UK
# redshift-gtk -l 51.50:0.12 &

# file synchronization
# syncthing-gtk --minimized &

## register the input method modules with fcitx and support xim programs
# For Japanese input, remember to uncomment ja_JP.UTF-8 in /etc/locale.gen and run locale-gen as su
# export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export XMODIFIERS=@im=fcitx

exec startxfce4

# feh --bg-fill /home/takao/etc/background.jpg
# if [ -x /usr/bin/nm-applet ]; then
#    nm-applet --sm-disable &
# fi
# sxhkd &
# exec bspwm
