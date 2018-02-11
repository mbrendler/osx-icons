#! /bin/bash
#
# Creates a OS X icon, which can be used as a OS X application Icon.
#
# Informations about icons can be found here:
# https://developer.apple.com/library/mac/#documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html

set -e

TARGET=macos

if [ "$1" = '--iphone' ]; then
  TARGET=iphone
  shift
fi

ICON_NAME=$1
ICON_SET="$ICON_NAME".iconset

IN_IMAGE=$2

function usage () {
  echo "usage: $0 [--iphone] ICON_NAME IN_IMAGE"
  exit
}

if test "$ICON_NAME" == "" || test "$IN_IMAGE" == ""; then
  usage
fi

if test ! -e "$IN_IMAGE" ; then
  echo "Input image $IN_IMAGE does not exist."
  exit
fi

function info () { echo -e "\033[38;5;10m$1\033[0m"; }
function warn () { echo -e "\033[38;5;11m$1\033[0m"; }

function add_image_with_size() {
  local SIZE=$1
  if test "$2" = "" ; then
    local SIZE_FILENAME=icon_"$SIZE"x"$SIZE".png
    local REAL_SIZE=$SIZE
  else
    local factor="$2"
    local SIZE_FILENAME=icon_"$SIZE"x"$SIZE"@"$factor"x.png
    local REAL_SIZE=$((SIZE * factor))
  fi
  info "create icon $SIZE_FILENAME"
  sips -Z $REAL_SIZE --out "$ICON_SET"/"$SIZE_FILENAME" "$IN_IMAGE"
}

mkdir "$ICON_SET"

if [ "$TARGET" = iphone ] ; then
  for SIZE in 20 29 40 60 ; do
    add_image_with_size $SIZE 2
    add_image_with_size $SIZE 3
  done
  add_image_with_size 1024
else
  # needed sizes: 16, 32, 128, 256, 512 pixels
  # names: icon_16x16.png, ...
  # retina support needs also icons with double resolution: icon_16x16@2x.png, ...
  for SIZE in 16 32 128 256 512 ; do
    add_image_with_size $SIZE
    add_image_with_size $SIZE 2
  done
fi

HEIGHT="$(sips -g pixelHeight "$IN_IMAGE" | grep pixelHeight | cut -d\  -f4)"
WIDTH="$(sips -g pixelWidth "$IN_IMAGE" | grep pixelWidth | cut -d\  -f4)"
if test "$HEIGHT" != "$WIDTH" ||
   test "$HEIGHT" -lt "1024" ||
   test "$WIDTH" -lt "1024" ; then
  echo "$HEIGHT x $WIDTH"
  warn "WARNING: The input image should be bigger than 1024x1024 and a quad."
  warn "         But is $HEIGHT x $WIDTH".
fi

IN_IMAGE_TYPE="$(sips -g format "$IN_IMAGE" | grep format | cut -d\  -f4)"
if test "$IN_IMAGE_TYPE" != "png" ; then
  warn "WARNING: The input image should be a png but is a $IN_IMAGE_TYPE."
fi

info "Icon set created: $ICON_SET"
