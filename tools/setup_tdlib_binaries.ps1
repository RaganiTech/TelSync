# Helper script to prepare TDLib native directories for Android build
param(
    [string]$SourceFolder = ""
)

$targetDir = "apps/mobile/android/app/src/main/jniLibs"
$archs = @("arm64-v8a", "armeabi-v7a", "x86_64")

foreach ($arch in $archs) {
    $archDir = Join-Path $targetDir $arch
    if (!(Test-Path $archDir)) {
        New-Item -ItemType Directory -Path $archDir -Force | Out-Null
        Write-Host "Created $archDir"
    }

    if ($SourceFolder -and (Test-Path (Join-Path $SourceFolder "$arch/libtdjson.so"))) {
        Copy-Item (Join-Path $SourceFolder "$arch/libtdjson.so") (Join-Path $archDir "libtdjson.so") -Force
        Write-Host "Copied libtdjson.so to $archDir"
    }
}

Write-Host "TDLib JNI directory setup completed."
