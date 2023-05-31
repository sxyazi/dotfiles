#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

## This script is a template script for creating textual file previews in Joshuto.
##
## Copy this script to your Joshuto configuration directory and refer to this
## script in `joshuto.toml` in the `[preview]` section like
## ```
## preview_script = "~/.config/joshuto/preview_file.sh"
## ```
## Joshuto will call this script for each file when first hovered by the cursor.
## If this script returns with an exit code 0, the stdout of this script will be
## the file's preview text in Joshuto's right panel.
## The preview text will be cached by Joshuto and only renewed on reload.
## ANSI color codes are supported if Joshuto is build with the `syntax_highlight`
## feature.
##
## This script is considered a configuration file and must be updated manually.
## It will be left untouched if you upgrade Joshuto.
##
## Meanings of exit codes:
##
## code | meaning    | action of ranger
## -----+------------+-------------------------------------------
## 0    | success    | Display stdout as preview
## 1    | no preview | Display no preview at all
##
## This script is used only as a provider for textual previews.
## Image previews are independent from this script.
##

## Script arguments
FILE_PATH=""
PREVIEW_WIDTH=10
PREVIEW_HEIGHT=10

## Settings
HIGHLIGHT_SIZE_MAX=262143  # 256KiB

while [ "$#" -gt 0 ]; do
	case "$1" in
		"--path")
			shift
			FILE_PATH="$1"
			;;
		"--preview-width")
			shift
			PREVIEW_WIDTH="$1"
			;;
		"--preview-height")
			shift
			PREVIEW_HEIGHT="$1"
			;;
	esac
	shift
done

handle_extension() {
	case "${FILE_EXTENSION_LOWER}" in
		## Archive
		a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
		rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
			bsdtar --list --file "${FILE_PATH}" && exit 0
			exit 1 ;;
		rar)
			## Avoid password prompt by providing empty password
			unrar lt -p- -- "${FILE_PATH}" && exit 0
			exit 1 ;;
		7z)
			## Avoid password prompt by providing empty password
			7zz l -p -- "${FILE_PATH}" && exit 0
			exit 1 ;;

		## JSON
		json|ipynb)
			jq --color-output . "${FILE_PATH}" && exit 0
			exit 1 ;;

		## PDF
		pdf)
			exiftool "${FILE_PATH}" && exit 0
			exit 1 ;;

		## BitTorrent
		torrent)
			transmission-show -- "${FILE_PATH}" && exit 0
			exit 1 ;;
	esac
}

handle_mime() {
	case "${1}" in
		## Text
		text/* | */xml)
			## Syntax highlight
			if [[ "$( stat -f '%z' -- "$FILE_PATH}" )" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
				exit 1
			fi
			bat --color=always --style="plain" -- "${FILE_PATH}" && exit 0
			exit 1 ;;

		## JSON
		*/json)
			jq --color-output . "${FILE_PATH}" && exit 0
			exit 1 ;;

		## SVG
		image/svg+xml|image/svg)
			exif=`exiftool "$FILE_PATH"`
			file_size=`echo "$exif" | grep '^File Size' | awk '{print $4 " " $5}'`
			duration=`echo "$exif" | grep '^Duration' | awk '{print $4}'`
			mime_type=`echo "$exif" | grep '^MIME Type' | awk '{print $4}'`
			echo -e "File Size  : $file_size\nImage Size : $image_size\nMIME Type  : $mime_type"

			if [ ! -f "$cache_file" ]; then
			cache_file="/tmp/joshuto-cache/$(echo -n "$FILE_PATH" | md5sum | awk '{print $1}').jpg"
				mkdir /tmp/joshuto-cache > /dev/null 2>&1
				convert -- "${FILE_PATH}" "$cache_file"
			fi
			exit 0 ;;

		## Image
		image/*)
			exif=`exiftool "$FILE_PATH"`
			file_size=`echo "$exif" | grep '^File Size' | awk '{print $4 " " $5}'`
			image_size=`echo "$exif" | grep '^Image Size' | awk '{print $4}'`
			mime_type=`echo "$exif" | grep '^MIME Type' | awk '{print $4}'`
			echo -e "File Size  : $file_size\nImage Size : $image_size\nMIME Type  : $mime_type"
			exit 0 ;;

		## Video
		video/*)
			exif=`exiftool "$FILE_PATH"`
			file_size=`echo "$exif" | grep '^File Size' | awk '{print $4 " " $5}'`
			duration=`echo "$exif" | grep '^Duration' | awk '{print $3}'`
			mime_type=`echo "$exif" | grep '^MIME Type' | awk '{print $4}'`
			echo -e "File Size : $file_size\nDuration  : $duration\nMIME Type : $mime_type"

			cache_file="/tmp/joshuto-cache/$(echo -n "$FILE_PATH" | md5sum | awk '{print $1}').jpg"
			if [ ! -f "$cache_file" ]; then
				mkdir /tmp/joshuto-cache > /dev/null 2>&1
				ffmpeg -ss 00:00:30 -i "${FILE_PATH}" -vf 'scale=960:960:force_original_aspect_ratio=decrease' -vframes 1 "$cache_file"
			fi
			exit 0 ;;

		## Audio
		audio/*)
			exiftool "${FILE_PATH}" && exit 0
			exit 1 ;;
	esac
}

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"
handle_extension
handle_mime "$( file --dereference --brief --mime-type -- "${FILE_PATH}" )"

exit 1
