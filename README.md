# work-setup

仕事用PC（Windows）のセットアップを再現するための個人 dotfiles リポジトリ。
VSCode 設定・Vim ドリル・案件作業用 PowerShell 関数をまとめて管理。

## クイックスタート

### 会社PCで使う場合
```
git clone https://github.com/komekomeclub5/work-setup.git C:\work\dotfiles
cd C:\work\dotfiles
scripts\apply-vscode.bat
powershell -ExecutionPolicy Bypass -File scripts\install-gc.ps1
```

- `apply-vscode.bat`：VSCode の `settings.json` `keybindings.json` を反映（既存設定は `.bak` でバックアップ）
- `install-gc.ps1`：PowerShell プロファイルに `gc` / `gcrm` / `gcclean` 関数を登録

新しい PowerShell を開けば使えます。

## 案件操作コマンド

実行前に案件用親ディレクトリ（例: `C:\web\直案`）に `cd` してから使用。

### `gc <repo-url>` — clone & 素材フォルダ作成 & VSCode起動
```
cd C:\web\直案
gc https://github.com/example/case-xxx.git
```
動作：
- `<repo名>\` に clone
- `<repo名>_assets\`（兄弟ディレクトリ）を作成 — 受領素材の置き場
- VSCode で `<repo名>\` を開く
- Explorer で `<repo名>_assets\` を開く（素材ドラッグ＆ドロップ用）

### `gcrm <repo名>` — 個別削除
```
gcrm case-xxx
```
- `<repo名>\` と `<repo名>_assets\` を削除（確認プロンプトあり）

### `gcclean` — 一括削除
```
gcclean
```
- カレントディレクトリ配下のすべてのフォルダを削除
- `yes` をタイプしないと実行されない強い確認プロンプト
- 直案/パートナーディレクトリ自体は消さない

## 素材管理の方針：兄弟ディレクトリ方式

```
C:\web\直案\
  ├── <repo>\          ← gc で clone（git管理対象）
  └── <repo>_assets\   ← 受領素材・作業中ファイル（git対象外）
