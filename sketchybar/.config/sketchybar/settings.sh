# Shared settings, sourced by sketchybarrc and every plugin.

# Keep in sync with `persistent-workspaces` in ~/.config/aerospace/aerospace.toml.
# Hard-coded (instead of asking `aerospace list-workspaces`) so the bar builds
# correctly even if SketchyBar starts before AeroSpace at login.
WORKSPACES="1 2 3 4 5 6 7 8 9"

# Now-playing: bundle IDs of players to show (empty = any app), and whether
# to keep showing the widget while paused
MEDIA_PLAYERS="com.spotify.client com.apple.Music"
MEDIA_SHOW_WHEN_PAUSED=false

# Colors (0xAARRGGBB)
BLACK=0xff181819
WHITE=0xffe2e2e3
RED=0xfffc5d7c
GREEN=0xff9ed072
BLUE=0xff76cce0
YELLOW=0xffe7c664
ORANGE=0xfff39660
GREY=0xff7f8490
TRANSPARENT=0x00000000
BAR_COLOR=0xf02c2e34
POPUP_BG=0xc02c2e34
POPUP_BORDER=0xff7f8490
BG1=0xff363944
BG2=0xff414550

# Fonts and spacing
FONT="SF Pro"
NUMBER_FONT="SF Mono"
PADDINGS=3
GROUP_PADDINGS=5

# SF Symbols
ICON_APPLE="􀣺"
ICON_CPU="􀫥"
ICON_CLIPBOARD="􀉄"
ICON_SWITCH_ON="􁏮"
ICON_SWITCH_OFF="􁏯"
ICON_VOLUME_100="􀊩"
ICON_VOLUME_66="􀊧"
ICON_VOLUME_33="􀊥"
ICON_VOLUME_10="􀊡"
ICON_VOLUME_0="􀊣"
ICON_VOLUME_KNOB="??%"
ICON_BATTERY_100="􀛨"
ICON_BATTERY_75="􀺸"
ICON_BATTERY_50="􀺶"
ICON_BATTERY_25="􀛩"
ICON_BATTERY_0="􀛪"
ICON_BATTERY_CHARGING="􀢋"
ICON_WIFI_UPLOAD="􀄨"
ICON_WIFI_DOWNLOAD="􀄩"
ICON_WIFI_CONNECTED="􀙇"
ICON_WIFI_DISCONNECTED="􀙈"
ICON_WIFI_ROUTER="􁓤"
ICON_MEDIA_BACK="􀊊"
ICON_MEDIA_FORWARD="􀊌"
ICON_MEDIA_PLAY_PAUSE="􀊈"
