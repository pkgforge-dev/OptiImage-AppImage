#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q optiimage | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.kde.optiimage.svg
export DESKTOP=/usr/share/applications/org.kde.optiimage.desktop
export STARTUPWMCLASS=org.kde.optiimage

# Deploy dependencies
quick-sharun /usr/bin/optiimage \
/usr/bin/anim_diff \
/usr/bin/anim_dump \
/usr/bin/cwebp     \
/usr/bin/dwebp     \
/usr/bin/gif2webp  \
/usr/bin/img2webp  \
/usr/bin/jpegoptim \
/usr/bin/oxipng    \
/usr/bin/scour     \
/usr/bin/webpinfo  \
/usr/bin/webpmux

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
