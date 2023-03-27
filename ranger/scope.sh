#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

## If the option `use_preview_script` is set to `true`,
## then this script will be called and its output will be displayed in ranger.
## ANSI color codes are supported.
## STDIN is disabled, so interactive scripts won't work properly

## This script is considered a configuration file and must be updated manually.
## It will be left untouched if you upgrade ranger.

## Because of some automated testing we do on the script #'s for comments need
## to be doubled up. Code that is commented out, because it's an alternative for
## example, gets only one #.

## Meanings of exit codes:
## code | meaning    | action of ranger
## -----+------------+-------------------------------------------
## 0    | success    | Display stdout as preview
## 1    | no preview | Display no preview at all
## 2    | plain text | Display the plain content of the file
## 3    | fix width  | Don't reload when width changes
## 4    | fix height | Don't reload when height changes
## 5    | fix both   | Don't ever reload
## 6    | image      | Display the image `$IMAGE_CACHE_PATH` points to as an image preview
## 7    | image      | Display the file directly as an image

## Script arguments
FILE_PATH="${1}"         # Full path of the highlighted file
PV_WIDTH="${2}"          # Width of the preview pane (number of fitting characters)
PV_HEIGHT="${3}"         # Height of the preview pane (number of fitting characters)
IMAGE_CACHE_PATH="${4}"  # Full path that should be used to cache image preview
PV_IMAGE_ENABLED="${5}"  # 'True' if image previews are enabled, 'False' otherwise.

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

## Settings
HIGHLIGHT_SIZE_MAX=262143  # 256KiB

handle_image() {
	local mimetype="${1}"
	case "${mimetype}" in
		## SVG
		image/svg+xml|image/svg)
			convert -- "${FILE_PATH}" "${IMAGE_CACHE_PATH}" && exit 6
			exit 1;;

		## Image
		image/*)
			local orientation
			orientation="$( identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}" )"
			## If orientation data is present and the image actually
			## needs rotating ("1" means no rotation)...
			if [[ -n "$orientation" && "$orientation" != 1 ]]; then
				## ...auto-rotate the image according to the EXIF data.
				convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && exit 6
			fi
			exit 7;;

		## Video
		video/*)
			# Thumbnail
			ffmpeg -ss 00:00:30 -i "${FILE_PATH}" -vf 'scale=960:960:force_original_aspect_ratio=decrease' -vframes 1 "${IMAGE_CACHE_PATH}" && exit 6
			exit 1;;

		## PDF
		# application/pdf)
		#     pdftoppm -f 1 -l 1 \
		#              -scale-to-x "${DEFAULT_SIZE%x*}" \
		#              -scale-to-y -1 \
		#              -singlefile \
		#              -jpeg -tiffcompression jpeg \
		#              -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" \
		#         && exit 6 || exit 1;;


		## ePub, MOBI, FB2 (using Calibre)
		application/epub+zip|application/x-mobipocket-ebook|\
		application/x-fictionbook+xml)
			ebook-meta --get-cover="${IMAGE_CACHE_PATH}" -- "${FILE_PATH}" > /dev/null && exit 6
			exit 1;;

		## Font
		application/font*|application/*opentype)
			preview_png="/tmp/$(basename "${IMAGE_CACHE_PATH%.*}").png"
			if fontimage -o "${preview_png}" \
									 --pixelsize "120" \
									 --fontname \
									 --pixelsize "80" \
									 --text "  ABCDEFGHIJKLMNOPQRSTUVWXYZ  " \
									 --text "  abcdefghijklmnopqrstuvwxyz  " \
									 --text "  0123456789.:,;(*!?') ff fl fi ffi ffl  " \
									 --text "  The quick brown fox jumps over the lazy dog.  " \
									 "${FILE_PATH}";
			then
				convert -- "${preview_png}" "${IMAGE_CACHE_PATH}" && rm "${preview_png}" && exit 6
				rm "${preview_png}"
			else
				exit 1
			fi
			;;
	esac
}

handle_extension() {
	case "${FILE_EXTENSION_LOWER}" in
		## Archive
		a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
		rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
			bsdtar --list --file "${FILE_PATH}" && exit 5
			exit 1;;

		rar)
			## Avoid password prompt by providing empty password
			unrar lt -p- -- "${FILE_PATH}" && exit 5
			exit 1;;

		7z)
			## Avoid password prompt by providing empty password
			7zz l -p -- "${FILE_PATH}" && exit 5
			exit 1;;

		## BitTorrent
		torrent)
			transmission-show -- "${FILE_PATH}" && exit 5
			exit 1;;

		## JSON
		json)
			jq --color-output . "${FILE_PATH}" && exit 5;;
	esac
}

handle_mime() {
	local mimetype="${1}"
	case "${mimetype}" in
		## Text
		text/* | */xml)
			## Syntax highlight
			if [[ "$( stat -f '%z' -- "${FILE_PATH}" )" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
				exit 1
			fi
			env COLORTERM=8bit bat --color=always --style="plain"	-- "${FILE_PATH}" && exit 5
			exit 2;;

		## JSON
		*/json)
			jq --color-output . "${FILE_PATH}" && exit 5;;

		## Image
		image/*)
			exiftool "${FILE_PATH}" && exit 5
			exit 1;;

		## Video and audio
		video/* | audio/*)
			exiftool "${FILE_PATH}" && exit 5
			exit 1;;
	esac
}

handle_fallback() {
	echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}" && exit 5
	exit 1
}


MIMETYPE="$( file --dereference --brief --mime-type -- "${FILE_PATH}" )"
if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
	handle_image "${MIMETYPE}"
fi
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1
