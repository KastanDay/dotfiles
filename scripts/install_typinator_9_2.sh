#!/usr/bin/env bash

set -e
set -o pipefail

version="9.2"
app="/Applications/Typinator.app"
download_url="https://storage.ergonis.com/apps/production/typinator/archive/Typinator_f9de5b01b6.dmg?response-content-disposition=attachment%3B%20filename%3D%22Typinator_9.2.dmg%22"
workdir="$(mktemp -d)"
mountpoint="$workdir/mount"

cleanup() {
  hdiutil detach "$mountpoint" -quiet >/dev/null 2>&1 || true
  rm -rf "$workdir"
}
trap cleanup EXIT

installed_version() {
  if [ -f "$app/Contents/Info.plist" ]; then
    /usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist" 2>/dev/null || true
  fi
}

if [ "$(installed_version)" = "$version" ]; then
  echo "Typinator $version already installed."
  exit 0
fi

if command -v brew >/dev/null 2>&1 && brew list --cask typinator >/dev/null 2>&1; then
  brew uninstall --cask typinator
fi

osascript -e 'tell application "Typinator" to quit' >/dev/null 2>&1 || true

mkdir -p "$mountpoint"
curl -fL "$download_url" -o "$workdir/Typinator_$version.dmg"
hdiutil attach "$workdir/Typinator_$version.dmg" -nobrowse -quiet -mountpoint "$mountpoint"

rm -rf "$app"
cp -R "$mountpoint/Typinator.app" "$app"

echo "Installed Typinator $(installed_version)."
