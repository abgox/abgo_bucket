$lang = (Get-WinSystemLocale).name
if ($lang -ne 'zh-CN') {
    $lang = 'en-US'
}
$json = Get-Content -Path "$PSScriptRoot\lang\$lang.json" -Raw -Encoding UTF8 | ConvertFrom-Json

$scoop_apps_lnk= "$env:AppData\Microsoft\Windows\Start Menu\Programs\Scoop Apps"
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

function less($str_list, $do = {}, $color = 'Green', $show_line) {
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

function create_parent_dir($path) {
    $parent_path = Split-Path $path -Parent
    if (!(Test-Path $parent_path)) {
        New-Item -ItemType Directory $parent_path > $null
    }
}

function create_app_lnk($app_path,$lnk_path){
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($lnk_path)
    $Shortcut.TargetPath =$app_path
    $Shortcut.Save()
}


function persist($data_list, $persist_list = @($persist_dir)) {
    function _do($data_dir, $persist_dir = $persist_list[0]) {
        if (Test-Path $persist_dir) {
            if (Test-Path $data_dir) {
                sudo.ps1 Remove-Item -Force -Recurse $data_dir
            }
        }
        else {
            New-Item -ItemType Directory $persist_dir > $null
            if (Test-Path($data_dir)) {
                $isLink = (Get-Item $data_dir).Attributes -match "ReparsePoint"
                if (!$isLink) {
                    sudo.ps1 Move-Item "$data_dir\*" $persist_dir -Force
                }
                else { sudo.ps1 Remove-Item -Force -Recurse $data_dir }
            }
        }
        create_parent_dir $data_dir
        create_parent_dir $persist_dir

        $sudo_path = "$PSScriptRoot\sudo.ps1"
        $link = Start-Job -ScriptBlock {
            param($sudo_path, $data_dir, $persist_dir)
            Invoke-Expression "$sudo_path New-Item -ItemType SymbolicLink `"$data_dir`" -Target `"$persist_dir`""
        } -ArgumentList $sudo_path, $data_dir, $persist_dir
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
    $result | ForEach-Object {
        if ($flag -gt 0) { Write-Host "---------------------" -f Cyan }
        Write-Host "$($json.persist_data[1]) -- $($_.data)" -f Green
        Write-Host "$($json.persist_data[2]) -- $($_.persist)" -f Green
        $flag++
    }
    Write-Host "---------------------`n" -f Yellow
}

function persist_file($data_list, $persist_list) {
    function _do($data_file, $persist_file) {
        if (Test-Path $persist_file) {
            if (Test-Path $data_file) {
                sudo.ps1 Remove-Item -Force -Recurse $data_file
            }
        }
        else {
            New-Item $persist_file
            if (Test-Path($data_file)) {
                $isLink = (Get-Item $data_file).Attributes -match "ReparsePoint"
                if (!$isLink) {
                    sudo.ps1 Move-Item $data_file $persist_file -Force
                }
                else { sudo.ps1 Remove-Item -Force $data_file }
            }
        }
        create_parent_dir $data_file
        create_parent_dir $persist_file

        $sudo_path = "$PSScriptRoot\sudo.ps1"
        $link = Start-Job -ScriptBlock {
            param($sudo_path, $data_file, $persist_file)
            Invoke-Expression "$sudo_path New-Item -ItemType SymbolicLink $data_file -Target $persist_file"
        } -ArgumentList $sudo_path, $data_file, $persist_file
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
    Write-Host "--------------------- $($json.persist_data[0])" -f Yellow
    $flag = 0
    $result | ForEach-Object {
        if ($flag -gt 0) { Write-Host "---------------------" -f Cyan }
        Write-Host "$($json.persist_data[3]) -- $($_.data)" -f Green
        Write-Host "$($json.persist_data[4]) -- $($_.persist)" -f Green
        $flag++
    }
    Write-Host "---------------------`n" -f Yellow
}

function stop_process($app_dir = $dir) {
    Get-ChildItem $app_dir -Recurse | Where-Object { $_.Extension -match '\.exe$' } | ForEach-Object {
        sudo.ps1 Stop-Process -Name $_.BaseName -Force -ErrorAction SilentlyContinue
        Write-Host ($json.stop_process + $_.FullName) -f Cyan
    }
    sudo.ps1 Remove-Item $app_dir -Force -Recurse -ErrorAction SilentlyContinue
}

function confirm($tip_info) {
    while ($true) {
        Write-Host $tip_info -f Yellow
        $keyCode = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
        if ($keyCode -eq 13) {
            break
        }
    }
}
