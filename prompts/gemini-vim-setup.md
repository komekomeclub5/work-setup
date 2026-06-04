# Gemini プロンプト：VSCode Vim 拡張の IME 対応設定生成

会社Geminiにこのプロンプトを投げると、VSCode Vim 拡張用の IME 対応設定を生成してくれる。

## プロンプト

```
あなたはVSCode Vim拡張の設定に詳しいエンジニアです。
以下の制約と要件で、VSCodeのsettings.jsonに追加するJSON設定を出力してください。

## 制約
- 外部ソフトウェアのインストールは不可（im-select.exe等は使えない）
- 純粋にVSCode + Vim拡張の設定のみで完結すること
- 環境：Windows + JIS配列キーボード + Google日本語入力（またはMS-IME）

## 要件
Vim拡張使用中、日本語入力（IME）がONのままでも主要なVimコマンドが動作するように、
ひらがな・全角記号をVimコマンドにマッピングしてください。

具体的には：
1. ノーマルモードで以下のひらがな入力をVimコマンドに変換：
   - あ → a（append）
   - い → i（insert）
   - う → u（undo）
   - お → o（open new line below）
   - 必要なら他のよく使うコマンドも追加
2. 全角記号 ／ → /（検索）も対応
3. Insertモード脱出を jj と っj（IME ON時に jj が促音化したパターン）の両方で実現
4. Ctrl+v（矩形選択）とCtrl+a（連番）をVim側で処理（handleKeys）
5. システムクリップボード連携を有効化
6. 検索ハイライト有効化

## 出力形式
- settings.json に追加するJSON部分のみ
- 各設定にコメントで何のための設定か日本語で説明
- マッピング方式の限界（変換待ち状態では効かない等）も最後に補足

参考: https://qiita.com/ssh0/items/9e7f0d8b8f033183dd0b の手法
```

## 使い方
1. Geminiに上記をコピペ
2. 出力されたJSONを目視確認
3. 動かないマッピングがあれば追加プロンプトで調整
4. 良ければ vscode/settings.json に反映

## Gem化のすすめ
よく使うなら Gemini Gem として保存：
- Gem名：「VSCode Vim 設定アシスタント」
- 上記プロンプトを system instruction として登録
- 入力欄に「追加でこのキーをマッピングしたい」等で対話的に拡張
