param(
    [string]$app,
    [switch]$is_update
)
$info =scoop info $app
$latest_version = $info.Version
$installed_version = ($info.Installed -split "`n")[-1]

if($latest_version -eq $installed_version){
    Write-Host "The latest version($installed_version) is already installed" -f Yellow
    return
}

$scoop_dir = (Split-Path (Split-Path (Split-Path  (scoop prefix scoop) -Parent) -Parent) -Parent)
$shims_dir = $scoop_dir + '\shims'
$isExist_aria2 = Get-ChildItem $shims_dir | Where-Object { $_.Name -eq "aria2c.exe" }
$is_enable_aria = scoop config aria2-enabled
if (!$isExist_aria2) {
    Write-Host "aria2 is not installed" -f Yellow
    Write-Host "Installing aria2" -f Cyan
    try {
        scoop install aria2 -u
    }
    catch {
        Write-Host "It's failed to install aria2. Please try again" -f Red
        return
    }
}
if (!$is_enable_aria) {
    Write-Host "Enabling it --- aria2-enabled" -f Cyan
    scoop config aria2-enabled true
}
$cache_dir = $scoop_dir + '\cache'
$app_txt = "$cache_dir\$app.txt"

$job = Start-Job -ScriptBlock {
    param($app, $is_update)
    if ($is_update) {
        scoop update $app
    }
    else {
        scoop install $app -u
    }
} -ArgumentList $app, $is_update

while ($true) {
    if (Test-Path($app_txt)) {
        Stop-Job -Job $job
        break
    }
    Start-Sleep -Milliseconds 100
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

if (Test-Path($app_txt)) { Remove-Item $app_txt -Force }
Get-ChildItem $cache_dir | Where-Object {
    $_.Name -match "^$app.*\.aria2"
} | ForEach-Object {
    Remove-Item $_.FullName -Force
}

foreach ($item in $result) {
    if(!(Test-Path("$out_dir\$out_file"))){
        continue
    }
    $download_url = $item.Url
    $out_dir = $cache_dir
    $out_file = $item.Out
    Write-Host "Url: $download_url" -f Green
    Write-Host "---------------" -f Cyan
    Write-Host "Please download manually.`nPlease enter the downloaded file path: " -f Yellow -NoNewline
    $download_path = $(Read-Host) -replace '"', ''
    Move-Item $download_path "$out_dir\$out_file" -Force
}

if ($is_update) {
    scoop update $app
}
else {
    scoop install $app -u
}
