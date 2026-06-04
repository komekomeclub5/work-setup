# gc: git clone helper
# Usage: gc <repo-url>
# - C:\work\<repo-name>\ にフォルダを作って clone
# - 案件作業に使う downloads / work / output サブフォルダも自動作成
# - clone 後に pull で念のため最新化（既にフォルダがあれば pull だけ実行）
# - 完了後に Explorer で開く

# PowerShell の組み込みエイリアス gc (Get-Content) を解除してから定義
Remove-Item Alias:gc -Force -ErrorAction SilentlyContinue

function gc {
    param(
        [Parameter(Mandatory=$true)]
        [string]$url
    )

    $repoName = ($url -replace '.*/','') -replace '\.git$',''
    $base = "C:\work\$repoName"
    $repo = "$base\repo"

    New-Item -ItemType Directory -Force -Path "$base\downloads","$base\work","$base\output" | Out-Null

    if (Test-Path $repo) {
        Write-Host "Repository already exists. Pulling latest..." -ForegroundColor Yellow
        Push-Location $repo
        git pull
        Pop-Location
    } else {
        Write-Host "Cloning $url ..." -ForegroundColor Cyan
        git clone $url $repo
        if ($LASTEXITCODE -ne 0) {
            Write-Host "git clone failed." -ForegroundColor Red
            return
        }
        Push-Location $repo
        git pull
        Pop-Location
    }

    explorer $base
}
