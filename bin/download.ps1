param([string]$app_name)

function replace_content {
    param ($data, $separator = '')
    $data = ($data -join $separator)
    $pattern = '\{\{(.*?(\})*)(?=\}\})\}\}'
    $matches = [regex]::Matches($data, $pattern)
    foreach ($match in $matches) {
        $data = $data.Replace($match.Value, (Invoke-Expression $match.Groups[1].Value) -join $separator )
    }
    if ($data -match $pattern) { replace_content $data }else { return $data }
}

$lang = $PSUICulture
if ($lang -ne 'zh-CN') { $lang = 'en-US' }

$app = @()
if ($app_name -match ".*[\\/].*") {
    $app_name -split "[\\/]" | ForEach-Object {
        $app += $_
    }
}
else {
    $app = @($null, $app_name)
}

$json = Get-Content -Path "$PSScriptRoot\lang\$lang.json" -Raw -Encoding UTF8 | ConvertFrom-Json

$scoop_dir = (Split-Path (Split-Path (Split-Path  (scoop prefix scoop) -Parent)))
$buckets_dir = "$($scoop_dir)/buckets"
$app_dir = "$($scoop_dir)/apps"
$cache_dir = "$($scoop_dir)/cache"

$bucket_list = @()
if ($app[0]) {
    $bucket_list += $app[0]
}
else {
    $abgo_bucket = "abgo_bucket"
    scoop bucket list | ForEach-Object {
        if ($_.Source -match '(gitee|github).com/abgox/abgo_bucket') {
            $abgo_bucket = $_.Name
        }
        $bucket_list += $_.Name
    }
    $bucket_list = [array]$abgo_bucket + $bucket_list | Sort-Object -Unique
}
$app_list = @()
$bucket_list | ForEach-Object {
    Get-ChildItem "$($buckets_dir)/$($_)/bucket" | ForEach-Object {
        if ($_.BaseName -eq $app[1]) {
            $app_list += $_.FullName
        }
    }
}
if (!$app_list) {
    Write-Host (replace_content $json.download.no_found_app) -f Red
    return
}

try {
    $installed_version = Get-ChildItem "$($app_dir)/$($app[1])" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "\d+\..*" } | Sort-Object { [version]$_.Name } -Descending
    $installed_version = [array]$installed_version[0].Name
}
catch {
    $installed_version = $null
}

$content_manifest = Get-Content $app_list[0] -Raw | ConvertFrom-Json

#
$info = @{}
if ($installed_version) {
    if ($content_manifest.version -eq $installed_version) {
        Write-Host (replace_content $json.download.exist) -f Green
        return
    }
    else {
        $is_update = $true
    }
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
    $replace_url = $url -replace ":?[/#]?/", '_'
    $out = "$($app[1])#$($content_manifest.version)#$($replace_url)"
    $has_cache = Get-ChildItem $cache_dir | Where-Object { $_.Name -in $out }
    if (!$has_cache) {
        Write-Host  (replace_content "$($json.download.url)$($url)") -f Green
        Write-Host "---------------" -f Cyan
        Write-Host (replace_content "$($json.download.download)") -f Yellow -NoNewline
        $dl_path = $(Read-Host) -replace '"', ''
        while (!(Test-Path $dl_path)) {
            Write-Host (replace_content $json.download.no_found) -f Yellow -NoNewline
            $dl_path = $(Read-Host) -replace '"', ''
        }
        Write-Host ''
        Move-Item $dl_path "$cache_dir/$out" -Force
    }
}

[array]$info.url | ForEach-Object { ensure_cache $_ }

if ($is_update) {
    scoop update "$($bucket_list[0])/$($app[1])"
}
else {
    scoop install "$($bucket_list[0])/$($app[1])" --no-update-scoop
}
