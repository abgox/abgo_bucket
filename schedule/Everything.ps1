try {
    $content = Everything_abgo_bucket_schedule_persist
}
catch {
    return
}

$path_data = $content[0]

if (!(Test-Path $path_data)) { return }

$path_persist = $content[1]

$content_data = Get-Content $path_data -Raw

if (Test-Path($path_persist)) {
    $content_persist = Get-Content $path_persist -Raw
}
else {
    $content_persist = $null
}

if ($content_data -ne $content_persist) {
    Copy-Item $path_data $path_persist -Force
}
