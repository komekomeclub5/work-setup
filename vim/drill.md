# Vim 練習ドリル（VSCode Vim拡張）

毎朝5〜10分。上から順に。1日1〜2操作を体に入れる。

## 練習用テキスト
```
りんご
バナナ
オレンジ
ぶどう
メロン

1
1
1
1
1

apple banana cherry
apple banana cherry
apple banana cherry

東京 大阪 名古屋 福岡 札幌

The quick brown fox jumps over the lazy dog.
The slow red turtle walks under the busy cat.
```

## Phase A：移動（最初の3日）
- `hjkl`：左下上右
- `w` `b`：単語単位で進む/戻る
- `0` `$`：行頭/行末
- `gg` `G`：ファイル先頭/末尾
- `5G`：5行目にジャンプ

ゴール：マウスと矢印キーを使わず任意位置へ移動

## Phase B：編集
- `i` `a` `o`：挿入位置の使い分け（前/後ろ/下に新規行）
- `x`：1文字削除
- `dd` `yy` `p`：行削除/コピー/貼り付け
- `u` `Ctrl+r`：undo / redo

ゴール：i/a/o と dd/yy/p/u が無意識で出る

## Phase C：検索置換
- `/word` → Enter → `n`（次）`N`（前）
- `:%s/old/new/g`：全置換
- `:%s/old/new/gc`：1件ずつ確認しながら置換（**実務で必ずこれ**）

## Phase D：矩形・連番（最重要・実務頻出）

### 矩形：先頭挿入（I）
1. 「1」5行縦並びの先頭文字に `Ctrl+v`
2. `j` を4回押して5行選択
3. `I`（大文字）押す
4. 「No.」入力
5. `Esc` → 全行に「No.」が追加される

### 矩形：行末追加（A）
1. 「apple banana cherry」3行の `a` に移動
2. `Ctrl+v` → `jj` で3行選択 → `$` で各行末まで
3. `A` → 「!」入力 → `Esc`

### 矩形：削除（d）
1. 範囲を `Ctrl+v` で選択
2. `d` で削除

### 連番化（g Ctrl+a）
1. 「1」を5行縦に並べる
2. 先頭の「1」に移動
3. `Ctrl+v` → `j` 4回で5行選択
4. `g Ctrl+a`
5. 結果：1 2 3 4 5

## 注意：handleKeys設定が必須
`Ctrl+v` `Ctrl+a` が動かない場合は settings.json の `vim.handleKeys` を確認。

## 練習サイト
- vim-adventures.com（ゲーム形式）
- openvim.com（チュートリアル）
