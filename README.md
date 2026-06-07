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

### 保存先：専用記録フォルダ

案件フォルダ（git管理対象）には置かず、**記録専用フォルダ**を1つ用意してそこに集約する：

```
C:\work\worksheets\
  ├── 2026-06-09_案件番号A.md
  ├── 2026-06-09_案件番号B.md
  └── 2026-06-10_案件番号C.md
```

利点：
- 案件 git リポジトリに誤コミットされる事故を防止
- 過去案件の判断ログ・差し戻し履歴をまとめて grep できる
- 案件フォルダを `gcrm` で削除しても作業シートは残る
- 同じサイトの再依頼時に過去シートを参照できる

ファイル名規約：`YYYY-MM-DD_案件番号.md`（日付ソートで時系列に並ぶ）

### 使い方（1案件あたり30秒）
1. `C:\work\worksheets\` に `YYYY-MM-DD_案件番号.md` を新規作成
2. ファイル内で `casews` と入力 → Tab でスニペット展開
3. カーソルが「依頼情報」直下に置かれるので、社内システムから取得した依頼内容を貼り付け
4. ファイル全選択 → Gemini Code Assist チャットに貼り付け → Enter
5. 返ってきた Markdown で同ファイルを上書き保存
6. VSCode 右半分に開き、上から埋めながら作業（左半分は案件コード）

### 6フェーズ構造
| Phase | 内容 |
|-------|------|
| 1 受領 | 種別／流入／締切／受領返信要否 |
| 2 要件抽出 | 何を／どこを／順番／素材／**不明点** |
| 3 サイト構成判定 | HTML直／独自CMS／WordPress、画像保管場所 |
| 4 素材処理 | リサイズ／リネーム／PDF変換／PDFタイトル変更 |
| 5 実装 | 編集箇所リスト（順番付き）、1変更ずつ commit→push |
| 6 公開前チェック | 画像サイズ／クリック表示／スマホ／致命的領域 |
| 7 完了報告 | 完了処理／完了メール／チェック依頼 |

### 育て方
- 差し戻された項目はスニペット Phase 6 に追記して次回以降に効かせる
- 案件種別ごとの罠はルール節に追記
- スニペット本体がナレッジの本体になる

### 振り返り・参照用スニペット

worksheets フォルダを VSCode で開いた状態で Gemini Code Assist に投げる前提。
過去シート横断分析のためのプロンプト集。

| prefix | 用途 | タイミング |
|--------|------|-----------|
| `casereview` | 週次振り返り（完了件数・差し戻し傾向・改善1行動） | 金曜終業前 |
| `casestats` | 差し戻しパターン集計（上位3つを casews Phase 6 に追記） | 月1回 |
| `caseref` | 同一サイト過去シート参照（構成・特殊ルール・差し戻し履歴） | 案件着手時 |

蓄積したシートが資産になり、casews スニペット自体が育っていくループを作る。

## ディレクトリ構成

| パス | 内容 |
|------|------|
| `vscode/settings.json` | VSCode 本体設定（Vim拡張のIME対応・改行コード対策含む） |
| `vscode/keybindings.json` | キーバインド（無変換キー→Vim Esc） |
| `vscode/snippets/markdown.json` | 案件作業シート生成スニペット（`casews`） |
| `vim/drill.md` | Vim 練習ドリル |
| `windows/keymap.md` | PowerToys による Emacs 風キーマップ設定 |
| `git/.gitconfig` | Git 設定（autocrlf=false 等） |
| `scripts/apply-vscode.bat` | VSCode 設定反映 |
| `scripts/gc.ps1` | gc / gcrm / gcclean 関数定義 |
| `scripts/install-gc.ps1` | PowerShell プロファイルに gc.ps1 を登録 |

## 設計方針

- **ソフト追加なしで動く設定だけ**（会社PCの制約）
- **コピペ不要**：clone → bat / ps1 実行で反映完了
- **JIS配列 + Windows + 日本語IME** 前提
