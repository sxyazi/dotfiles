#!/usr/bin/env bash

FILE_PATH="$1"       # Full path of the previewed file
PREVIEW_X_COORD="$2" # x coordinate of upper left cell of preview area
PREVIEW_Y_COORD="$3" # y coordinate of upper left cell of preview area
PREVIEW_WIDTH="$4"   # Width of the preview pane (number of fitting characters)
PREVIEW_HEIGHT="$5"  # Height of the preview pane (number of fitting characters)

function show_image {
	kitty +kitten icat \
		--transfer-mode=file \
		--clear 2>/dev/null
	kitty +kitten icat \
		--transfer-mode=file \
		--place "${PREVIEW_WIDTH}x$(($PREVIEW_HEIGHT - $2))@${PREVIEW_X_COORD}x$(($PREVIEW_Y_COORD + $2))" \
		"$1" 2>/dev/null
}

case "$(file --mime-type -Lb "$FILE_PATH")" in
	image/*)
		show_image "$FILE_PATH" 4
		;;

	video/*)
		cache_file="/tmp/joshuto-cache/$(echo -n "$FILE_PATH" | md5sum | awk '{print $1}').jpg"
		show_image "$cache_file" 4
	;;

	*)
		kitty +kitten icat \
			--transfer-mode=file \
			--clear 2>/dev/null
		;;
esac

