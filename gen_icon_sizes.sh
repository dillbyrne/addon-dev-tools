#! /usr/bin/env bash

# depends on imagemagick
# usage : ./gen_icons_sizes.sh youricon.png

convert $1 -resize 64x64 "icon64.png"
convert $1 -resize 48x48 "icon.png"
convert $1 -resize 32x32 "icon32.png"
convert $1 -resize 16x16 "icon16.png"
