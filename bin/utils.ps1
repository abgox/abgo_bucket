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
function get_user_path_by_registry([string]$key) {
    $folders_registry = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'
    return Get-ItemProperty -Path $folders_registry -Name $key | Select-Object -ExpandProperty $key
}

$user_Desktop = get_user_path_by_registry 'Desktop'
$user_Documents = get_user_path_by_registry 'Personal'
$user_Downloads = get_user_path_by_registry '{374DE290-123F-4565-9164-39C4925E467B}'
$user_Music = get_user_path_by_registry 'My Music'
$user_Pictures = get_user_path_by_registry 'My Pictures'
$user_Videos = get_user_path_by_registry 'My Video'
$user_Favorites = get_user_path_by_registry 'Favorites'

# e.g. C:\Users\abgox\AppData\Roaming
$user_AppData = get_user_path_by_registry 'AppData'

# e.g. C:\Users\abgox\AppData\Local
$user_LocalAppData = get_user_path_by_registry 'Local AppData'

# e.g. C:\Users\abgox\AppData\Roaming\Microsoft\Windows\Start Menu\Programs
$user_Programs = get_user_path_by_registry 'Programs'

# e.g. C:\Users\abgox\AppData\Roaming\Microsoft\Windows\Recent
$user_Recent = get_user_path_by_registry 'Recent'

# e.g. C:\Users\abgox\AppData\Roaming\Microsoft\Windows\Start Menu
$user_StartMenu = get_user_path_by_registry 'Start Menu'

# e.g. C:\Users\abgox\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
$user_Startup = get_user_path_by_registry 'Startup'

function get_public_path_by_registry([string]$key) {
    $folders_registry = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'
    return Get-ItemProperty -Path $folders_registry -Name $key | Select-Object -ExpandProperty $key
}

$public_Desktop = get_public_path_by_registry 'Common Desktop'
$public_Documents = get_public_path_by_registry 'Common Documents'
$public_Music = get_public_path_by_registry 'CommonMusic'
$public_Pictures = get_public_path_by_registry 'CommonPictures'
$public_Videos = get_public_path_by_registry 'CommonVideo'

# e.g. C:\ProgramData
$public_AppData = get_public_path_by_registry 'Common AppData'

# e.g. C:\ProgramData\Microsoft\Windows\Start Menu\Programs
$public_Programs = get_public_path_by_registry 'Common Programs'

# e.g. C:\ProgramData\Microsoft\Windows\Start Menu
$public_StartMenu = get_public_path_by_registry 'Common Start Menu'

# e.g. C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
$public_Startup = get_public_path_by_registry 'Common Startup'

$json = Get-Content -Path "$PSScriptRoot\lang\$lang.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$path_sudo = "$PSScriptRoot\sudo.ps1"
$apps_lnk = $user_Programs
$admin_apps_lnk = $public_Programs
$scoop_apps_lnk = "$apps_lnk\Scoop Apps"
$desktop = $user_Desktop

