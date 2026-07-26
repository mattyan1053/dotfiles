# dotfiles

[chezmoi](https://www.chezmoi.io/) で管理している個人用 dotfiles。
作業用の Linux VM と手元の Mac で、同じシェル / エディタ / ターミナル環境を再現するためのもの。

[![Test Dotfiles](https://github.com/mattyan1053/dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/mattyan1053/dotfiles/actions/workflows/test.yml)
![managed by chezmoi](https://img.shields.io/badge/managed%20by-chezmoi-4c9a2a)
![Zsh](https://img.shields.io/badge/Zsh-5.8%2B-89e051?logo=zsh&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-0.11.6%2B-57a143?logo=neovim&logoColor=white)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-lightgrey?logo=linux&logoColor=white)

> [!NOTE]
> 自分の環境前提の個人用リポジトリなので、そのまま流すと既存の dotfiles を上書きします。

## Install

※ clone 先は `~/.local/share/chezmoi/` で固定

chezmoi が未インストールの場合

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mattyan1053
```

chezmoi がインストール済みの場合

```sh
chezmoi init --apply mattyan1053
```

ssh 経由で clone してくる場合、`--ssh` オプションをつけること。

## 何が入っているか

| 領域 | 中身 |
| --- | --- |
| Shell | zsh(メイン)/ bash。プロンプトは [powerlevel10k](https://github.com/romkatv/powerlevel10k) |
| zsh プラグイン | 補完・シンタックスハイライト・履歴検索・fzf-tab など7本を `.chezmoiexternals/` から取得 |
| Editor | Neovim([lazy.nvim](https://github.com/folke/lazy.nvim) で初回に自動 bootstrap)/ vim |
| Terminal | [herdr](https://herdr.dev)(tmux から移行。`dot_tmux.conf` は残置) |
| Git | lazygit / commit template / 補完 |
| Claude Code | 設定([部分管理](docs/ai-agents.md))とステータスライン |
| 自作コマンド | `bin/hgrep`(全体 grep)、`pf-add`/`pf-rm`/`pf-ls`(ポートフォワード) |

## リポジトリ構成

```
.
├── .chezmoiexternals/   # 外部リポジトリ(zsh プラグイン / p10k)の取得定義
├── .chezmoiscripts/     # apply 時に一度だけ流れるスクリプト
├── .github/workflows/   # CI: chezmoi の検証 + テンプレート構文チェック
├── bin/                 # PATH に載せて直接叩くもの(配布対象外)
├── docs/                # 設計メモ(配布対象外)
├── dot_claude/          # Claude Code
├── dot_config/          # nvim / lazygit / herdr
├── dot_zsh/             # aliases / completions / functions
├── dot_*                # ホーム直下に配る各種 rc
└── run_onchange_install-herdr-plugins.sh   # herdr プラグインの導入
```

`bin/` には自作の `hgrep` と lazygit のバイナリが入っている。`.chezmoiignore` で配布対象外に
してあるが、`$HOME/.local/share/chezmoi/bin` を PATH に通してある(`dot_zshrc.tmpl` /
`dot_bashrc.tmpl`)ので、apply しなくてもそのまま実行できる。

## Usage

```sh
chezmoi add ~/.hoge   # chezmoi 管理対象に追加する
chezmoi re-add        # 管理対象を更新する
chezmoi update        # dotfiles を pull する
chezmoi apply         # 変更を適用する
chezmoi diff          # 適用前に差分を見る
```

マシン固有の設定は `~/.zshrc.local` / `~/.bashrc.local` に書く。
どちらも rc の末尾で読み込まれ、`.chezmoiignore` で管理対象から外してある。

## Dependencies

| ツール | バージョン |
| --- | --- |
| Bash | v5.1.8 以上 |
| Zsh | v5.8 以上 |
| Neovim | v0.11.6 以上 |
| fzf | v0.58.0 以上 |
| bat | v0.24.0 以上 |
| ripgrep | v14.1.1 以上 |

フォントは [MesloLGS NF Regular](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf) を推奨(bash/zsh の表示に利用しているため)。

## Docs

「なぜこうしているか」は `docs/` にまとめてある。

| | 内容 |
| --- | --- |
| [AI エージェントの設定](docs/ai-agents.md) | Claude Code / Codex / Gemini をどこまで管理しているか、`settings.json` を部分管理にしている理由 |
| [ポートフォワーディング](docs/port-forwarding.md) | VSCode のポート転送を `pf-add` / `pf-rm` / `pf-ls` に置き換えた話 |
