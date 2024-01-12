if (!(Test-Path("$env:AppData\abgo_bucket_Snipaste2.txt"))) {
    return
}

$content = Get-Content "$env:AppData\abgo_bucket_Snipaste2.txt"

$path_data = $content[0]
$path_persist = $content[1]

$content_data = Get-Content $path_data -Raw

if (Test-Path($content_persist)) {
    $content_persist = Get-Content $path_persist -Raw
}
else {
    $content_persist = $null
}

if ($content_data -ne $content_persist) {
    & "$PSScriptRoot\..\bin\sudo.ps1" Copy-Item $path_data $path_persist -Force
}
