#!/usr/bin/env bash
# nvimのプラグインを同期する
if command -v nvim >/dev/null 2>&1; then
  echo "Running PackerSync..."
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
else
  echo "nvim not found, skipping PackerSync."
fi
