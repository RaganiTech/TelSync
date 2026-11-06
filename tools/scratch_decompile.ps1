$ErrorActionPreference = 'Stop'
$jar = 'C:\Users\AyzaPc\Desktop\tel\build\scratch_tapsell_core\classes.jar'
$work = 'C:\Users\AyzaPc\Desktop\tel\build\scratch_tapsell_classes'
if (Test-Path $work) { Remove-Item $work -Recurse -Force }
New-Item -ItemType Directory -Path $work | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($jar, $work)

$target = Join-Path $work 'ir\tapsell\mediation\MediatorInitializer.class'
Write-Output "Exists: $(Test-Path $target)"
Write-Output "--- javap output ---"
& javap -p -c $target 2>&1 | Out-String -Width 400
