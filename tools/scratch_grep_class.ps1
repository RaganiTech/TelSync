$ErrorActionPreference = 'Stop'
$cls = 'C:\Users\AyzaPc\Desktop\tel\build\scratch_med\cls'
$needle = 'Invalid mediation app key'
$enc = [System.Text.Encoding]::GetEncoding(28591)
$files = Get-ChildItem -Path $cls -Recurse -Filter '*.class'
foreach ($f in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $text = $enc.GetString($bytes)
    if ($text.Contains($needle)) {
        Write-Output $f.FullName
    }
}
