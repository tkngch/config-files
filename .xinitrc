xrdb -merge ~/.Xresources

# xset dpms 0 0 0  # disable standby, suspend, and off
# xset s 0 0  # disable screen saver blanking

setxkbmap gb -option ctrl:nocaps  # capslock as ctrl key
# xbindkeys
unclutter &  # hide mouse cursor when inactive

exec startxfce4

# feh --bg-fill /home/takao/etc/background.jpg
# if [ -x /usr/bin/nm-applet ]; then
#    nm-applet --sm-disable &
# fi
# sxhkd &
# exec bspwm
