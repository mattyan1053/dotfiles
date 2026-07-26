# ポートフォワーディング(VSCode 代替)

VSCode が担っていた「手動でポートを転送する」機能を、接続元(手元の Mac)で動く
`pf-add` / `pf-rm` / `pf-ls` コマンドに置き換えたもの。herdr(VM 側)ではなく **接続元の SSH の話**
なので、実体はローカルで動く。

chezmoi は Mac / Linux でのみ運用しているため、ここでは Mac 版(zsh)のみを管理する。
Windows から繋ぐ場合は標準 OpenSSH が ControlMaster/`-f` 非対応なので方式が異なるが、
chezmoi 管理外なので本リポジトリでは扱わない(必要なら別途手動で用意する)。

## なぜこの形か

- ポートフォワードは接続元の SSH クライアントが張るもの。→ 手元の Mac に置く。
- 「稼働中の接続を切らずに後からポートを足す」のが要件。
  - **Mac**: SSH の接続多重化(ControlMaster)+ `ssh -O forward` で後付け/取消できる。踏み台
    (ProxyJump)も master が一度通れば透過。→ 最もきれいな方式をそのまま採用。
- VM(linux)は「転送される側」なので pf 系は配置しない(`.chezmoiignore` で OS 出し分け)。

## 事前準備(一度きり)

`~/.ssh/config` に、踏み台込みの Host エイリアスを用意しておく(実ホスト名はリポジトリに入れない)。
接続先は毎回引数で渡すので、環境変数などの追加設定は不要。関数は autoload 済み。

```sshconfig
Host devvm
    HostName 10.x.x.x
    User you
    ProxyJump bastion      # 踏み台越しならここ
```

第1引数(ホスト)は `~/.ssh/config` の Host エイリアスを Tab 補完できる(`_pf` 補完)。

## 使い方

```
pf-add devvm 28000        # localhost:28000 -> devvm:28000
pf-add devvm 8080 80      # localhost:8080  -> devvm:80  (ローカル:リモートが別ポート)
pf-rm  devvm 28000        # 転送を止める
pf-ls                     # いま張っている転送を一覧
pf-ls  devvm              # + devvm への master 接続の生存確認
```

`pf-add` 初回に master 接続を張り、以後は再認証なしで即時に足し引きできる。
