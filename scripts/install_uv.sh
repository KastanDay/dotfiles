#!/usr/bin/env bash

set -e
set -o pipefail

export PATH="$HOME/.local/bin:$PATH"

if command -v uv >/dev/null 2>&1; then
  echo "uv already installed: $(command -v uv)"
  uv --version
  exit 0
fi

mkdir -p "$HOME/.local/bin"

if command -v curl >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | env UV_UNMANAGED_INSTALL="$HOME/.local/bin" sh
elif command -v wget >/dev/null 2>&1; then
  wget -qO- https://astral.sh/uv/install.sh | env UV_UNMANAGED_INSTALL="$HOME/.local/bin" sh
else
  echo "Neither curl nor wget is available to install uv." >&2
  exit 1
fi

uv --version
