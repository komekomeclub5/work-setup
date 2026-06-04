# work-setup

仕事用PC（Windows）のセットアップを再現するための個人 dotfiles リポジトリ。
VSCode 設定・チートシート・Vim ドリル・Gemini プロンプト等をまとめて管理。

## クイックスタート

### 会社PCで使う場合
```
git clone https://github.com/komekomeclub5/work-setup.git C:\work\dotfiles
cd C:\work\dotfiles
scripts\apply-vscode.bat
```
`apply-vscode.bat` は既存設定を `.bak` でバックアップしてから上書きします。

## ディレクトリ構成

| パス | 内容 |
|------|------|
| `vscode/settings.json` | VSCode 本体設定（Vim拡張のIME対応含む） |
| `vscode/keybindings.json` | キーバインド（無変換キー→Vim Esc 等） |
| `vim/drill.md` | Vim 練習ドリル（毎朝5〜10分用） |
| `cheatsheet/windows-shortcuts.md` | Windows ショートカット |
| `cheatsheet/vscode-shortcuts.md` | VSCode ショートカット |
| `cheatsheet/tortoisegit.md` | TortoiseGit 操作・Commit前チェック |
| `cheatsheet/vim.md` | Vim コマンド早見表 |
| `git/.gitconfig` | Git 設定（改行コード対策） |
| `prompts/gemini-vim-setup.md` | Gemini で設定を再生成するプロンプト |
| `scripts/apply-vscode.bat` | VSCode 設定反映スクリプト |

## 設計方針

- **ソフト追加なしで動く設定だけ**（会社PCの制約）
- **コピペが不要**：clone → bat実行で反映完了
- **JIS配列 + Windows + 日本語IME** 前提
- VSCode Vim 拡張の IME 罠は「日本語キー→Vimコマンド」のマッピングで対応

## 参考

- VSCode Vim IME 自動切換（im-select.exe 必要）: https://interferobserver.hatenadiary.com/entry/20260429/1777474648
- ソフト追加なしマッピング方式: https://qiita.com/ssh0/items/9e7f0d8b8f033183dd0b
