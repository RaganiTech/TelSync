$packages = @(
  'packages/core_domain',
  'packages/core_phone',
  'packages/match_engine',
  'packages/source_telegram',
  'packages/sink_phonebook',
  'packages/platform_security',
  'packages/design_system',
  'packages/l10n',
  'apps/mobile'
)

$allPassed = $true
foreach ($pkg in $packages) {
  Write-Host "=== Testing $pkg ===" -ForegroundColor Cyan
  Push-Location $pkg
  if (Test-Path "pubspec.yaml") {
    $content = Get-Content "pubspec.yaml" -Raw
    if ($content -match "sdk:\s*flutter") {
      flutter test
    } else {
      dart test
    }
    if ($LASTEXITCODE -ne 0) {
      $allPassed = $false
      Write-Host "FAILED in $pkg" -ForegroundColor Red
    }
  }
  Pop-Location
}

if ($allPassed) {
  Write-Host "ALL TESTS PASSED SUCCESSFULLY!" -ForegroundColor Green
  exit 0
} else {
  Write-Host "SOME TESTS FAILED!" -ForegroundColor Red
  exit 1
}
