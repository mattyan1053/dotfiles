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

# file-viewer: git 対応の読み取り専用ファイルビューア(ツリー + 差分 / MD整形 / シンタックス)。
# VSCode の「エクスプローラ + 差分ビュー」を herdr の split ペインで代替する(config.toml で
# prefix+alt+f に open-file-viewer を割当)。https://github.com/smarzban/herdr-file-viewer
if ! herdr plugin list --json 2>/dev/null | grep -q '"herdr-file-viewer"'; then
  herdr plugin install smarzban/herdr-file-viewer --yes
fi

# 任意レンダラ(有ると file-viewer の見た目が向上。未導入なら素テキストにフォールバック):
#   - 差分整形 delta : Rocky/RHEL では EPEL の "git-delta"(コマンド名は delta)。導入済。
#       sudo dnf install -y epel-release && sudo dnf install -y git-delta
#   - MD整形 glow    : dnf 標準リポジトリに無い。Charm repo か GitHub リリースが必要(未導入 = MD は素表示)。
#       https://github.com/charmbracelet/glow/releases
#   - コード色付け bat: 導入済。
# パッケージ名/リポジトリが環境依存なので apply 時の自動導入はしない(上記を手動で)。
