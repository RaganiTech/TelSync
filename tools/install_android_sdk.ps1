$ErrorActionPreference = "Stop"

$androidHome = "$env:LOCALAPPDATA\Android\Sdk"
$tempZip = "$env:TEMP\cmdline-tools.zip"
$tempExtract = "$env:TEMP\cmdline-tools-extracted"
$url = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"

Write-Host ">>> 1. Creating Android SDK directory: $androidHome"
New-Item -ItemType Directory -Path "$androidHome\cmdline-tools" -Force | Out-Null

$env:HTTP_PROXY = "http://127.0.0.1:10809"
$env:HTTPS_PROXY = "http://127.0.0.1:10809"
$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.21.21-hotspot"

Write-Host ">>> 2. Downloading Command-Line Tools..."
curl.exe -L -o $tempZip $url

Write-Host ">>> 3. Extracting Command-Line Tools..."
if (Test-Path $tempExtract) { Remove-Item -Recurse -Force $tempExtract }
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

$latestDir = "$androidHome\cmdline-tools\latest"
if (Test-Path $latestDir) { Remove-Item -Recurse -Force $latestDir }
Move-Item -Path "$tempExtract\cmdline-tools" -Destination $latestDir -Force
Remove-Item $tempZip -Force

Write-Host ">>> 4. Configuring Flutter Android SDK path..."
$env:PATH = "C:\tools\flutter\bin;C:\Program Files\Microsoft\jdk-17.0.21.21-hotspot\bin;" + $env:PATH
flutter config --android-sdk $androidHome

Write-Host ">>> 5. Installing platform-tools, platforms;android-35, and build-tools;35.0.0..."
$sdkmanager = "$latestDir\bin\sdkmanager.bat"

# Accept licenses automatically
$yesInput = "y`ny`ny`ny`ny`ny`ny`ny`n"
$yesInput | & $sdkmanager --licenses --proxy=http --proxy_host=127.0.0.1 --proxy_port=10809

& $sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0" --proxy=http --proxy_host=127.0.0.1 --proxy_port=10809

# Update user PATH to include adb
$userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*platform-tools*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$userPath;$androidHome\platform-tools;$androidHome\cmdline-tools\latest\bin", "User")
    Write-Host "Added platform-tools and cmdline-tools to User PATH."
}

[System.Environment]::SetEnvironmentVariable("ANDROID_HOME", $androidHome, "User")
Write-Host ">>> Android SDK installation completed successfully!"
