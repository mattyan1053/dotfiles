# mattyan1053 dotfiles
chezmoiを利用したdotfiles管理リポジトリ

## How to install
※ clone先は `~/.local/share/chezmoi/` で固定

chezmoiが未インストールの場合
```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mattyan1053
```

chezmoiがインストール済みの場合
```sh
chezmoi init --apply mattyan1053
```

ssh経由でcloneしてくる場合、`--ssh`オプションをつけること。

## Dependencies
- Bash v5.1.8 以上
- Zsh v5.8 以上
- Neovim v0.11.6 以上
- fzf v0.58.0 以上
- bat v0.24.0 以上
- ripgrep v14.1.1 以上
- [MesloLGS NF Regular](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
  - bash/zshの表示に利用しているフォントがあるため推奨

## Usage

```sh
$ chezmoi add ~/.hoge # chezmoi管理対象に追加する
$ chezmoi re-add # 管理対象を更新する
$ chezmoi update # dotfilesをpullする
$ chezmoi apply # 変更を適用する
```

## Claude Code

`~/.claude/settings.json` は `dot_claude/settings.json.tmpl` で管理している。

### Codex を使う端末の設定

Codex は端末ごとに使える／使えないが分かれるため、`codex` データ変数で出し分けている
（デフォルトは `.chezmoidata.yaml` の `codex: false`）。

Codex を使う端末では、ローカルの chezmoi 設定に以下を足すと
`settings.json` に Codex plugin の有効化が含まれるようになる。

```toml
# ~/.config/chezmoi/chezmoi.toml
[data]
    codex = true
```

そのうえで plugin 本体を一度だけ手動でインストールする。

```sh
claude plugin install codex@openai-codex --scope user
```

### permissions.deny と `.env.example`

Claude Code の permission は `deny → ask → allow` で最初にマッチが勝ち、
deny に例外（gitignore の `!` のような除外）を彫り込めない。
そのため `.env.*` を一括 deny すると `.env.example` も読めなくなる。
`.env.example` / `.env.sample` を読めるようにするため、deny では
`.env.dev` / `.env.stg` / `.env.prod` などの実ファイルを個別に列挙している。
