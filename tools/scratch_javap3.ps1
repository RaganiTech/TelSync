$ErrorActionPreference = 'Stop'
$cls = 'C:\Users\AyzaPc\Desktop\tel\build\scratch_med\cls'
$out = 'C:\Users\AyzaPc\Desktop\tel\build\scratch_appmanifest.javap.txt'
& javap -p -c -classpath $cls 'ir.tapsell.mediation.tpsla' 2>&1 | Out-File -FilePath $out -Encoding utf8
& javap -p -c -classpath $cls 'ir.tapsell.mediation.utils.tpsla' 2>&1 | Out-File -FilePath $out -Encoding utf8 -Append
& javap -p -c -classpath $cls 'ir.tapsell.mediation.tpslb' 2>&1 | Out-File -FilePath $out -Encoding utf8 -Append
Write-Output "written: $out"
