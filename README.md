# work-setup

仕事用PC（Windows）のセットアップを再現するための個人 dotfiles リポジトリ。
VSCode 設定・Vim ドリル・案件クローン用 PowerShell 関数をまとめて管理。

## クイックスタート

### 会社PCで使う場合
```
git clone https://github.com/komekomeclub5/work-setup.git C:\work\dotfiles
cd C:\work\dotfiles
scripts\apply-vscode.bat
powershell -ExecutionPolicy Bypass -File scripts\install-gc.ps1
```

- `apply-vscode.bat`：VSCode の `settings.json` `keybindings.json` を反映（既存設定は `.bak` でバックアップ）
- `install-gc.ps1`：PowerShell プロファイルに `gc` 関数を登録

新しい PowerShell を開けば `gc <repo-url>` で使えます。

## `gc` コマンド

案件用フォルダを作って clone する PowerShell 関数。

```
gc https://github.com/example/site-xxx.git
```

実行すると以下が自動で作られます：
```
C:\work\<repo名>\
├── downloads\   ← 受領素材の置き場
├── work\        ← 加工中
├── output\      ← 完成品
└── repo\        ← clone 先（ここで作業）
```

- clone 後に念のため `git pull` も実行
- 既にフォルダがあれば pull のみ
- 完了後 Explorer で開く

## ディレクトリ構成

| パス | 内容 |
|------|------|
| `vscode/settings.json` | VSCode 本体設定（Vim拡張のIME対応・改行コード対策含む） |
| `vscode/keybindings.json` | キーバインド（無変換キー→Vim Esc） |
| `vim/drill.md` | Vim 練習ドリル（毎朝5〜10分用） |
| `git/.gitconfig` | Git 設定（autocrlf=false 等） |
| `scripts/apply-vscode.bat` | VSCode 設定反映スクリプト |
| `scripts/gc.ps1` | 案件クローン用 PowerShell 関数 |
| `scripts/install-gc.ps1` | gc を PowerShell プロファイルに登録 |

## 設計方針

- **ソフト追加なしで動く設定だけ**（会社PCの制約）
- **コピペ不要**：clone → bat / ps1 実行で反映完了
- **JIS配列 + Windows + 日本語IME** 前提
- VSCode Vim 拡張の IME 罠は「日本語キー→Vimコマンド」のマッピングで対応
