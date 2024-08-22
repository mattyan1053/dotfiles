# mattyan1053 dotfiles

## How to install
※clone先は `~/.local/share/chezmoi/` で固定

chezmoiが未インストールの場合
```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --ssh --apply mattyan1053
```

chezmoiがインストール済みの場合
```sh
chezmoi init --ssh --apply mattyan1053
```

## Usage

```sh
$ chezmoi add ~/.hoge # chezmoi管理対象に追加する
$ chezmoi re-add # 管理対象を更新する
$ chezmoi update # dotfilesをpullする
$ chezmoi apply # 変更を適用する
```