$show_info = @{
    no_shortcut = 1
}

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
function create_file([string]$path, [switch]$isDir) {
    $job = Start-Job -ScriptBlock {
        param($path_sudo, $file, $isDir)
        if ($isDir) {
            & $path_sudo New-Item -ItemType Directory $file
        }
        else {
            & $path_sudo New-Item $file
        }
    } -ArgumentList $path_sudo, $path, $isDir
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
        create_file $parent_path -isDir
    }
}
function create_app_lnk([string]$app_path, [string]$lnk_path, [string]$icon_path = $app_path) {
    if (scoop config abgo_bucket_no_shortcut) {
        if ($show_info.no_shortcut -eq 1) {
            Write-Host $json.no_shortcut -f Yellow
        }
    }
    else {
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($lnk_path)
        $Shortcut.TargetPath = $app_path
        $Shortcut.WorkingDirectory = Split-Path $app_path -Parent
        $Shortcut.IconLocation = $icon_path
        $Shortcut.Save()
        $app = Split-Path $app_path -Leaf
        if ($show_info.no_shortcut -eq 1) {
            Write-Host (data_replace $json.shortcut) -f Green
        }
    }
    $show_info.no_shortcut++
}
function remove_app_lnk([array]$lnk_name, $delay = 60, $duration = 0.3) {
    if (scoop config abgo_bucket_no_shortcut) {
        Write-Host $json.remove_app_lnk -f Yellow
        $lnk = $lnk_name | ForEach-Object {
            Join-Path $user_Desktop $_
            Join-Path $public_Desktop $_
        }
        $lnk | ForEach-Object {
            $null = Start-Job -ScriptBlock {
                param($path_sudo, $file, $delay, $duration)
                $flag = 0
                $num = $delay / $duration
                while ($true) {
                    if (Test-Path($file)) {
                        & $path_sudo Remove-Item -Force -Recurse $file
                        $directory = Split-Path $file -Parent
                        $items = Get-ChildItem -Path $directory -Force
                        if ($items.Count -eq 0) {
                            & $path_sudo Remove-Item -Force -Recurse $directory
                        }
                        break
                    }
                    if ($flag -ge $num) {
                        break
                    }
                    $flag++
                    Start-Sleep -Seconds $duration
                }
            } -ArgumentList $path_sudo, $_, $delay, $duration
        }
    }
    else {
        Write-Host $json.no_remove_app_lnk -f Yellow
    }
}
function persist([array]$data_list, [array]$persist_list, [switch]$dir, [switch]$file, [switch]$HardLink) {
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
            if ($dir) { create_file $_persist -isDir }
            elseif ($file) { create_file $_persist }
            if (Test-Path($_data)) {
                $isLink = (Get-Item $_data).Attributes -match "ReparsePoint"
                if (!$isLink) {
                    move_file "$_data\*" $_persist
                }
            }
        }
        $job = Start-Job -ScriptBlock {
            param($path_sudo, $_data, $_persist, $HardLink)
            if (Test-Path($_data)) { & $path_sudo Remove-Item -Force -Recurse $_data }
            if ($HardLink) {
                & $path_sudo New-Item -ItemType HardLink -Path $_data -Target $_persist
            }
            else {
                & $path_sudo New-Item -ItemType SymbolicLink -Path $_data -Target $_persist
            }
        } -ArgumentList $path_sudo, $_data, $_persist, $HardLink
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
function sleep_install([string]$path, $delay = 60, $duration = 0.3) {
    $flag = 0
    $num = $delay / $duration
    if ($path) {
        while (!(Test-Path $path) -and $flag -le $num) {
            Start-Sleep -Seconds $duration
            $flag++
        }
    }
}
function sleep_uninstall([string]$path, $delay = 60, $duration = 0.3) {
    $flag = 0
    $num = $delay / $duration
    if ($path) {
        Write-Host $json.uninstalling -f Cyan
        while ((Test-Path $path) -and $flag -le $num) {
            Start-Sleep -Seconds $duration
            $flag++
        }
    }
    stop_process $false $false
}
function stop_process([bool]$isRemove = $true, [bool]$tip = $true, [string]$app_dir = $dir) {
    $app_dir2 = (Split-Path $dir -Parent) + '\current'
    $dirs = @($app_dir, $app_dir2)
    if ($tip) { Write-Host ($json.stop_process) -f Cyan }
    $job = Start-Job -ScriptBlock {
        param($path_sudo, $dirs)
        & $path_sudo (Get-Process | Where-Object { $_.Modules.FileName -like "$($dirs[0])*" -or $_.Modules.FileName -like "$($dirs[1])*" } | ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue })
    } -ArgumentList $path_sudo, $dirs
    $null = Wait-Job $job
    if ($isRemove) { remove_file $app_dir }
}
function stop_exe($exeName, [switch]$tip) {
    if ($tip) { Write-Host ($json.stop_process) -f Cyan }
    $job = Start-Job -ScriptBlock {
        param($path_sudo, $exeName)
        & $path_sudo (Get-Process | Where-Object { $_.ProcessName -eq $exeName } |  ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue })
    } -ArgumentList $path_sudo, $exeName
    $null = Wait-Job $job
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
function clean_redundant_files([array]$files, $delay = 60, $duration = 0.3, [switch]$tip) {
    if ($tip) {
        Write-Host (data_replace $json.clean_redundant_files) -f Yellow
    }
    $files | ForEach-Object {
        $null = Start-Job -ScriptBlock {
            param($path_sudo, $file, $delay, $duration)
            $flag = 0
            $num = $delay / $duration
            if ($file -like "*.exe") { Start-Sleep -Seconds 30 }
            while ($true) {
                if (Test-Path($file)) {
                    & $path_sudo Remove-Item -Force -Recurse $file
                    $directory = Split-Path $file -Parent
                    $items = Get-ChildItem -Path $directory -Force
                    if ($items.Count -eq 0) {
                        & $path_sudo Remove-Item -Force -Recurse $directory
                    }
                    break
                }
                if ($flag -ge $num) {
                    break
                }
                $flag++
                Start-Sleep -Seconds $duration
            }
        } -ArgumentList $path_sudo, $_, $delay, $duration
    }
}
function remove_files([array]$files) {
    $files | ForEach-Object {
        if (Test-Path $_) {
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
