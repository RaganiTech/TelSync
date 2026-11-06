$root = Join-Path $env:USERPROFILE '.gradle\caches\modules-2\files-2.1'
Get-ChildItem -Path $root -Recurse -Filter '*.aar' -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match 'tapsell' } |
    ForEach-Object { Write-Output $_.FullName }
