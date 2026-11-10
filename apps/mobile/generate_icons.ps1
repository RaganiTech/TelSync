Add-Type -AssemblyName System.Drawing
$src = 'c:\Users\AyzaPc\Desktop\tel\apps\mobile\assets\images\logo.png'
$img = [System.Drawing.Image]::FromFile($src)
$densities = @{ 'mdpi'=48; 'hdpi'=72; 'xhdpi'=96; 'xxhdpi'=144; 'xxxhdpi'=192 }
foreach ($d in $densities.Keys) {
    $size = $densities[$d]
    foreach ($name in @('ic_launcher', 'ic_launcher_round')) {
        $bmp = New-Object System.Drawing.Bitmap($size, $size)
        $gfx = [System.Drawing.Graphics]::FromImage($bmp)
        $gfx.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $gfx.DrawImage($img, 0, 0, $size, $size)
        $gfx.Dispose()
        $outDir = 'c:\Users\AyzaPc\Desktop\tel\apps\mobile\android\app\src\main\res\mipmap-' + $d
        $outFile = Join-Path $outDir ($name + '.png')
        $bmp.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        Write-Host ("Generated {0} ({1}x{1})" -f $outFile, $size)
    }
}
$img.Dispose()
