display_set_framework_zoomed() {
    sudo xrandr --newmode "1696X1128" 159.25 1696 1808 1984 2272 1128 1131 1141 1170 -hsync +vsync
    sudo xrandr --addmode eDP-1 "1696X1128"

    sudo xrandr --newmode "1368x912"  103.00  1368 1448 1592 1816  912 915 925 947 -hsync +vsync
    sudo xrandr --addmode eDP-1 "1368x912"
}
display_set_framework_zoomed