```

- リポジトリの .gitignore を触らない
- 案件完了時は `gcrm <repo>` で両方まとめて削除
- Chrome のダウンロード保存先を `<repo>_assets\` にすればゴミ化なし

### 推奨：案件ごと1 VSCodeウィンドウ
複数案件を1画面でまとめない方が安全。理由：
- 全文検索が別案件に飛ぶ
- 誤って別案件のファイルを編集する事故

## 案件作業シート自動生成（Gemini Code Assist 連携）

Web更新案件の依頼内容を貼り付けると、6フェーズ構造の作業シートを自動生成する Markdown スニペットを同梱。社内システムから取得した依頼情報を Gemini Code Assist 等の VSCode 拡張に投げて、判断材料を外部化するための副操縦士として使う。

### セットアップ
1. VSCode 拡張 `Gemini Code Assist` をインストールし、会社 Google アカウントでサインイン（Workspace 契約下なら学習対象外）
2. `scripts\apply-vscode.bat` 実行でスニペット `markdown.json` も反映される
3. Agent モードを使うなら `windows\GEMINI.md` を `C:\web\GEMINI.md` にコピー
4. `windows\_lessons_template.md` `windows\_rules_template.md` をそれぞれ `C:\web\_worksheets\_lessons.md` `_rules.md` にコピー（初回1回だけ）

### LLM フロントエンドは差し替え可能

スニペット（`co` 等）は**LLM 非依存のプロンプト**として書かれている。Gemini Code Assist が使えなくなった場合や、別ツールに移行する場合もスニペット本体はそのまま使える。

| 移行先 | 必要対応 |
|--------|---------|
| Antigravity IDE（VSCode fork） | `apply-vscode.bat` の TARGET を `%APPDATA%\Antigravity\User` に変更してコピー先を切替 |
| Antigravity CLI（`agy`） | スニペット展開後のテキストを `agy` に渡す（プロンプトはそのまま） |
| GitHub Copilot Chat 等 | チャットパネルに貼り付けるだけ。プロンプトは無改造で動く |

**2026-06-18 注意**：Gemini CLI / Gemini Code Assist は Google AI Pro/Ultra/Free 個人ティアでサポート終了。Antigravity への移行が公式アナウンス済み。Workspace 契約は別ティアのため対象外の可能性が高いが、要 IT 確認。

### Agent モード（推奨・GEMINI.md 配置済みの場合）

`C:\web\GEMINI.md` が読み込まれている状態で、Gemini Code Assist の **Agent モードを ON** にする。

#### 操作
1. Gemini Code Assist チャットを開く
2. 自然言語で話しかける：「案件来た」「提出前チェックして」「差し戻し対応」「ルール変わった」
3. 副操縦士が「1問ずつ」聞いてくる → 答える
4. 書き込みが必要な時は必ず確認してくれる

#### 覚えること
- チャットに話しかけるだけ
- `co` snippet も `_co.md` スクラッチも `gdiff` も不要（Agent が git コマンドを直接実行する）

#### 差し戻しと社内ルールが蓄積される
- モード d 完了時に副操縦士が `_lessons.md` への追記を提案 → 承認すれば追記
- モード r で社内ルール変更を `_rules.md` に追記
- 次回以降のセッションで Agent はこれらを必ず読んで判断材料にする

### 使い方：覚えるのは `co` だけ（snippet モード・Agent 使えない時用）

スニペットは VSCode エディタ（markdown ファイル）内でしか展開されない。Gemini Code Assist のチャット欄では動かないので、**常駐スクラッチファイル方式**で運用する。

#### セットアップ（1回だけ）
- `C:\web\_worksheets\_co.md` という空ファイルを作って、VSCode で常に開いておく
- `windows\_worksheets_README.md` を `C:\web\_worksheets\README.md` にコピー（クイックリファレンス用）

#### 1案件あたりの操作
1. `_co.md` をクリック（フォーカス）
2. `co` → Tab → スニペット展開
3. `Ctrl+A` → `Ctrl+C`（全選択コピー）
4. Gemini Code Assist チャット欄をクリック → `Ctrl+V` → Enter
5. `_co.md` に戻り `Ctrl+Z` で空に戻す（次回再利用のため）
6. あとは Gemini の質問に1問ずつ答えるだけ

**覚えること**
- `_co.md` を開く
- `co` Tab → `Ctrl+A C` → チャットへ `Ctrl+V`
- Gemini の質問に答える

これだけ。ワーキングメモリ消費ゼロを狙った構成。

| 文字 | モード | 事前準備 |
|------|--------|---------|
| `a` | 新規案件着手（依頼内容貼付） | ① `gc <url>` または `git pull` で repo 最新化 ② worksheet 新規作成（`C:\web\_worksheets\YYYY-MM-DD_案件番号.md`） |
| `b` | 同サイト過去案件参照 | なし |
| `c` | 提出前チェック | 案件 repo で `gdiff` 実行 |
| `d` | 差し戻し対応 | 案件 repo で `gdiff` 実行 |
| `e` | 週次振り返り | なし（金曜終業前推奨） |

### 実行手順（朝〜終業の流れ）

#### 朝（始業時・1回だけ）
1. VSCode で `C:\web\` を Open Folder
2. `_worksheets/_co.md` をタブで開いておく

#### 案件が来たら（モード a）
1. ターミナルを開く
2. 初回案件：`cd C:\web\直案` → `gc <repo-url>`
   既存案件の追加：`cd C:\web\直案\<repo>` → `git pull`
3. 新規 worksheet 作成：`C:\web\_worksheets\YYYY-MM-DD_案件番号.md`
4. `_co.md` をクリック → `co` → Tab → `Ctrl+A` → `Ctrl+C`
5. Gemini Code Assist チャットに `Ctrl+V` → Enter
6. `a` と返答 → repo 名・依頼内容を順に答える
7. 返ってきた作業シート（**編集候補ファイル付き**）を worksheet ファイルに貼り付け
8. `_co.md` を `Ctrl+Z` で空に戻す

#### 編集 → 提出前チェック（モード c）
1. repo 内で編集 → 1変更ごとに commit→push→本番確認
2. ターミナルで `gdiff` 実行
3. `_co.md` → `co` Tab → コピー → チャット貼付 → `c` と返答
4. Gemini の指摘に従って修正（必要なら gdiff → casecheck 再実行）

#### 差し戻しが来たら（モード d）
1. `gdiff` 実行
2. `co` → `d` → 指摘内容・repo 名・worksheet 名を答える
3. Gemini が原因と再発防止策を返す
4. `casews` Phase 6 への追記候補は work-setup の `vscode/snippets/markdown.json` に取り込む

#### 金曜終業前（モード e・5分）
1. `co` → `e` → 期間を答える
2. 振り返り内容をメモして翌週意識
3. `gdiffclean` で `_tmp/` を掃除

### パワーユーザー向け：個別スニペット

`co` を経由せず直接モードに入りたい時用。覚える必要はない。

### 保存先：案件親ディレクトリ配下の専用記録フォルダ

案件 repo の外、かつ **案件親ディレクトリ（`C:\web\`）配下**に記録専用フォルダを置く：

```
C:\web\
  ├── 直案\
  │    ├── <repo>\          ← gc で clone（git管理）
  │    └── <repo>_assets\
  ├── パートナー\
  │    └── ...
  └── _worksheets\          ← 各 repo 外・git管理なし
       ├── 2026-06-09_案件番号A.md
       └── 2026-06-10_案件番号B.md
