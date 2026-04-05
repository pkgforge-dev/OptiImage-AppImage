#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q optiimage | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.kde.optiimage.svg
export DESKTOP=/usr/share/applications/org.kde.optiimage.desktop
export STARTUPWMCLASS=org.kde.optiimage
export DEPLOY_QT=1
export QT_DIR=qt6

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

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
