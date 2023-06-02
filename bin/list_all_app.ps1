$parentPath = Split-Path -Path $PSScriptRoot -Parent
$folderPath = $parentPath + "\bucket"

Get-ChildItem -Path $folderPath -Filter "*.json" -File | ForEach-Object {
    $fileName = $_.Name
    $fileNameWithoutExtension = $fileName -replace '\.[^.]+$'
    $filePath = $_.FullName

    # read JSON
    $jsonContent = Get-Content -Path $filePath -Raw | ConvertFrom-Json

    # get version
    $version = $jsonContent.version

    $output = "{0,-20} {1}" -f $fileNameWithoutExtension,$version

    # output
    Write-Host $output
}
