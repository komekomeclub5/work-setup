# _worksheets/ — 案件作業シート置き場

案件1件 = 1ファイル。ファイル名は `YYYY-MM-DD_案件番号.md`。

## クイックリファレンス

### 副操縦士起動（毎回これだけ）
1. `_co.md` をクリック
2. `co` → Tab で展開
3. `Ctrl+A` → `Ctrl+C`
4. Gemini Code Assist チャットに `Ctrl+V` → Enter
5. `_co.md` を `Ctrl+Z` で空に戻す

### モード選択（Gemini が「1文字で」と聞いてくる）

| 文字 | モード | 事前に必要 |
|------|--------|-----------|
| `a` | 新規案件 | `gc <url>` または `git pull` で repo 最新化 |
| `b` | 過去案件参照 | なし |
| `c` | 提出前チェック | `gdiff` |
| `d` | 差し戻し対応 | `gdiff` |
| `e` | 週次振り返り（金曜終業前） | なし |

### ターミナル便利コマンド

```
gc <repo-url>   案件 clone + assets フォルダ作成 + VSCode 起動
git pull        既存案件の更新
gdiff           現在の diff を _tmp/<repo>.diff に書き出す
gdiffclean      _tmp/ の diff ファイルを掃除
gcrm <repo>     案件フォルダ削除
```

## フォルダ構成

```
_worksheets/
  ├── README.md             ← このファイル
  ├── _co.md                ← スクラッチ（snippet 方式の時用・常駐・空のまま）
  ├── _lessons.md           ← 差し戻し原因・再発防止策の蓄積
  ├── _rules.md             ← 社内ルール変更ログ
  ├── _tmp/                 ← gdiff 出力先
  └── YYYY-MM-DD_案件番号.md ← 案件シート
```

`_lessons.md` `_rules.md` は副操縦士（Agent モード）が自動で参照・追記候補を提示する。
手動で追記してもよい。

## 困った時

- スニペットが Tab で展開されない → `Ctrl+Shift+P` → `Insert Snippet` → `Copilot Entry`
- Gemini が複数質問してくる → スニペットの「1問ずつ」指示を強調して再投入
- diff が大きすぎて Gemini が読まない → 該当ファイルだけに絞って `git diff <file>` で出し直す

## 育て方

差し戻しが来たら `co d` で「次回 Phase 6 に追記すべきチェック項目」が返ってくる。
これを work-setup の `vscode/snippets/markdown.json` の `casews` Phase 6 に追記して `apply-vscode.bat` 再実行 → スニペットが育つ。
