setxkbmap pl


xrandr --output DisplayPort-0 --off --output HDMI-0 --mode 1920x1200 --pos 0x0 --rotate normal --output DVI-0 --primary --mode 1920x1200 --pos 1920x0 --rotate normal &
compton &
xwallpaper --zoom .wallpapers/mountain2.jpg
#tint2 &


#exec openbox-session
#exec i3
exec awesome
