# Windows キーマップ設定（PowerToys）

Mac の Emacs 風キーバインドを Windows でも使うための設定。
追加ソフトは **PowerToys（Microsoft公式）のみ**。会社IT申請が通りやすい構成。

## ゴール

- 左手（CapsLock 位置）= Emacs 風移動の指癖
- 右手（右Ctrl）= Windows 標準ショートカット（検索・全選択・印刷など）
- 両立させて「失うショートカットゼロ」を実現

## 前提

- PowerToys インストール済み（Microsoft Store または GitHub Releases）
- Keyboard Manager モジュールが有効

## 設定内容

### 1. キーの再マップ

| Select | Mapped To | 目的 |
|--------|-----------|------|
| `Caps Lock` | `Left Ctrl` | Mac の `control` 位置を再現 |

PowerToys → Keyboard Manager → 「キーを再マップする」から登録。

### 2. ショートカットの再マップ（左Ctrl 限定）

| Shortcut | Mapped To | Emacs 由来 |
|----------|-----------|-----------|
| `LCtrl + F` | `→` | forward-char |
| `LCtrl + B` | `←` | backward-char |
| `LCtrl + P` | `↑` | previous-line |
| `LCtrl + N` | `↓` | next-line |

PowerToys → Keyboard Manager → 「ショートカットを再マップする」から登録。

**重要**：Shortcut 欄の Ctrl は `Left Ctrl` を選択する（`Ctrl`（どちらでも）ではない）。
これにより**右Ctrl 側では標準動作が温存**される。

## 動作結果

| 押し方 | 動作 |
|--------|------|
| `Caps + F` | → 移動（Emacs） |
| `Caps + B` | ← 移動（Emacs） |
| `Caps + P` | ↑ 移動（Emacs） |
| `Caps + N` | ↓ 移動（Emacs） |
| `Caps + A` | 全選択（再マップしていないので標準動作） |
| `右Ctrl + F` | 検索（標準維持） |
| `右Ctrl + A` | 全選択（標準維持） |
| `右Ctrl + P` | 印刷（標準維持） |
| `右Ctrl + N` | 新規（標準維持） |

## 設計理由

- **左Ctrl のみ remap** することで、右Ctrl 側に Windows 標準ショートカットを温存
- Mac で `control+f` がカーソル移動、`command+f` が検索という棲み分けに近い感覚
- `Ctrl+K`（kill-line）は PowerToys では再現不可（2段操作のため）。必要なら VSCode 内は Emacs 拡張、その他は `Shift+End → Delete` で代用

## 設定ファイルのバックアップ

PowerToys の設定は以下に保存される：

```
%LOCALAPPDATA%\Microsoft\PowerToys\Keyboard Manager\default.json
```

再セットアップ時はこのファイルをコピーすれば設定を流用できる。

## VSCode との関係

- VSCode 内は Vim 拡張で運用継続
- VSCode 外（エクスプローラー・ブラウザ・メーラー）のテキスト入力箇所で本設定が効く
- Vim Esc 代替は `Ctrl+[`（= `Caps+[`）で打てるようになる
