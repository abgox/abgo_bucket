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

$scoop_apps_lnk = "$env:AppData\Microsoft\Windows\Start Menu\Programs\Scoop Apps"
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

function create_parent_dir([string]$path) {
    $parent_path = Split-Path $path -Parent
    if (!(Test-Path $parent_path)) {
        New-Item -ItemType Directory $parent_path > $null
    }
}

function create_app_lnk([string]$app_path, [string]$lnk_path) {
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($lnk_path)
    $Shortcut.TargetPath = $app_path
    $Shortcut.Save()
    $app = Split-Path $app_path -Leaf
    Write-Host (data_replace $json.shortcut) -f Green
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
                sudo.ps1 Remove-Item -Force -Recurse $_data
            }
        }
        else {
            if ($dir) {
                New-Item -ItemType Directory $_persist > $null
            }
            elseif ($file) {
                New-Item $_persist > $null
            }
            if (Test-Path($_data)) {
                $isLink = (Get-Item $_data).Attributes -match "ReparsePoint"
                if (!$isLink) {
                    sudo.ps1 Move-Item "$_data\*" $_persist -Force
                }
            }
        }
        $sudo_path = "$PSScriptRoot\sudo.ps1"
        $link = Start-Job -ScriptBlock {
            param($sudo_path, $_data, $_persist)
            if (Test-Path($_data)) { Remove-Item -Force -Recurse $_data }
            Invoke-Expression "$sudo_path New-Item -ItemType SymbolicLink `"$_data`" -Target `"$_persist`""
        } -ArgumentList $sudo_path, $_data, $_persist
        $state = (Wait-Job $link).HasMoreData
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

function stop_process([string]$app_dir = $dir) {
    Get-ChildItem $app_dir -Recurse | Where-Object { $_.Extension -match '\.exe$' } | ForEach-Object {
        sudo.ps1 Stop-Process -Name $_.BaseName -Force -ErrorAction SilentlyContinue
        Write-Host ($json.stop_process + $_.FullName) -f Cyan
    }
    sudo.ps1 Remove-Item $app_dir -Force -Recurse -ErrorAction SilentlyContinue
}

function confirm([string]$tip_info) {
    while ($true) {
        Write-Host $tip_info -f Yellow
        $keyCode = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
        if ($keyCode -eq 13) {
            break
        }
    }
}
