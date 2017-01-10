#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx
#

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

#DEFAULT_SESSION=xfce4-session
#case $1 in
#  xfce) exec ck-launch-session xfce4-session ;;
#  openbox) exec ck-launch-session openbox-session ;;
#  *) exec ck-launch-session $DEFAULT_SESSION ;;
#esac

xrdb -merge ~/.Xresources

xrandr --output eDP1 --dpi 227 

#xrandr --output eDP1 --scale 1.2x1.2
#xrandr --output eDP1 --panning 3072x1920

compton -b &
#pulseaudio &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#nm-applet &
xfce4-power-manager &
urxvtd &
mpd &
#pamac-tray &
#blueman
redshift-gtk &
xautolock -time 10 -locker blurlock &
setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle,grp_led:caps,ctrl:nocaps"
nitrogen --restore &

#polybar Bar &

/home/dab/bin/bar &

#exec i3
#exec bspwm
exec 2bwm
