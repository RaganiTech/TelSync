$ErrorActionPreference = 'Stop'
$cls = 'C:\Users\AyzaPc\Desktop\tel\build\scratch_med\cls'
$out = 'C:\Users\AyzaPc\Desktop\tel\build\scratch_mediator.javap.txt'
& javap -p -c -classpath $cls 'ir.tapsell.mediation.MediatorInitializer' 2>&1 | Out-File -FilePath $out -Encoding utf8
Write-Output "written: $out"
Write-Output ((Get-Content $out).Count)
