$key = 'ahghdishcbgrnhffoolrpjlkgcorqgbkadjkdkrbbkgcnldqraotjshedjnonnpbitcfia'
Write-Output ("Length      : " + $key.Length)
Write-Output ("Is24Hex     : " + ($key -match '^[a-fA-F0-9]{24}$'))
Write-Output ("IsUuid      : " + ($key -match '^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$'))
Write-Output ("IsAllHex    : " + ($key -match '^[a-fA-F0-9]+$'))
