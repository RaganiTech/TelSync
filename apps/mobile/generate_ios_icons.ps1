Add-Type -AssemblyName System.Drawing

$src = 'c:\Users\AyzaPc\Desktop\tel\apps\mobile\assets\images\logo.png'
$img = [System.Drawing.Image]::FromFile($src)
$appIconDir = 'c:\Users\AyzaPc\Desktop\tel\apps\mobile\ios\Runner\Assets.xcassets\AppIcon.appiconset'

# Parse Contents.json to get all required icon entries
$json = Get-Content $appIconDir\Contents.json -Raw | ConvertFrom-Json

foreach ($entry in $json.images) {
    $sizePart = $entry.size -split 'x'
    $baseSize = [double]$sizePart[0]
    $scale = [double]($entry.scale -replace 'x', '')
    $pixelSize = [int]($baseSize * $scale)

    $bmp = New-Object System.Drawing.Bitmap($pixelSize, $pixelSize)
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $gfx.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gfx.DrawImage($img, 0, 0, $pixelSize, $pixelSize)
    $gfx.Dispose()

    $outFile = Join-Path $appIconDir $entry.filename
    $bmp.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()

    Write-Host ("Generated {0} ({1}x{1})" -f $outFile, $pixelSize)
}

$img.Dispose()
Write-Host "All iOS app icons generated successfully."
