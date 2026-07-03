#!/usr/bin/env bash

set -e
set -o pipefail

codex_app="/Applications/Codex.app"
download_url="${CODEX_DESKTOP_DMG_URL:-https://persistent.oaistatic.com/codex-app-prod/Codex.dmg}"
tmp_dir="$(mktemp -d)"
mount_point=""

cleanup() {
  if [ -n "$mount_point" ] && mount | grep -q "on ${mount_point} "; then
    hdiutil detach "$mount_point" -quiet || true
  fi
  rm -rf "$tmp_dir"
}

trap cleanup EXIT

if [ "$(uname -s)" != "Darwin" ]; then
  echo "Codex Desktop installer is macOS-only; skipping."
  exit 0
fi

if [ "$(uname -m)" != "arm64" ]; then
  echo "This Apple Silicon setup uses the arm64 Codex Desktop build; skipping $(uname -m)."
  exit 0
fi

if [ -d "$codex_app" ]; then
  version="$(defaults read "${codex_app}/Contents/Info" CFBundleShortVersionString 2>/dev/null || true)"
  echo "Codex Desktop already installed: ${codex_app}${version:+ (${version})}"
  exit 0
fi

dmg_path="${tmp_dir}/Codex.dmg"
echo "Downloading Codex Desktop for macOS..."
curl -fL --retry 3 --connect-timeout 20 "$download_url" -o "$dmg_path"

mount_point="$(mktemp -d "${tmp_dir}/codex-dmg.XXXXXX")"
hdiutil attach "$dmg_path" -mountpoint "$mount_point" -nobrowse -quiet

source_app="$(find "$mount_point" -maxdepth 2 -name 'Codex.app' -type d | head -n 1)"
if [ -z "$source_app" ]; then
  echo "Codex.app was not found in the downloaded DMG." >&2
  exit 1
fi

if [ -w "/Applications" ]; then
  ditto "$source_app" "$codex_app"
else
  sudo ditto "$source_app" "$codex_app"
fi

xattr -dr com.apple.quarantine "$codex_app" 2>/dev/null || true
echo "Installed Codex Desktop: $codex_app"
