#!/bin/sh
# ~/.xinitrc

# for nvidia optimus
# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto

xrdb -merge ~/.Xresources

# xset dpms 0 0 0  # disable standby, suspend, and off
xset s 1200 1200  # Change screen save blank time to 20 minutes
# xset s 0 0  # disable screen saver blanking

# capslock as ctrl key
setxkbmap -layout gb -option ctrl:nocaps

# xbindkeys

# hide mouse cursor when inactive
unclutter &

# adjusts the color temperature of your screen according to your surroundings.
# use latitude and longitude of London UK
# redshift-gtk -l 51.50:0.12 &

# file synchronization
# syncthing-gtk --minimized &

# for taking screenshot, run flameshot as background process.
test "$(command -v flameshot)" && flameshot &

# register the input method modules with fcitx and support xim programs
# For Japanese input, remember to uncomment ja_JP.UTF-8 in /etc/locale.gen and run locale-gen as su
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx


exec_awesome() {
    test "$(command -v fcitx)" && fcitx -d
    test "$(command -v picom)" && picom -C &
    test "$(command -v nm-applet)" && nm-applet &
    # pulseaudio systray applet
    test "$(command -v pasystray)" && pasystray &
    # cbatticon is a battery indicator that sits on the systray.
    test "$(command -v cbatticon)" && cbatticon -i 'symbolic' -n &
    exec awesome
}


exec_dwm() {
    export _JAVA_AWT_WM_NONREPARENTING=1
    # compositor, to fix some issues around window drawing and screen tearing.
    test "$(command -v picom)" && picom -C &
    test "$(command -v fcitx)" && fcitx -d
    test "$(pgrep -x 'xset_status')" || "${HOME}/bin/xset_status" &

    if test "$(command -v hsetroot)";
    then
       hsetroot -solid "#2d2c28"  # solid colour background
    else
       xsetroot -solid "#2d2c28"  # solid colour background
    fi

    start_dwm() {
        while true
        do
            "${HOME}"/bin/dwm 2> "${HOME}"/.dwm.log
        done
    }
    exec start_dwm
}


exec_xfce() {
    exec startxfce4
}


exec_bspwm() {
    echo "Starting BSPWM."
# bspwm
# feh --bg-fill ${HOME}/etc/background.jpg
# if [ -x /usr/bin/nm-applet ]; then
#    nm-applet --sm-disable &
# fi
# sxhkd &
# exec bspwm
}

exec_awesome
