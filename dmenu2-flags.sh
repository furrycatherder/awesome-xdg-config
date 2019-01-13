# shellcheck source=/home/sean/.cache/wal/colors.sh
source ~/.cache/wal/colors.sh \
	|| notify-send dmenu-run-wrapper "Couldn't find a wal colorscheme."

export extraFlagsArray+=(
	"-q"
	"-fn" "sans-serif:size=16"
	"-nb" "${background:-#000000}"
	"-sb" "${color3:-#ffffff}"
	"-nf" "${foreground:-#ffffff}"
	"-sf" "${background:-#000000}"
	"-x" "480" "-y" "540"
	"-w" "960" "-h" "50"
)
