try {
    $content = Pot_abgo_bucket_schedule_persist
}
catch {
    return
}

$path_data = $content[0]
if (!(Test-Path $path_data)) { return }

$data_folder = Get-ChildItem $path_data -Recurse | ForEach-Object { $_.BaseName }

$path_persist = $content[1]

if (Test-Path($path_persist)) {
    $persist_folder = Get-ChildItem $path_persist -Recurse | ForEach-Object { $_.BaseName }
}
else {
    $persist_folder = @()
}

if (Compare-Object $data_folder $persist_folder -PassThru) {
    & "$PSScriptRoot\..\bin\sudo.ps1" Remove-Item $path_persist -Force -Recurse
    & "$PSScriptRoot\..\bin\sudo.ps1" Copy-Item $path_data (Split-Path $path_persist -Parent) -Force -Recurse
}
