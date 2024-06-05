param($path)

$content = @()

Get-ChildItem "$PSScriptRoot\..\bucket" | ForEach-Object {
    $json = Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
    $info = @()

    # homepage
    $app = $_.BaseName -replace '\.', '\.'
    $info += "[$($app)]($($json.homepage))"

    # persist
    $isPersist = $json.persist
    function Handle-Persist($obj, $isPersist = $isPersist) {
        @('pre_install', 'post_install', 'pre_uninstall', 'post_uninstall') | ForEach-Object {
            if (!$isPersist -and $obj.$_) {
                $isPersist = ($obj.$_ -join "`n") -match '(\npersist\s+[-\w]*\s+)|(\$bucketsdir\\\$bucket\\bin\\schedule.exe)'
            }
            if (!$isPersist -and $obj.$_.script) {
                $isPersist = ($obj.$_.script -join "`n") -match '(\npersist\s+[-\w]*\s+)|(\$bucketsdir\\\$bucket\\bin\\schedule.exe)'
            }
        }
        @('installer', 'uninstaller') | ForEach-Object {
            if (!$isPersist -and $obj.$_.script) {
                $isPersist = ($obj.$_.script -join "`n") -match '(\npersist\s+[-\w]*\s+)|(\$bucketsdir\\\$bucket\\bin\\schedule.exe)'
            }
        }
        return $isPersist
    }
    if ($json.architecture) {
        if ($json.architecture.'64bit') {
            $isPersist = Handle-Persist $json.architecture.'64bit'
        }
        if ($json.architecture.'32bit') {
            $isPersist = Handle-Persist $json.architecture.'32bit'
        }
        if ($json.architecture.arm64) {
            $isPersist = Handle-Persist $json.architecture.arm64
        }
    }
    $isPersist = Handle-Persist $json
    $info += if ($isPersist) { '✔️' }else { '➖' }
    # Tag
    ## font
    $tag = @()
    $isFont = $_.BaseName -like "Font-*"
    $tag += if ($isFont) { '`Font`' }
    ## confirm
    $isConfirm = $false
    @('pre_install', 'post_install', 'pre_uninstall', 'post_uninstall') | ForEach-Object {
        if (!$isConfirm) {
            $isConfirm = ($json.$_ -join "`n") -match '\nconfirm\s+'
        }
    }
    @('installer', 'uninstaller') | ForEach-Object {
        if (!$isConfirm) {
            $isConfirm = ($json.$_.script -join "`n") -match '\nconfirm\s+'
        }
    }
    $tag += if ($isConfirm) { '`Confirm`' }
    ## AutoUpdate
    $isAutoUpdate = $json.autoupdate

    $tag += if (!$isAutoUpdate) { '`NoAutoUpdate`' }

    ## PSModule
    $isPSModule = $json.psmodule
    $tag += if ($isPSModule) { '`PSModule`' }

    $info += $tag -join ' '
    ## description
    function Replace-LastChar {
        param (
            [string]$string,
            [string]$before,
            [string]$after
        )
        $pattern = [regex]::Escape($before) + '(?!.*' + [regex]::Escape($before) + ')'
        return [regex]::Replace($string, $pattern, $after)
    }
    $info += Replace-LastChar $json.description "。" "。<br>"
    $content += "|" + ($info -join "|") + "|"
}

function get_static_content($path) {
    $content = Get-Content -Path $path -Encoding UTF8

    $match = $content | Select-String -Pattern "\|:-:\|:-:\|:-:\|-\|"

    if ($match) {
        $matchLineNumber = ([array]$match.LineNumber)[0]
        $result = $content | Select-Object -First $matchLineNumber
        $result
    }
}

(get_static_content $path) + $content | Out-File $path -Encoding UTF8 -Force
