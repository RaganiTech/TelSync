$ErrorActionPreference = 'Stop'
$aar = 'C:\Users\AyzaPc\.gradle\caches\modules-2\files-2.1\ir.tapsell.mediation\tapsell-flutter\1.3.0\7f8892b19f0257967e14eca97cc2ee22ebe8ae99\tapsell-flutter-1.3.0.aar'
$work = 'C:\Users\AyzaPc\Desktop\tel\build\scratch_med'
if (Test-Path $work) { Remove-Item $work -Recurse -Force }
New-Item -ItemType Directory -Path $work | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($aar, $work)

$jar = Join-Path $work 'classes.jar'
$cls = Join-Path $work 'cls'
New-Item -ItemType Directory -Path $cls | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($jar, $cls)

Write-Output '--- classes matching Initializer / Mediator ---'
Get-ChildItem -Path $cls -Recurse -Filter '*.class' |
    Where-Object { $_.Name -match 'Initializer|Mediator' } |
    ForEach-Object { Write-Output $_.FullName }
