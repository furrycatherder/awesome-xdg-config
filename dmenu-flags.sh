# shellcheck source=/home/swim/.cache/wal/colors.sh
source ~/.config/wpg/formats/colors.sh \
	|| source ~/.cache/wal/colors.sh \
	|| nix run nixpkgs.libnotify -c \
	notify-send dmenu_run "Couldn't find a wal colorscheme."

geom=($(</sys/class/graphics/fb0/virtual_size tr "," " "))
width=$((3 * geom[0] / 5))
height=40
xpos=$(((geom[0] - width) / 2))
ypos=$((5 * (geom[1] - height) / 12))

export extraFlagsArray+=(
	"-fn" "serif"
	"-nb" "${background:-#ffffff}"
	"-sb" "${color2:-#ffffff}"
	"-nf" "${foreground:-#000000}"
	"-sf" "${background:-#000000}"
	"-x" "$xpos" "-y" "$ypos"
	"-w" "$width" "-h" "$height"
	"-dim" "0.8"
)
