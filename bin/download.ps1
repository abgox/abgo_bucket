param(
    [string]$app,
    [switch]$isUpdate
)
. $PSScriptRoot\utils.ps1

$json_d = $json.download

$info = scoop info $app
$latest_version = $info.Version
$installed_version = ($info.Installed -split "`n")[-1]

if ($latest_version -eq $installed_version) {
    Write-Host (data_replace $json_d.exist) -f Yellow
    return
}
Write-Host (data_replace $json_d.check_cache[0]) -f Yellow
$has_cache = scoop cache | Where-Object { $_.Name -eq $app -and $_.Version -eq $latest_version }
if ($has_cache) {
    Write-Host (data_replace $json_d.check_cache[1]) -f Green
    scoop install $app -u
    return
}
Write-Host (data_replace $json_d.check_cache[2]) -f Yellow

Write-Host "---------------" -f Cyan

$scoop_dir = (Split-Path (Split-Path (Split-Path  (scoop prefix scoop) -Parent) -Parent) -Parent)
$shims_dir = $scoop_dir + '\shims'
$isExist_aria2 = Get-ChildItem $shims_dir | Where-Object { $_.Name -eq "aria2c.exe" }
$is_enable_aria = scoop config aria2-enabled
if (!$isExist_aria2) {
    Write-Host $json_d.no_aria2 -f Yellow
    Write-Host $json_d.installing_aria2 -f Cyan
    try {
        scoop install aria2 -u
    }
    catch {
        Write-Host $json_d.install_aria2_failed -f Red
        return
    }
}
if (!$is_enable_aria) {
    Write-Host $json_d.enable_aria2 -f Cyan
    scoop config aria2-enabled true
}
$cache_dir = $scoop_dir + '\cache'
$app_txt = "$cache_dir\$app.txt"

$job = Start-Job -ScriptBlock {
    param($app, $isUpdate)
    if ($isUpdate) {
        scoop update $app
    }
    else {
        scoop install $app -u
    }
} -ArgumentList $app, $isUpdate

while ($true) {
    if (Test-Path($app_txt)) {
        Stop-Job -Job $job
        break
    }
    Start-Sleep -Milliseconds 50
}
$app_content = Get-Content $app_txt | ForEach-Object { $_.Trim() }
$result = @()
for ($i = 0; $i -lt $app_content.Count; $i += 4) {
    if ($i + 4 -gt $app_content.Count) { break }
    $url = $app_content[$i].Trim()
    # $referer = $app_content[$i + 1] -replace 'referer=', ''
    # $dir = $app_content[$i + 2] -replace 'dir=', ''
    $out = $app_content[$i + 3] -replace 'out=', ''

    $result += [ordered]@{
        Url = $url
        Out = $out
    }
}

if (Test-Path($app_txt)) {
    remove_file $app_txt
}
Get-ChildItem $cache_dir | Where-Object {
    $_.Name -match "^$app.*\.aria2"
} | ForEach-Object {
    remove_file $_.FullName
}

foreach ($item in $result) {
    if (!(Test-Path("$out_dir\$out_file"))) {
        continue
    }
    $download_url = $item.Url
    $out_dir = $cache_dir
    $out_file = $item.Out
    Write-Host ($json_d.url + $download_url) -f Green
    Write-Host "---------------" -f Cyan
    Write-Host $json_d.download -f Yellow -NoNewline
    $download_path = $(Read-Host) -replace '"', ''
    move_file $download_path "$out_dir\$out_file"
}

Write-Host ''
if ($isUpdate) {
    scoop update $app
}
else {
    scoop install $app -u
}
