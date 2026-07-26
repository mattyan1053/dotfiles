# AI エージェントの設定

Claude Code / Codex / Gemini CLI の設定について、chezmoi でどこまで管理していて、
なぜその線引きなのかをまとめたもの。

## 管理範囲

現状 chezmoi 管理下にあるのは Claude Code の2ファイルだけ。

| 対象 | 状態 | ソース |
| --- | --- | --- |
| `~/.claude/settings.json` | **部分管理**(後述) | `dot_claude/modify_settings.json` |
| `~/.claude/statusline-command.sh` | 全体を管理 | `dot_claude/statusline-command.sh` |
| `~/.claude/CLAUDE.md` | 未作成 | — |
| `~/.codex/`(`config.toml` / `rules/` / `prompts/` / `skills/` / `hooks.json`) | 未管理 | — |
| `~/.gemini/settings.json` | 未管理 | — |

### 管理しないもの

認証情報とセッション状態は入れない。

- `~/.claude/.credentials.json` / `~/.codex/auth.json` … 認証情報
- `~/.claude/settings.local.json` … マシンごとのローカル権限設定
- `sessions/` `history.jsonl` `cache/` `*.sqlite` などの実行時状態

## ディレクトリが分かれる理由

chezmoi はソースのパスをターゲットのパスから決めるため、`~/.claude` `~/.codex` `~/.gemini` は
必ず `dot_claude/` `dot_codex/` `dot_gemini/` に分かれる。**`ai/` のような1ディレクトリに
まとめることはできない**。エージェント横断の話がこのドキュメントに集約してあるのはそのため。

## Claude Code の設定を「部分管理」にしている理由

`~/.claude/settings.json` は Claude Code 本体・herdr のインテグレーション・プラグインが
それぞれ随時書き換えるファイルで、書き込みのたびにキーの並び順まで変わる。
ファイル全体を管理すると、意味的には一致していても `chezmoi diff` がキー順の差分を
永久に出し続けることになる。

そのため chezmoi の `modify_` スクリプト(`dot_claude/modify_settings.json`)を使い、
**実体を stdin で受け取って、自分が決めたキーだけを jq でマージして返す**方式にしている。
jq は入力のキー順を保つので、実体側がどう並び替わっても差分が出ない。

| 扱い | キー | 理由 |
| --- | --- | --- |
| dotfiles が所有 | `theme` / `tui` / `agentPushNotifEnabled` / `inputNeededNotifEnabled` / `skipAutoPermissionPrompt` / `statusLine` / `permissions` | 自分で決めた設定。実体で変えられても apply で戻る |
| 各ツールに任せる | `model` | Claude Code がセッションのモデルを書き戻す |
| 〃 | `hooks` | `herdr integration install claude` が登録する |
| 〃 | `enabledPlugins` / `extraKnownMarketplaces` | プラグイン導入時に Claude Code が登録する |

「任せる」側は新しいマシンでは dotfiles からは復元されないので、それぞれの導入手順で入れる。

```sh
claude plugin install codex@openai-codex --scope user   # Codex plugin
herdr integration install claude                        # herdr の SessionStart フック
```

なお `jq` が無い環境では実体をそのまま素通しする(設定を壊さない)。

## `permissions.deny` と `.env.example`

Claude Code の permission は `deny → ask → allow` で最初にマッチが勝ち、
deny に例外(gitignore の `!` のような除外)を彫り込めない。
そのため `.env.*` を一括 deny すると `.env.example` も読めなくなる。

`.env.example` / `.env.sample` を読めるようにするため、deny では
`.env.dev` / `.env.stg` / `.env.prod` などの実ファイルを個別に列挙している。

## 今後

- グローバルの `~/.claude/CLAUDE.md` は現状置いていない。作るなら `dot_claude/CLAUDE.md`。
- Codex / Gemini は設定が育ってきた時点で取り込む。取り込む際は上の「管理しないもの」の
  線引きに従って、認証情報と実行時状態を除外すること。
