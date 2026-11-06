$ErrorActionPreference = 'Stop'
$cls = 'C:\Users\AyzaPc\Desktop\tel\build\scratch_med\cls'
& javap -p -c -classpath $cls 'ir.tapsell.mediation.MediatorInitializer' 2>&1 | Out-String -Width 500
