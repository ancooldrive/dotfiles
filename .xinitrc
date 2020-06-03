setxkbmap pl

#exec openbox-session


xrandr --output DisplayPort-0 --off --output HDMI-0 --mode 1920x1200 --pos 0x0 --rotate normal --output DVI-0 --primary --mode 1920x1200 --pos 1920x0 --rotate normal &
compton &
nitrogen --restore &
#tint2 &
exec i3
