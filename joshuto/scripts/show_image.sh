#!/usr/bin/env bash

FILE_PATH="$1"       # Full path of the previewed file
PREVIEW_X_COORD="$2" # x coordinate of upper left cell of preview area
PREVIEW_Y_COORD="$3" # y coordinate of upper left cell of preview area
PREVIEW_WIDTH="$4"   # Width of the preview pane (number of fitting characters)
PREVIEW_HEIGHT="$5"  # Height of the preview pane (number of fitting characters)

function show_image {
	kitty +kitten icat \
		--clear \
		--transfer-mode=memory \
		--place "${PREVIEW_WIDTH}x$(($PREVIEW_HEIGHT - $2))@${PREVIEW_X_COORD}x$(($PREVIEW_Y_COORD + $2))" \
		"$1" 2>/dev/null
}

case "$(file -bL --mime-type "$FILE_PATH")" in
	## SVG
	image/svg+xml|image/svg)
		cache_file="/tmp/joshuto-cache/$(echo -n "$FILE_PATH" | md5sum | awk '{print $1}').jpg"
		if [ ! -f "$cache_file" ]; then
			mkdir /tmp/joshuto-cache 2>/dev/null
			convert -- "$FILE_PATH" "$cache_file" 2>/dev/null || exit 1
		fi
		show_image "$cache_file" 4 ;;

	## Image
	image/*)
		show_image "$FILE_PATH" 4 ;;

	## Video
	video/*)
		cache_file="/tmp/joshuto-cache/$(echo -n "$FILE_PATH" | md5sum | awk '{print $1}').jpg"
		if [ ! -f "$cache_file" ]; then
			mkdir /tmp/joshuto-cache 2>/dev/null
			ffmpeg -ss 00:00:30 -i "$FILE_PATH" -vf 'scale=960:960:force_original_aspect_ratio=decrease' -vframes 1 "$cache_file" 2>/dev/null || exit 1
		fi
		show_image "$cache_file" 4 ;;

	*)
		kitty +kitten icat --clear --transfer-mode=memory 2>/dev/null ;;
esac

