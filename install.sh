#!/usr/bin/env bash
set -euo pipefail

NVIM_SRC="$(cd "$(dirname "$0")" && pwd)/nvim"
NVIM_DEST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if [ ! -d "$NVIM_SRC" ]; then
  echo "Error: $NVIM_SRC does not exist or is not a directory." >&2
  exit 1
fi

if [ -e "$NVIM_DEST" ] || [ -L "$NVIM_DEST" ]; then
  echo "Backing up existing $NVIM_DEST to ${NVIM_DEST}.bak"
  mv "$NVIM_DEST" "${NVIM_DEST}.bak"
fi

ln -sf "$NVIM_SRC" "$NVIM_DEST"
echo "Symlinked $NVIM_SRC -> $NVIM_DEST"
echo "Done. Open nvim to install plugins."
