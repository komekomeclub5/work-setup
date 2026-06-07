@echo off
REM VSCode 設定を反映するスクリプト
REM このリポジトリのルートで実行してください

setlocal
set TARGET=%APPDATA%\Code\User

if not exist "%TARGET%" (
  echo VSCode の設定フォルダが見つかりません: %TARGET%
  echo VSCode を一度起動してから再実行してください。
  pause
  exit /b 1
)

REM 既存ファイルをバックアップ
if exist "%TARGET%\settings.json" (
  copy /Y "%TARGET%\settings.json" "%TARGET%\settings.json.bak"
  echo Backed up: settings.json.bak
)
if exist "%TARGET%\keybindings.json" (
  copy /Y "%TARGET%\keybindings.json" "%TARGET%\keybindings.json.bak"
  echo Backed up: keybindings.json.bak
)

REM スニペット用フォルダ準備とバックアップ
if not exist "%TARGET%\snippets" mkdir "%TARGET%\snippets"
if exist "%TARGET%\snippets\markdown.json" (
  copy /Y "%TARGET%\snippets\markdown.json" "%TARGET%\snippets\markdown.json.bak"
  echo Backed up: snippets\markdown.json.bak
)

REM 反映
copy /Y "vscode\settings.json" "%TARGET%\settings.json"
copy /Y "vscode\keybindings.json" "%TARGET%\keybindings.json"
copy /Y "vscode\snippets\markdown.json" "%TARGET%\snippets\markdown.json"

echo.
echo Done. VSCode を再起動してください。
pause
