#!/usr/bin/env bash

set -o pipefail

export HOMEBREW_NO_AUTO_UPDATE="${HOMEBREW_NO_AUTO_UPDATE:-1}"
export HOMEBREW_DISPLAY_INSTALL_TIMES="${HOMEBREW_DISPLAY_INSTALL_TIMES:-1}"

if [ "$(uname -m)" = "arm64" ] && [ -x /opt/homebrew/bin/brew ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

formulae=(
  tmux
  fzf
  fd
  glances
  bat
  rsync
  diff-so-fancy
  ripgrep
  rga
  poppler
  ffmpeg
  pandoc
  go
  zsh
)

casks=(
  iterm2
  karabiner-elements
  bettertouchtool
  font-meslo-lg-nerd-font
  cursor
  visual-studio-code
)

if [ "${BREW_BUNDLE_FORMULAE:-}" != "" ]; then
  formulae=()
  read -r -a formulae <<< "${BREW_BUNDLE_FORMULAE}"
fi

if [ "${BREW_BUNDLE_CASKS+x}" = "x" ]; then
  casks=()
  if [ "${BREW_BUNDLE_CASKS}" != "" ]; then
    read -r -a casks <<< "${BREW_BUNDLE_CASKS}"
  fi
fi

failures=()

log() {
  printf '\n[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

warn_about_prefix() {
  local prefix
  prefix="$(brew --prefix)"
  if [ "$(uname -m)" = "arm64" ] && [ "$prefix" != "/opt/homebrew" ]; then
    log "Homebrew prefix is $prefix, not /opt/homebrew."
    printf '%s\n' "Some bottles require /opt/homebrew on Apple Silicon, so heavy packages like poppler or ffmpeg may build from source and appear slow."
  fi
}

install_formula() {
  local name="$1"
  if brew list --formula "$name" >/dev/null 2>&1; then
    log "formula already installed: $name"
    return 0
  fi

  log "installing formula: $name"
  if ! brew install "$name"; then
    failures+=("formula:$name")
    log "failed formula: $name"
    return 0
  fi
}

install_cask() {
  local name="$1"
  if brew list --cask "$name" >/dev/null 2>&1; then
    log "cask already installed: $name"
    return 0
  fi

  log "installing cask: $name"
  if brew install --cask "$name"; then
    return 0
  fi

  log "trying to adopt existing cask app: $name"
  if brew install --cask --adopt "$name"; then
    return 0
  fi

  log "trying forced cask install: $name"
  if brew install --cask --force "$name"; then
    return 0
  fi

  failures+=("cask:$name")
  log "failed cask: $name"
  return 0
}

main() {
  if ! command -v brew >/dev/null 2>&1; then
    printf '%s\n' "Homebrew is not installed or not on PATH." >&2
    return 1
  fi

  warn_about_prefix

  for formula in "${formulae[@]}"; do
    install_formula "$formula"
  done

  for cask in "${casks[@]}"; do
    install_cask "$cask"
  done

  if [ "${#failures[@]}" -gt 0 ]; then
    log "Homebrew setup completed with failures:"
    printf '  - %s\n' "${failures[@]}"
    return 1
  fi

  log "Homebrew setup completed successfully."
}

main "$@"
