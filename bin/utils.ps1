# $ErrorActionPreference='SilentlyContinue'
$lang = $PSUICulture
if ($lang -ne 'zh-CN') { $lang = 'en-US' }

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

$info = @{
    need_show_tip = $true
}
function data_replace {
    param ($data, $separator = '')
    $data = ($data -join $separator)
    $pattern = '\{\{(.*?(\})*)(?=\}\})\}\}'
    $matches = [regex]::Matches($data, $pattern)
    foreach ($match in $matches) {
        $data = $data.Replace($match.Value, (Invoke-Expression $match.Groups[1].Value) -join $separator )
    }
    if ($data -match $pattern) { $this.replace_content($data) }else { return $data }
}
function show_with_less {
    param (
        $str_list,
        [scriptblock]$do = {},
        [string]$color = 'Green',
        [int]$show_line = [System.Console]::WindowHeight - 10
    )
    if ($str_list -is [string]) {
        $str_list = $str_list -split "`n"
    }
    $i = 0
    $need_less = [System.Console]::WindowHeight -lt ($str_list.Count + 2)
    if ($need_less) {
        $lines = $str_list.Count - $show_line
        write_with_color (data_replace $json.less)
        & $do
        while ($i -lt $str_list.Count -and $i -lt $show_line) {
            Write-Host $str_list[$i] -f $color
            $i++
        }
        while ($i -lt $str_list.Count) {
            $keyCode = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode
            if ($keyCode -ne 13) {
                break
            }
            Write-Host $str_list[$i] -f $color
            $i++
        }
        $end = if ($i -lt $str_list.Count) { $false }else { $true }
        if ($end) {
            Write-Host ' '
            Write-Host '(End)' -f Black -b White -NoNewline
            while ($end) {
                $keyCode = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode
                if ($keyCode -ne 13) {
                    Write-Host ' '
                    break
                }
            }
        }
    }
    else {
        foreach ($_ in $str_list) { Write-Host $_ -f $color }
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

function create_app_lnk([string]$app_path, [string]$lnk_path, [string]$arguments = '', [string]$icon_path = $app_path) {
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($lnk_path)
    $Shortcut.TargetPath = $app_path -replace '"', ''
    $Shortcut.WorkingDirectory = Split-Path $app_path -Parent
    $Shortcut.IconLocation = $icon_path
    $Shortcut.Arguments = $arguments
    $Shortcut.Save()
    $app = Split-Path $app_path -Leaf
}
function handle_app_lnk {
    param(
        # 其他特殊的快捷方式，如 xxx.url
        [array]$ohter_lnk
    )
    # 根据配置判断是否需要创建桌面快捷方式
    if (scoop config abgo_bucket_no_shortcut) {
        $lnk_list = @()
        foreach ($_ in $manifest.shortcuts) {
            $lnk_list += "$($_[1]).lnk"
        }
        $lnk_list += $ohter_lnk
        $lnk_list = foreach ($_ in $lnk_list) {
            if ($_ -match '.*\..+') {
                Join-Path $public_Desktop $_
                Join-Path $user_Desktop $_
            }
        }
        function remove_app_lnk([array]$lnk_list) {
            foreach ($_ in $lnk_list) {
                $null = Start-Job -ScriptBlock {
                    param($lnk)
                    $flag = 0
                    while ($true) {
                        if (Test-Path $lnk) {
                            Remove-Item $lnk -ErrorAction SilentlyContinue
                            break
                        }
                        if ($flag -ge 120) {
                            break
                        }
                        $flag++
                        Start-Sleep -Seconds 1
                    }
                } -ArgumentList $_
            }
        }
        # 移除所有相关的桌面快捷方式
        remove_app_lnk $lnk_list
        write_with_color (data_replace $json.no_shortcut)
    }
    else {
        # 创建桌面快捷方式
        function _do($shortcuts) {
            foreach ($_ in $shortcuts) {
                $lnk_path = Join-Path $user_Desktop "$($_[1]).lnk"
                $app_path = Join-Path $dir $_[0]
                if (Test-Path "$($public_Desktop)/$($_[1]).lnk") {
                    Move-Item "$($public_Desktop)/$($_[1]).lnk" $lnk_path -Force
                }
                else {
                    $icon_path = if ($_[3]) { Join-Path $dir $_[3] }else { $app_path }
                    create_app_lnk $app_path $lnk_path $_[2] $icon_path
                }
                write_with_color (data_replace $json.shortcut)
            }
            write_with_color (data_replace $json.has_shortcut)
        }
        if ($manifest.shortcuts) {
            _do $manifest.shortcuts
        }
        else {
            if ($architecture -and $manifest.architecture.$architecture.shortcuts) {
                _do $manifest.architecture.$architecture.shortcuts
            }
        }
    }
}
function persist_file([array]$data_list, [array]$persist_list, [switch]$dir, [switch]$file, [switch]$HardLink) {
    if (!($dir -or $file)) {
        Write-Error (data_replace $json.persist_err)
        return
    }
    function _do($_data, $_persist) {
        create_parent_dir $_data
        create_parent_dir $_persist
        $isLink = if (Test-Path $_data) { (Get-Item $_data).Attributes -match "ReparsePoint" }else { $true }
        if (Test-Path $_persist) {
            if (Test-Path $_data) {
                remove_file $_data
            }
        }
        else {
            if ($file) {
                if (Test-Path($_data)) {
                    if (!$isLink) {
                        move_file $_data $_persist
                    }
                    else {
                        remove_file $_data
                        create_file $_persist
                    }
                }
                else {
                    create_file $_persist
                }
            }
            else {
                create_file $_persist -isDir
                if (Test-Path($_data)) {
                    if (!$isLink) {
                        move_file "$_data\*" $_persist
                    }
                    remove_file $_data
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
    foreach ($_ in $result) {
        if ($flag -gt 0) { Write-Host "---------------------" -f Cyan }
        Write-Host "$($text.origin) -- $($_.data)" -f Green
        Write-Host "$($text.persist) -- $($_.persist)" -f Green
        $flag++
    }
    Write-Host "---------------------`n" -f Yellow
}
function sleep_install([string]$path) {
    $flag = 0
    if ($path) {
        while (!(Test-Path $path) -and $flag -le 120) {
            Start-Sleep -Seconds 1
            $flag++
        }
    }
}
function sleep_uninstall([string]$path) {
    $flag = 0
    if ($path) {
        write_with_color (data_replace $json.uninstalling)
        while ((Test-Path $path) -and $flag -le 120) {
            Start-Sleep -Seconds 1
            $flag++
        }
    }
    stop_process $false $false
}
function stop_process([bool]$isRemove = $true, [bool]$tip = $true, [string]$app_dir = $dir) {
    $app_dir2 = (Split-Path $dir -Parent) + '\current'
    $dirs = @($app_dir, $app_dir2)
    if ($tip) { write_with_color (data_replace $json.stop_process) }
    $job = Start-Job -ScriptBlock {
        param($path_sudo, $dirs)
        & $path_sudo (Get-Process | Where-Object { $_.Modules.FileName -like "$($dirs[0])*" -or $_.Modules.FileName -like "$($dirs[1])*" } | ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue; Wait-Process -Id $_.Id -ErrorAction SilentlyContinue -Timeout 30 })
    } -ArgumentList $path_sudo, $dirs
    $null = Wait-Job $job
    if ($isRemove -and (scoop config abgo_bucket_no_old_version)) { remove_file $app_dir }
    remove_files
}
function stop_exe($exeName, [switch]$tip) {
    if ($tip) { write_with_color (data_replace $json.stop_process) }
    $job = Start-Job -ScriptBlock {
        param($path_sudo, $exeName)
        & $path_sudo (Get-Process | Where-Object { $_.ProcessName -eq $exeName } |  ForEach-Object { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue })
    } -ArgumentList $path_sudo, $exeName
    $null = Wait-Job $job
}
function confirm([string]$tip_info) {
    if (!(scoop config abgo_bucket_no_confirm)) {
        Write-Host $tip_info -f Yellow
        while ($true) {
            $keyCode = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
            if ($keyCode -eq 13) {
                break
            }
            else {
                handle_lang -CN {
                    foreach ($_ in @(21368, 36733, 25805, 20316, 21462, 28040)) {
                        $cancel_info += [char]::ConvertFromUtf32($_)
                    }
                    Write-Host $cancel_info -f Yellow
                } -EN {
                    Write-Host 'Uninstall canceled.' -f Yellow
                }
                Exit
            }
        }
    }
}
function clean_redundant_files([array]$files, [switch]$tip) {
    if ($tip) {
        write_with_color (data_replace $json.clean_redundant_files)
    }
    foreach ($_ in $files) {
        $null = Start-Job -ScriptBlock {
            param($path_sudo, $file)
            Start-Sleep -Seconds 15
            $flag = 0
            if ($file -like "*.exe") { Start-Sleep -Seconds 60 }
            if (Test-Path($file)) {
                & $path_sudo Remove-Item -Force -Recurse $file
                $directory = Split-Path $file -Parent
                $items = Get-ChildItem -Path $directory -Force
                if ($items.Count -eq 0) {
                    & $path_sudo Remove-Item -Force -Recurse $directory
                }
                break
            }
        } -ArgumentList $path_sudo, $_
    }
}
function remove_files([array]$files) {
    $lnk_list = @()
    foreach ($_ in $manifest.shortcuts) {
        $lnk_list += Join-Path $user_Desktop "$($_[1]).lnk"
    }
    foreach ($_ in $lnk_list) {
        if (Test-Path $_) {
            Remove-Item $_ -ErrorAction SilentlyContinue
            Write-Host  ($json.remove + $_)  -f Yellow
        }
    }
    foreach ($_ in $files) {
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
    foreach ($_ in $installer_info.Installers) {
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

function write_with_color([string]$str) {
    $color_list = @()
    $str = $str -replace "`n", 'n&&_n_n&&'
    $str_list = foreach ($_ in $str -split '(<\@[^>]+>.*?(?=<\@|$))' | Where-Object { $_ -ne '' }) {
        if ($_ -match '<\@([\s\w]+)>(.*)') {
            ($matches[2] -replace 'n&&_n_n&&', "`n") -replace '^<\@>', ''
            $color = $matches[1] -split ' '
            $color_list += @{
                color   = $color[0]
                bgcolor = $color[1]
            }
        }
        else {
            ($_ -replace 'n&&_n_n&&', "`n") -replace '^<\@>', ''
            $color_list += @{}
        }
    }
    $str_list = [array]$str_list
    for ($i = 0; $i -lt $str_list.Count; $i++) {
        $color = $color_list[$i].color
        $bgcolor = $color_list[$i].bgcolor
        if ($color) {
            if ($bgcolor) {
                Write-Host $str_list[$i] -f $color -b $bgcolor -NoNewline
            }
            else {
                Write-Host $str_list[$i] -f $color -NoNewline
            }
        }
        else {
            Write-Host $str_list[$i] -NoNewline
        }
    }
    Write-Host ''
}

function do_some_things {
    if ($path_installer) {
        clean_redundant_files $path_installer
    }
}
