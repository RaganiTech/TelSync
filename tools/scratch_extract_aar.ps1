$ErrorActionPreference = 'Stop'
$aar = 'C:\Users\AyzaPc\.gradle\caches\modules-2\files-2.1\ir.tapsell\core\1.3.0\1f65c5fe079f6e01498975c14d02cc634686ac0a\core-1.3.0.aar'
$work = Join-Path $PSScriptRoot '..\build\scratch_tapsell_core'
$work = [System.IO.Path]::GetFullPath($work)
if (Test-Path $work) { Remove-Item $work -Recurse -Force }
New-Item -ItemType Directory -Path $work | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($aar, $work)
Write-Output "Extracted to $work"
Get-ChildItem -Path $work | ForEach-Object { Write-Output $_.Name }
