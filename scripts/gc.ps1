# gc / gcrm / gcclean: 案件用 git clone & 削除ヘルパー
#
# 前提：実行する前に C:\web\直案 or C:\web\パートナー など、
#       案件用親ディレクトリに cd しておく。
#
# gc <repo-url>
#   - カレントディレクトリに <repo名>\ を clone
#   - 兄弟ディレクトリ <repo名>_assets\ を作成（受領素材置き場）
#   - clone 後に git pull で念のため最新化
#   - VSCode で <repo名>\ を開く（code コマンド使用）
#
# gcrm <repo名>
#   - 個別削除：<repo名>\ と <repo名>_assets\ を削除
#   - 確認プロンプトあり
#
# gcclean
#   - 一括削除：カレントディレクトリ配下のすべての <repo>\ と <repo>_assets\ を削除
#   - 強い確認プロンプト（フォルダ一覧表示＋"yes" タイプ）
#   - 直案/パートナーディレクトリ自体は消さない
#
# gdiff
#   - 案件 repo 内で実行：git diff を C:\web\_worksheets\_tmp\<repo>.diff に出力
#   - Gemini Code Assist の casediff / casecheck / casecause で参照する
#
# gdiffclean
#   - _worksheets\_tmp\ 配下の diff ファイルをまとめて削除


# PowerShell の組み込みエイリアスを解除（gc = Get-Content と衝突）
Remove-Item Alias:gc -Force -ErrorAction SilentlyContinue


function gc {
    param(
        [Parameter(Mandatory=$true)]
        [string]$url
    )

    $repoName = ($url -replace '.*/','') -replace '\.git$',''
    $assetsName = "${repoName}_assets"

    if (Test-Path $repoName) {
        Write-Host "Repository already exists. Pulling latest..." -ForegroundColor Yellow
        Push-Location $repoName
        git pull
        Pop-Location
    } else {
        Write-Host "Cloning $url ..." -ForegroundColor Cyan
        git clone $url $repoName
        if ($LASTEXITCODE -ne 0) {
            Write-Host "git clone failed." -ForegroundColor Red
            return
        }
        Push-Location $repoName
        git pull
        Pop-Location
    }

    # 素材フォルダを作成
    New-Item -ItemType Directory -Force -Path $assetsName | Out-Null
    Write-Host "Assets folder ready: $assetsName" -ForegroundColor Green

    # VSCode で repo を開く
    if (Get-Command code -ErrorAction SilentlyContinue) {
        code $repoName
    } else {
        Write-Host "'code' コマンドが見つかりません。VSCode は手動で開いてください。" -ForegroundColor Yellow
    }

    # Explorer で素材フォルダを開く
    explorer $assetsName
}


function gcrm {
    param(
        [Parameter(Mandatory=$true)]
        [string]$repoName
    )

    $assetsName = "${repoName}_assets"
    $targets = @()
    if (Test-Path $repoName)   { $targets += $repoName }
    if (Test-Path $assetsName) { $targets += $assetsName }

    if ($targets.Count -eq 0) {
        Write-Host "削除対象が見つかりません: $repoName" -ForegroundColor Yellow
        return
    }

    Write-Host "以下を削除します:" -ForegroundColor Cyan
    $targets | ForEach-Object { Write-Host "  - $_" }
    $ans = Read-Host "削除しますか？ (y/n)"
    if ($ans -ne 'y') {
        Write-Host "中止しました。" -ForegroundColor Yellow
        return
    }

    foreach ($t in $targets) {
        Remove-Item -Recurse -Force $t
        Write-Host "Deleted: $t" -ForegroundColor Green
    }
}


function gdiff {
    # 案件 repo 内で実行する想定。
    # 現在の git diff を C:\web\_worksheets\_tmp\<repo>.diff に書き出す。
    # Gemini Code Assist の casediff / casecheck / casecause スニペットで参照する用。

    if (-not (Test-Path .git)) {
        Write-Host "ここは git repo ではありません。案件 repo 内で実行してください。" -ForegroundColor Red
        return
    }

    $repo = Split-Path -Leaf (Get-Location)
    $outDir = "C:\web\_worksheets\_tmp"
    $out = Join-Path $outDir "$repo.diff"

    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
    git diff > $out
    if ($LASTEXITCODE -ne 0) {
        Write-Host "git diff failed." -ForegroundColor Red
        return
    }

    $size = (Get-Item $out).Length
    Write-Host "Wrote: $out ($size bytes)" -ForegroundColor Green
    Write-Host "Snippet 側で @_tmp/$repo.diff として参照してください。" -ForegroundColor Cyan
}


function gdiffclean {
    # _worksheets/_tmp/ 配下を削除（diff ファイルが溜まったら手動掃除）

    $tmpDir = "C:\web\_worksheets\_tmp"
    if (-not (Test-Path $tmpDir)) {
        Write-Host "削除対象がありません: $tmpDir" -ForegroundColor Yellow
        return
    }

    $files = Get-ChildItem $tmpDir -File
    if ($files.Count -eq 0) {
        Write-Host "削除対象がありません。" -ForegroundColor Yellow
        return
    }

    Write-Host "以下のファイルを削除します:" -ForegroundColor Cyan
    $files | ForEach-Object { Write-Host "  - $($_.Name)" }
    $ans = Read-Host "削除しますか？ (y/n)"
    if ($ans -ne 'y') {
        Write-Host "中止しました。" -ForegroundColor Yellow
        return
    }

    foreach ($f in $files) {
        Remove-Item -Force $f.FullName
        Write-Host "Deleted: $($f.Name)" -ForegroundColor Green
    }
}


function gcclean {
    # カレントディレクトリ配下の repo フォルダと _assets フォルダを一覧
    $dirs = Get-ChildItem -Directory
    if ($dirs.Count -eq 0) {
        Write-Host "削除対象がありません。" -ForegroundColor Yellow
        return
    }

    Write-Host "以下のディレクトリをすべて削除します:" -ForegroundColor Cyan
    Write-Host "  場所: $(Get-Location)" -ForegroundColor Cyan
    $dirs | ForEach-Object { Write-Host "  - $($_.Name)" }
    Write-Host ""
    Write-Host "本当に削除する場合は 'yes' とタイプしてください（それ以外はキャンセル）:" -ForegroundColor Red
    $ans = Read-Host

    if ($ans -ne 'yes') {
        Write-Host "中止しました。" -ForegroundColor Yellow
        return
    }

    foreach ($d in $dirs) {
        Remove-Item -Recurse -Force $d.FullName
        Write-Host "Deleted: $($d.Name)" -ForegroundColor Green
    }
}
