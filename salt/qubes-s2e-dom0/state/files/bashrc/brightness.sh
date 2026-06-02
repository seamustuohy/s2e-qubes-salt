brightness_max () {
    xrandr | grep ' connected' | cut -d ' ' -f 1 | xargs -I % xrandr --output % --brightness 1
    # readonly MAX=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    # echo ${MAX} | sudo tee /sys/class/backlight/intel_backlight/brightness
}

brightness_low() {
    xrandr | grep ' connected' | cut -d ' ' -f 1 | xargs -I % xrandr --output % --brightness .2
    # echo 4000 | sudo tee /sys/class/backlight/intel_backlight/brightness
}

brightness_half() {
    xrandr | grep ' connected' | cut -d ' ' -f 1 | xargs -I % xrandr --output % --brightness .5
    # echo 45000 | sudo tee /sys/class/backlight/intel_backlight/brightness
}
