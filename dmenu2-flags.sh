# shellcheck source=/home/swim/.cache/wal/colors.sh
source ~/.cache/wal/colors.sh \
	|| notify-send dmenu_run "Couldn't find a wal colorscheme."

geom=($(</sys/class/graphics/fb0/virtual_size tr "," " "))
width=$((3 * geom[0] / 5))
height=40
xpos=$(((geom[0] - width) / 2))
ypos=$(((5 * geom[1] - height) / 12))

export extraFlagsArray+=(
	"-q"
	"-fn" "sans-serif:size=12"
	"-nb" "${background:-#000000}"
	"-sb" "${color3:-#ffffff}"
	"-nf" "${foreground:-#ffffff}"
	"-sf" "${background:-#000000}"
	"-x" "$xpos" "-y" "$ypos"
	"-w" "$width" "-h" "$height"
	"-dim" "0.8"
)
