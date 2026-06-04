# gc 関数を PowerShell プロファイルに登録するスクリプト
# 実行: PowerShell でこのスクリプトを実行すると、profile.ps1 に gc.ps1 の読み込みを追記

$profilePath = $PROFILE
$profileDir = Split-Path $profilePath -Parent

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
}
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Force -Path $profilePath | Out-Null
}

$gcScript = Join-Path $PSScriptRoot "gc.ps1"
$line = ". `"$gcScript`""

$existing = Get-Content $profilePath -ErrorAction SilentlyContinue
if ($existing -notcontains $line) {
    Add-Content -Path $profilePath -Value $line
    Write-Host "Registered gc in $profilePath" -ForegroundColor Green
} else {
    Write-Host "Already registered." -ForegroundColor Yellow
}

Write-Host "新しい PowerShell を開いて 'gc <repo-url>' で使えます。"
