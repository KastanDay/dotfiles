if [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Keep non-interactive zsh commands aligned with the nvm default Node.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -s "$NVM_DIR/alias/default" ]; then
  nvm_default="$(command sed 's/#.*//' "$NVM_DIR/alias/default" | command awk 'NF { print $1; exit }')"
  if [ -n "$nvm_default" ]; then
    if [ -d "$NVM_DIR/versions/node/$nvm_default/bin" ]; then
      export PATH="$NVM_DIR/versions/node/$nvm_default/bin:$PATH"
    elif [ -d "$NVM_DIR/versions/node/v$nvm_default/bin" ]; then
      export PATH="$NVM_DIR/versions/node/v$nvm_default/bin:$PATH"
    fi
  fi
  unset nvm_default
fi

. /Users/kastan/.local/share/cloudflare-warp-certs/config.sh
