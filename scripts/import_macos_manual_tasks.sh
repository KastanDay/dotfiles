#!/usr/bin/env bash

set -e
set -o pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manual_tasks_dir="${repo_root}/MANUAL_TASKS"

log() {
  printf '[macos-imports] %s\n' "$*"
}

app_exists() {
  local app_name="$1"
  [ -d "/Applications/${app_name}.app" ] || [ -d "$HOME/Applications/${app_name}.app" ]
}

open_app() {
  if [ "${MACOS_IMPORTS_NO_OPEN:-}" = "1" ]; then
    log "test mode: not opening $*"
    return 0
  fi

  open "$@" || true
}

timestamp() {
  date +%Y%m%d%H%M%S
}

import_iterm_profile() {
  local source_profile="${manual_tasks_dir}/iterm2_profile.json"
  local dynamic_profiles_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  local target_profile="${dynamic_profiles_dir}/kastan-dotfiles.json"

  if [ ! -f "$source_profile" ]; then
    log "missing iTerm2 profile: $source_profile"
    return 1
  fi

  mkdir -p "$dynamic_profiles_dir"

  /usr/bin/python3 - "$source_profile" "$target_profile" <<'PY'
import json
import sys
from pathlib import Path

source = Path(sys.argv[1])
target = Path(sys.argv[2])

profile = json.loads(source.read_text())
dynamic_profile = profile if "Profiles" in profile else {"Profiles": [profile]}
target.write_text(json.dumps(dynamic_profile, indent=2, sort_keys=True) + "\n")
PY

  log "installed iTerm2 dynamic profile: $target_profile"

  if app_exists "iTerm"; then
    open_app -ga "iTerm"
  fi
}

copy_typinator_set() {
  local source_set="$1"
  local sets_dir="$HOME/Library/Application Support/Typinator/Sets"
  local target_set="${sets_dir}/$(basename "$source_set")"

  mkdir -p "$sets_dir"

  if [ -d "$target_set" ]; then
    if diff -qr "$source_set" "$target_set" >/dev/null 2>&1; then
      log "Typinator set already current: $(basename "$source_set")"
      return 0
    fi

    if [ "${MACOS_IMPORTS_FORCE_TYPINATOR:-}" != "1" ]; then
      log "Typinator set already exists and differs; keeping local copy: $(basename "$source_set")"
      return 0
    fi

    mv "$target_set" "${target_set}.OLD.$(timestamp)"
    log "backed up existing Typinator set: $target_set"
  fi

  ditto "$source_set" "$target_set"
  log "installed Typinator set: $(basename "$source_set")"
}

import_typinator_sets() {
  local found_set=0

  while IFS= read -r -d '' source_set; do
    found_set=1
    copy_typinator_set "$source_set"
  done < <(find "$manual_tasks_dir" -maxdepth 1 -type d -name '*.tyset' -print0)

  if [ "$found_set" -eq 0 ]; then
    log "no Typinator .tyset folders found in $manual_tasks_dir"
    return 1
  fi

  if app_exists "Typinator"; then
    if [ "${MACOS_IMPORTS_NO_OPEN:-}" != "1" ]; then
      osascript -e 'tell application "Typinator" to quit' >/dev/null 2>&1 || true
    fi
    open_app -ga "Typinator"
  else
    log "Typinator.app is not installed yet; sets were copied into Application Support"
  fi
}

find_bttcli() {
  find /Applications "$HOME/Applications" -path '*/BetterTouchTool.app/*' -name bttcli -type f 2>/dev/null | head -n 1
}

import_bettertouchtool_preset() {
  local preset="${manual_tasks_dir}/kastan_earlysummer_2022.bttpreset"
  local bttcli

  if [ ! -f "$preset" ]; then
    log "missing BetterTouchTool preset: $preset"
    return 1
  fi

  if ! app_exists "BetterTouchTool"; then
    log "BetterTouchTool.app is not installed; skipping preset import"
    return 0
  fi

  defaults write com.hegenberg.BetterTouchTool BTTSocketServer -bool true >/dev/null 2>&1 || true
  open_app -ga "BetterTouchTool"
  if [ "${MACOS_IMPORTS_NO_OPEN:-}" != "1" ]; then
    sleep 2
  fi

  bttcli="$(find_bttcli || true)"
  if [ -n "$bttcli" ] && "$bttcli" import_preset path="$preset" replaceExisting=true; then
    log "imported BetterTouchTool preset with bttcli: $preset"
    return 0
  fi

  log "bttcli import unavailable; opening BetterTouchTool preset for app-level import"
  open_app "$preset"
}

main() {
  if [ "$(uname -s)" != "Darwin" ]; then
    log "not macOS; skipping"
    return 0
  fi

  import_iterm_profile
  import_typinator_sets
  import_bettertouchtool_preset
}

main "$@"
