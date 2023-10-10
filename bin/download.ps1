param($app)
$scoop_dir = (Split-Path (Split-Path (Split-Path  (scoop prefix scoop) -Parent) -Parent) -Parent)
$shims_dir = $scoop_dir + '\shims'
$isExist_aria2 = Get-ChildItem $shims_dir | Where-Object { $_.Name -eq "aria2c.exe" }
$is_enable_aria = scoop config aria2-enabled

if (!$isExist_aria2) {
    Write-Host "aria2 没有安装" -f Yellow
    Write-Host "正在安装 aria2" -f Cyan
    try {
        scoop install aria2 -u
    }
    catch {
        Write-Host "安装 aria2 失败，请重新尝试" -f Red
        return
    }
}
if (!$is_enable_aria) {
    Write-Host "正在启用 aria2 下载" -f Cyan
    scoop config aria2-enabled true
}
$cache_dir = $scoop_dir + '\cache'
$app_txt = "$cache_dir\$app.txt"

$job = Start-Job -ScriptBlock {
    param($app)
    scoop install $app -u
} -ArgumentList $app

while ($true) {
    if (Test-Path($app_txt)) {
        Stop-Job -Job $job
        break
    }
}
$app_content = Get-Content $app_txt | ForEach-Object { $_.Trim() }
$download_url = $app_content[0]
$out_dir = $cache_dir
$out_file = (($app_content | Select-String -Pattern "^out=.*").Matches.Groups[0].Value).Substring(4)

Remove-Item $app_txt -Force

Write-Host "下载路径：$download_url" -f Green
Write-Host "---------------" -f Cyan
Write-Host "请点击下载路径进行手动下载`n请输入下载完成的文件路径：" -f Yellow -NoNewline
$download_path = $(Read-Host) -replace '"', ''
Move-Item $download_path "$out_dir\$out_file" -Force
scoop install $app -u
