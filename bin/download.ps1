param(
    [string]$app_name
    )
$path = (scoop info $app_name -v).Manifest
$info = Get-Content $path | ConvertFrom-Json

if ($info.url) {
    $result = $info.url
} elseif ($info.architecture) {
    $a = $info.architecture
    if ($a.'64bit') {
        $result = $a.'64bit'.url
    } elseif ($a.'32bit') {
        $result = $a.'32bit'.url
    } else {
        throw "There is no suitable download path"
    }
} else {
    throw "There is no suitable download path"
}
$file_name = $result -replace '://', '_'
$file_name = $file_name -replace '/', '_'
$file_name = "$app_name#$($info.version)#$file_name"
Write-Host "下载路径：$result" -f Green
Write-Host "---------------" -f Cyan
Write-Host "请点击下载路径进行手动下载`n将下载好的文件路径填写到此处(无引号)：" -f Yellow -NoNewline
$download_path = Read-Host

$cache_dir = (Split-Path (Split-Path (Split-Path  (scoop prefix scoop) -Parent) -Parent) -Parent) + '\cache'

Move-Item $download_path "$cache_dir\$file_name"
