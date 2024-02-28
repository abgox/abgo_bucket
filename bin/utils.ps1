# $ErrorActionPreference='SilentlyContinue'
try {
    $lang = (Get-WinSystemLocale).name
    if ($lang -ne 'zh-CN') {
        $lang = 'en-US'
    }
}
catch {
    $lang = 'en-US'
}

$json = Get-Content -Path "$PSScriptRoot\lang\$lang.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$path_sudo = "$PSScriptRoot\sudo.ps1"
$apps_lnk = "$env:AppData\Microsoft\Windows\Start Menu\Programs"
$admin_apps_lnk = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
$scoop_apps_lnk = "$apps_lnk\Scoop Apps"
$desktop = "$env:UserProfile\Desktop"
$public_desktop = "$env:Public\Desktop"

function data_replace($data) {
    $data = $data -join ''
    $pattern = '\{\{(.*?(\})*)(?=\}\})\}\}'
    $matches = [regex]::Matches($data, $pattern)
    foreach ($match in $matches) {
        $data = $data.Replace($match.Value, (Invoke-Expression $match.Groups[1].Value))
    }
    if ($data -match $pattern) {
        data_replace $data
    }
    else { return $data }
}
function less([array]$str_list, [scriptblock]$do = {}, [string]$color = 'Green', [int]$show_line) {
    $i = 0
    $cmd_line = if ($show_line) { $show_line }else { [System.Console]::WindowHeight - 10 }
    $lines = $str_list.Count - $cmd_line
    if ($cmd_line -lt $str_list.Count) {
        Write-Host "--------------------------------------------------" -f Yellow
        Write-Host (data_replace $json.less) -f Cyan
        Write-Host "--------------------------------------------------" -f Yellow
    }
    & $do
    while ($i -lt $cmd_line -and $i -lt $str_list.Count) {
        Write-Host $str_list[$i] -f $color
        $i++
    }
    while ($i -lt $str_list.Count) {
        $keyCode = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
        if ($keyCode -eq 13) {
            Write-Host $str_list[$i] -f $color
            $i++
        }
        else { break }
    }
}
function create_file([string]$path, [switch]$is_dir) {
    $job = Start-Job -ScriptBlock {
        param($path_sudo, $file, $is_dir)
        if ($is_dir) {
            & $path_sudo New-Item -ItemType Directory $file
        }
        else {
            & $path_sudo New-Item $file
        }
    } -ArgumentList $path_sudo, $path, $is_dir
    $null = Wait-Job $job
}
function remove_file([string]$path) {
    $job = Start-Job -ScriptBlock {
        param($path_sudo, $path)
        & $path_sudo Remove-Item -Force -Recurse $path
        $directory = Split-Path $path -Parent
        $items = Get-ChildItem -Path $directory -Force
        if ($items.Count -eq 0) {
            & $path_sudo Remove-Item -Force -Recurse $directory
        }
    } -ArgumentList $path_sudo, $path
    $null = Wait-Job $job
}
function move_file([string]$path, [string]$target) {
    $job = Start-Job -ScriptBlock {
        param($path_sudo, $path, $target)
        & $path_sudo Move-Item -Force $path $target
    } -ArgumentList $path_sudo, $path, $target
    $null = Wait-Job $job
}
function create_parent_dir([string]$path) {
    $parent_path = Split-Path $path -Parent
    if (!(Test-Path $parent_path)) {
        create_file $parent_path -is_dir
    }
}
function create_app_lnk([string]$app_path, [string]$lnk_path, [string]$icon_path = $app_path,[switch]$Force) {
    if($cmd -eq 'install' -or $Force){
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($lnk_path)
        $Shortcut.TargetPath = $app_path
        $Shortcut.WorkingDirectory = Split-Path $app_path -Parent
        $Shortcut.IconLocation = $icon_path
        $Shortcut.Save()
        $app = Split-Path $app_path -Leaf
        Write-Host (data_replace $json.shortcut) -f Green
    }
}
function persist([array]$data_list, [array]$persist_list, [switch]$dir, [switch]$file) {
    if (!($dir -or $file)) {
        Write-Error (data_replace $json.persist_err)
        return
    }
    function _do($_data, $_persist) {
        create_parent_dir $_data
        create_parent_dir $_persist
        if (Test-Path $_persist) {
            if (Test-Path $_data) {
                remove_file $_data
            }
        }
        else {
            if ($dir) { create_file $_persist -is_dir }
            elseif ($file) { create_file $_persist }
            if (Test-Path($_data)) {
                $isLink = (Get-Item $_data).Attributes -match "ReparsePoint"
                if (!$isLink) {
                    move_file "$_data\*" $_persist
                }
            }
        }
        $job = Start-Job -ScriptBlock {
            param($path_sudo, $_data, $_persist)
            if (Test-Path($_data)) { & $path_sudo Remove-Item -Force -Recurse $_data }
            & $path_sudo New-Item -ItemType SymbolicLink $_data -Target $_persist
        } -ArgumentList $path_sudo, $_data, $_persist
        $state = (Wait-Job $job).HasMoreData
        return $state
    }
    $result = @()
    for ($i = 0; $i -lt $data_list.Count; $i++) {
        $state = _do $data_list[$i] $persist_list[$i]
        if ($state) {
            $result += @{
                data    = $data_list[$i]
                persist = $persist_list[$i]
            }
        }
    }
    Write-Host "`n--------------------- $($json.persist_data[0])" -f Yellow

    $flag = 0
    if ($dir) {
        $text = @{
            origin  = $json.persist_data[1]
            persist = $json.persist_data[2]
        }
    }
    elseif ($file) {
        $text = @{
            origin  = $json.persist_data[3]
            persist = $json.persist_data[4]
        }
    }
    $result | ForEach-Object {
        if ($flag -gt 0) { Write-Host "---------------------" -f Cyan }
        Write-Host "$($text.origin) -- $($_.data)" -f Green
        Write-Host "$($text.persist) -- $($_.persist)" -f Green
        $flag++
    }
    Write-Host "---------------------`n" -f Yellow
}
function sleep_install([string]$core_exe, [int]$delay = 60000, [int]$duration = 300) {
    $flag = 0
    $num = $delay / $duration
    if ($core_exe) {
        while (!(Test-Path $core_exe) -and $flag -le $num) {
            Start-Sleep -Milliseconds $duration
            $flag++
        }
    }
}
function sleep_uninstall([string]$uninstall_exe, [int]$delay = 60000, [int]$duration = 300) {
    $flag = 0
    $num = $delay / $duration
    if ($uninstall_exe) {
        Write-Host $json.uninstalling -f Cyan
        while ((Test-Path $uninstall_exe) -and $flag -le $num) {
            Start-Sleep -Milliseconds $duration
            $flag++
        }
    }
}
function stop_process([bool]$isRemove = $true, [string]$app_dir = $dir) {
    Write-Host ($json.stop_process) -f Cyan
    $job = Start-Job -ScriptBlock {
        param($path_sudo, $path)
        Get-ChildItem $path -Recurse | Where-Object { $_.Extension -match '\.exe$' } | ForEach-Object {
            & $path_sudo Stop-Process -Name $_.BaseName -Force -ErrorAction SilentlyContinue
        }
    } -ArgumentList $path_sudo, $app_dir
    $null = Wait-Job $job
    if ($isRemove) {
        remove_file $app_dir
    }
}
function confirm([string]$tip_info) {
    Write-Host $tip_info -f Yellow
    while ($true) {
        $keyCode = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
        if ($keyCode -eq 13) {
            break
        }
        else {
            handle_lang -CN {
                @(21368, 36733, 25805, 20316, 21462, 28040) | ForEach-Object {
                    $cancel_info += [char]::ConvertFromUtf32($_)
                }
                Write-Host $cancel_info -f Red
            } -EN {
                Write-Host 'Uninstall canceled.' -f Red
            }
            Exit
        }
    }
}
function clean_redundant_files ([array]$files, [int]$delay = 5, [switch]$tip) {
    if ($tip) {
        Write-Host (data_replace $json.clean_redundant_files) -f Yellow
    }
    $files | ForEach-Object {
        $null = Start-Job -ScriptBlock {
            param($path_sudo, $delay)
            Start-Sleep -Seconds $delay
            $args | ForEach-Object {
                if (Test-Path($_)) {
                    & $path_sudo Remove-Item -Force -Recurse $_
                    $directory = Split-Path $_ -Parent
                    $items = Get-ChildItem -Path $directory -Force
                    if ($items.Count -eq 0) {
                        & $path_sudo Remove-Item -Force -Recurse $directory
                    }
                }
            }
        } -ArgumentList $path_sudo, $delay, $_
    }
}
function remove_files([array]$files) {
    $files | ForEach-Object {
        if (Test-Path($_)) {
            remove_file $_
            Write-Host  ($json.remove + $_)  -f Yellow
        }
    }
}
function get_installer_info([string]$app) {
    $rootDir = $app.ToLower()[0]
    $parts = $app -split '/'
    $id = $parts -join '.'
    $versionList = [array]((Invoke-WebRequest -Uri "https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/$($rootDir)/$($app)").Content | ConvertFrom-Json  | ForEach-Object { $_.name } | Where-Object { $_ -notmatch '^\.' } | Sort-Object { try { [version]$_ }catch {} } -Descending)
    $installer_yaml = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/microsoft/winget-pkgs/master/manifests/$($rootDir)/$($app)/$($versionList[0])/$($id).installer.yaml"

    $installer_info = ConvertFrom-Yaml $installer_yaml.Content
    $installer_info.Installers | ForEach-Object {
        $arch = $_.Architecture
        $type = [regex]::Match($_.InstallerUrl, '\.(\w+)$').Groups[1].Value
        $res = if ($type) { $arch + '_' + $type }else { $arch }
        if ($arch) {
            $installer_info.$res = $_
        }
    }
    $installer_info
}

function handle_lang([scriptblock]$CN = {}, [scriptblock]$EN = {}) {
    if ($lang -eq 'zh-CN') { & $CN }else { & $EN }
}
