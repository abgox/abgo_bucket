param([string]$app_name)
. $PSScriptRoot\utils.ps1

$app = @()
if ($app_name -match ".*[\\/].*") {
    foreach ($_ in $app_name -split "[\\/]") {
        $app += $_
    }
}
else {
    $app = @($null, $app_name)
}

$json = Get-Content -Path "$PSScriptRoot\lang\$lang.json" -Raw -Encoding UTF8 | ConvertFrom-Json

$scoop_dir = (Split-Path (Split-Path (Split-Path  (scoop prefix scoop) -Parent)))
$buckets_dir = Join-Path $scoop_dir 'buckets'
$app_dir = Join-Path $scoop_dir 'apps'
$cache_dir = Join-Path $scoop_dir 'cache'

$bucket_list = @()
if ($app[0]) {
    $bucket_list += $app[0]
}
else {
    $abgo_bucket = "abgo_bucket"
    foreach ($_ in scoop bucket list) {
        if ($_.Source -match '(gitee|github).com/abgox/abgo_bucket') {
            $abgo_bucket = $_.Name
        }
        $bucket_list += $_.Name
    }
    $bucket_list = [array]$abgo_bucket + $bucket_list | Sort-Object -Unique
}
$app_list = @()
$usable_bucket = @()
foreach ($bucket in $bucket_list) {
    foreach ($_ in Get-ChildItem "$($buckets_dir)/$($bucket)/bucket") {
        if ($_.BaseName -eq $app[1]) {
            $app_list += $_.FullName
            $usable_bucket += $bucket
        }
    }
}
if (!$app_list) {
    write_with_color (data_replace $json.download.no_found_app)
    return
}
try { $installed_version = ((scoop info $app[1]).Installed -split "`n")[-1] }catch { $installed_version = $null }

$content_manifest = Get-Content $app_list[0] -Raw | ConvertFrom-Json

$info = @{}
if ($installed_version) {
    if ($content_manifest.version -eq $installed_version) {
        write_with_color (data_replace $json.download.exist)
        return
    }
    else {
        $is_update = $true
    }
}
else {
    $is_update = Get-ChildItem $app_dir | Where-Object { $_.Name -eq $app[1] }
}

function get_arch {
    $system = if (${env:ProgramFiles(Arm)}) { 'arm64' }
    elseif ([System.Environment]::Is64BitOperatingSystem) { '64bit' }
    else { '32bit' }
    return $system
}
$arch = get_arch


if ($content_manifest.url) {
    $info.url = $content_manifest.url
}
else {
    $info.url = $content_manifest.architecture.$arch.url
}

function ensure_cache($url) {
    $replace_url = $url -replace "(/?%/?)|(#/?)|(:?//?)|(\?)|(=)", '_'
    $out = "$($app[1])#$($content_manifest.version)#$($replace_url)"
    $has_cache = Get-ChildItem $cache_dir | Where-Object { $_.Name -in $out }
    if (!$has_cache) {
        write_with_color (data_replace $json.download.url)
        Write-Host "---------------" -f Cyan
        Write-Host (data_replace "$($json.download.download)") -f Yellow -NoNewline
        $dl_path = $(Read-Host) -replace '"', ''
        while (!(Test-Path $dl_path)) {
            Write-Host (data_replace $json.download.no_found) -f Yellow -NoNewline
            $dl_path = $(Read-Host) -replace '"', ''
        }
        Write-Host ''
        Move-Item $dl_path (Join-Path $cache_dir $out) -Force
    }
}

foreach ($_ in $info.url) { ensure_cache $_ }

if ($is_update) {
    scoop update "$($usable_bucket[0])/$($app[1])"
}
else {
    scoop install "$($usable_bucket[0])/$($app[1])" --no-update-scoop
}
