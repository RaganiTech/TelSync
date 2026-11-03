$url = 'https://github.com/up9cloud/android-libtdjson/releases/download/v1.8.65/jniLibs.tar.gz'
$proxy = 'http://127.0.0.1:10809'
$dest = 'tools/jniLibs.tar.gz'
$targetDir = 'apps/mobile/android/app/src/main'

Write-Host "Downloading TDLib jniLibs from $url..."
Invoke-WebRequest -Uri $url -OutFile $dest -Proxy $proxy -UserAgent 'curl'

Write-Host "Extracting into $targetDir..."
tar -xzf $dest -C $targetDir

Write-Host "Verifying files in $targetDir/jniLibs..."
Get-ChildItem -Recurse "$targetDir/jniLibs" | Select-Object FullName, Length
