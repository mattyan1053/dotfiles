#!/usr/bin/env bash
# nvimのプラグインを同期する
if command -v nvim >/dev/null 2>&1; then
  echo "Running Lazy sync..."
  nvim --headless "+Lazy! sync" +qa 2>/dev/null
else
  echo "nvim not found, skipping Lazy sync."
fi
