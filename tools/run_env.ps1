param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Command
)

$androidHome = [Environment]::GetEnvironmentVariable('ANDROID_HOME', 'User')
if (-not $androidHome) {
    $androidHome = "$env:LOCALAPPDATA\Android\Sdk"
}
$jdk = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
if (-not $jdk) {
    $jdk = "C:\Program Files\Microsoft\jdk-17.0.21.21-hotspot"
}

$userPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
$machinePath = [Environment]::GetEnvironmentVariable('PATH', 'Machine')

$env:ANDROID_HOME = $androidHome
$env:ANDROID_SDK_ROOT = $androidHome
$env:JAVA_HOME = $jdk
$env:PATH = "$androidHome\platform-tools;$androidHome\cmdline-tools\latest\bin;$jdk\bin;C:\tools\flutter\bin;$userPath;$machinePath"

$env:HTTP_PROXY = "http://127.0.0.1:10809"
$env:HTTPS_PROXY = "http://127.0.0.1:10809"
$env:NO_PROXY = "localhost,127.0.0.1,::1"
$env:no_proxy = "localhost,127.0.0.1,::1"
$env:JAVA_TOOL_OPTIONS = "-Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=10809 -Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=10809"
$env:GRADLE_OPTS = "-Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=10809 -Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=10809"

if ($Command.Count -gt 0) {
    $cmdStr = $Command -join " "
    Invoke-Expression $cmdStr
}
