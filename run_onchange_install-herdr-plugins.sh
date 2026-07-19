#!/bin/bash
# herdr プラグインのインストール(このファイルが変わったときだけ再実行される)。
# config.toml が参照するプラグイン一覧をここで揃える。
set -eu

command -v herdr >/dev/null 2>&1 || exit 0

# compose: 各 space の docker compose ステータス表示と start/stop/up/down
# https://github.com/mattyan1053/herdr-compose
if ! herdr plugin list --json 2>/dev/null | grep -q '"compose"'; then
  herdr plugin install mattyan1053/herdr-compose --yes
fi
