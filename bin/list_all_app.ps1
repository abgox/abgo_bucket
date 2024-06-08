. $PSScriptRoot\utils.ps1

$parentPath = Split-Path -Path $PSScriptRoot -Parent
$folderPath = $parentPath + "\bucket"

$result = @()
$max_len = 0
$files = Get-ChildItem -Path $folderPath -Filter "*.json" -File
foreach ($_ in $files) {
    $app_name = $_.Name -replace '\.[^.]+$'
    $len = $app_name.Length
    if ($len -gt $max_len) {
        $max_len = $len
    }
}
foreach ($_ in $files) {
    $app_name = $_.Name -replace '\.[^.]+$'
    $version = (Get-Content -Path $_.FullName -Raw | ConvertFrom-Json).version
    $result += "{0,-$($max_len + 3)} {1}" -f $app_name, $version
}

show_with_less ($result | Where-Object { $_ -ne '' }) {
    Write-Host ' '
    Write-Host ("{0,-$($max_len + 3)} {1}" -f 'App', 'Version') -f Cyan
    Write-Host ' '
}
