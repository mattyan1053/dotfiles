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
- [MesloLGS NF Regular](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
  - bash/zshの表示に利用しているフォントがあるため推奨

## Usage

```sh
$ chezmoi add ~/.hoge # chezmoi管理対象に追加する
$ chezmoi re-add # 管理対象を更新する
$ chezmoi update # dotfilesをpullする
$ chezmoi apply # 変更を適用する
```
