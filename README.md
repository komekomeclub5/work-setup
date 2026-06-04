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

## ディレクトリ構成

| パス | 内容 |
|------|------|
| `vscode/settings.json` | VSCode 本体設定（Vim拡張のIME対応・改行コード対策含む） |
| `vscode/keybindings.json` | キーバインド（無変換キー→Vim Esc） |
| `vim/drill.md` | Vim 練習ドリル |
| `git/.gitconfig` | Git 設定（autocrlf=false 等） |
| `scripts/apply-vscode.bat` | VSCode 設定反映 |
| `scripts/gc.ps1` | gc / gcrm / gcclean 関数定義 |
| `scripts/install-gc.ps1` | PowerShell プロファイルに gc.ps1 を登録 |

## 設計方針

- **ソフト追加なしで動く設定だけ**（会社PCの制約）
- **コピペ不要**：clone → bat / ps1 実行で反映完了
- **JIS配列 + Windows + 日本語IME** 前提