```

VSCode で `C:\web\` をワークスペースとして開けば、**Gemini Code Assist がコードと worksheet を同一コンテキストで参照可能**。
これにより、差分自動抽出・提出前チェック・差し戻し原因調査が可能になる（後述）。

利点：
- 案件 git リポジトリに誤コミットされる事故を防止（各 repo の外に配置）
- Gemini が `<repo>` の git diff と worksheet を同時に読める
- 過去案件の判断ログ・差し戻し履歴をまとめて grep できる
- 案件フォルダを `gcrm` で削除しても作業シートは残る

ファイル名規約：`YYYY-MM-DD_案件番号.md`（日付ソートで時系列に並ぶ）

### 個別スニペット一覧（co を使わない場合）

`co` 経由なら覚えなくて良いが、直接呼びたい時用：

| prefix | 用途 | 事前準備 |
|--------|------|---------|
| `casews` | 新規案件作業シート生成 | worksheet 新規作成 |
| `caseref` | 同サイト過去案件参照 | なし |
| `casecheck` | 提出前チェック | `gdiff` |
| `casecause` | 差し戻し原因調査 | `gdiff` |
| `casediff` | Phase 5 編集箇所を git diff から抽出 | `gdiff` |
| `casereview` | 週次振り返り | なし |
| `casestats` | 差し戻しパターン集計（月1回） | なし |

#### gdiff（diff をファイル化するヘルパー）

Gemini Code Assist は `git` コマンドを実行できないので、PowerShell ヘルパーで diff をファイルに書き出す：

```
cd C:\web\直案\<repo>
gdiff
→ C:\web\_worksheets\_tmp\<repo>.diff が生成される
```

溜まった diff は `gdiffclean` で削除。

### 育て方
- 差し戻された項目は `co` モード d で出る「次回 Phase 6 に追記すべき項目」を `casews` スニペットに反映
- スニペット本体がナレッジの本体になる

これにより「副操縦士」が**コードの実体まで見て**判断材料を返してくれる構成になる。

## ディレクトリ構成

| パス | 内容 |
|------|------|
| `vscode/settings.json` | VSCode 本体設定（Vim拡張のIME対応・改行コード対策含む） |
| `vscode/keybindings.json` | キーバインド（無変換キー→Vim Esc） |
| `vscode/snippets/markdown.json` | 案件作業シート生成スニペット（`casews`） |
| `vim/drill.md` | Vim 練習ドリル |
| `windows/keymap.md` | PowerToys による Emacs 風キーマップ設定 |
| `windows/_worksheets_README.md` | `C:\web\_worksheets\` に置くクイックリファレンス（要手動コピー） |
| `windows/GEMINI.md` | Gemini Code Assist Agent モード用プロジェクト指示（`C:\web\GEMINI.md` に手動コピー） |
| `windows/_lessons_template.md` | 差し戻しログテンプレ（`C:\web\_worksheets\_lessons.md` に初回コピー） |
| `windows/_rules_template.md` | 社内ルール変更ログテンプレ（`C:\web\_worksheets\_rules.md` に初回コピー） |
| `windows/_case_worksheet_template.md` | AI 制限時の手動記入用テンプレ（`C:\web\_worksheets\` に置いてコピー元として使う） |
| `git/.gitconfig` | Git 設定（autocrlf=false 等） |
| `scripts/apply-vscode.bat` | VSCode 設定反映 |
| `scripts/gc.ps1` | gc / gcrm / gcclean 関数定義 |
| `scripts/install-gc.ps1` | PowerShell プロファイルに gc.ps1 を登録 |

## 設計方針

- **ソフト追加なしで動く設定だけ**（会社PCの制約）
- **コピペ不要**：clone → bat / ps1 実行で反映完了
- **JIS配列 + Windows + 日本語IME** 前提
