param(
    [string]$app,
    [switch]$isUpdate
)
. $PSScriptRoot\utils.ps1

$json_d = $json.download

$info = scoop info $app
$latest_version = $info.Version
$installed_version = ($info.Installed -split "`n")[-1]

if ($installed_version) {
    if ($latest_version -eq $installed_version) {
        Write-Host (data_replace $json_d.exist) -f Yellow
        return
    }
    else {
        $isUpdate = $true
    }
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

$result = @{
    url = @()
    out = @()
}
foreach ($i in $app_content) {
    $i = $i.Trim()
    if ($i -like "http*") {
        $result.url += $i
    }
    elseif ($i -like "out=*") {
        $result.out += $i -replace 'out=', ''
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

for ($i = 0; $i -lt $result.url.Count; $i++) {
    $url = $result.url[$i]
    $out = $result.out[$i]
    Write-Host ($json_d.url + $url) -f Green
    Write-Host "---------------" -f Cyan
    Write-Host $json_d.download -f Yellow -NoNewline
    $dl_path = $(Read-Host)
    while (!(Test-Path $dl_path)) {
        handle_lang -CN {
            @(36825, 20010, 25991, 20214, 19981, 23384, 22312, 65292, 35831, 37325, 26032, 36755, 20837, 58, 32) | ForEach-Object {
                $err_info += [char]::ConvertFromUtf32($_)
            }
            Write-Host $err_info -f Yellow -NoNewline
        } -EN {
            Write-Host "File not found, please input again: " -f Yellow -NoNewline
        }
        $dl_path = $(Read-Host)
    }
    move_file $dl_path "$cache_dir\$out"
}

Write-Host ''
if ($isUpdate) {
    scoop update $app
}
else {
    scoop install $app -u
}
