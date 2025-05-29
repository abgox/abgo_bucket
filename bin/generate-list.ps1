param($path)

$manifests = Get-ChildItem "$PSScriptRoot\..\bucket"

$content = @("|App ($($manifests.Length))|Version|Persist|Tag|Description|", "|:-:|:-:|:-:|:-:|-|")

foreach ($_ in $manifests) {
    $json = Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json -AsHashtable
    $info = @()

    # homepage
    $app = $_.BaseName
    $info += "[$($app)]($($json.homepage))"

    # version
    # $info += "[v$($json.version)](./bucket/$($_.Name))"
    $info += '<a href="./bucket/' + $_.Name + '"><img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fabgox%2Fabgo_bucket%2Frefs%2Fheads%2Fmain%2Fbucket%2F' + $_.Name + '&query=%24.version&prefix=v&label=%20" alt="version" /></a>'

    # persist
    $isPersist = $json.persist
    $hasParentDir = $false
    if (!$isPersist) {
        function Handle-Persist($obj, $isPersist = $isPersist) {
            foreach ($_ in @('pre_install', 'post_install', 'pre_uninstall', 'post_uninstall')) {
                if (!$isPersist -and $obj.$_) {
                    $isPersist = ($obj.$_ -join "`n") -match '(\npersist_file\s+[-\w]*\s+)|(\$bucketsdir\\\$bucket\\bin\\schedule.exe)'
                    $hasParentDir = ($obj.$_ -join "`n") -match '\npersist_file\s+[-\w]*\s+.*\$persist_dir\\abgo_bucket'
                }
                if (!$isPersist -and $obj.$_.script) {
                    $isPersist = ($obj.$_.script -join "`n") -match '(\npersist_file\s+[-\w]*\s+)|(\$bucketsdir\\\$bucket\\bin\\schedule.exe)'
                    $hasParentDir = ($obj.$_.script -join "`n") -match '\npersist_file\s+[-\w]*\s+.*\$persist_dir\\abgo_bucket'
                }
            }
            foreach ($_ in @('installer', 'uninstaller')) {
                if (!$isPersist -and $obj.$_.script) {
                    $isPersist = ($obj.$_.script -join "`n") -match '(\npersist_file\s+[-\w]*\s+)|(\$bucketsdir\\\$bucket\\bin\\schedule.exe)'
                    $hasParentDir = ($obj.$_.script -join "`n") -match '\npersist_file\s+[-\w]*\s+.*\$persist_dir\\abgo_bucket'
                }
            }
            return @($isPersist, $hasParentDir)
        }
        if ($json.architecture) {
            if ($json.architecture.'64bit') {
                $temp = Handle-Persist $json.architecture.'64bit'
            }
            if ($json.architecture.'32bit') {
                $temp = Handle-Persist $json.architecture.'32bit'

            }
            if ($json.architecture.arm64) {
                $temp = Handle-Persist $json.architecture.arm64
            }
            if (!$isPersist) { $isPersist = $temp[0] }
            if (!$hasParentDir) { $hasParentDir = $temp[1] }
        }
        $temp = Handle-Persist $json
        if (!$isPersist) { $isPersist = $temp[0] }
        if (!$hasParentDir) { $hasParentDir = $temp[1] }
    }
    $info += if ($isPersist) { '✔️' }else { '➖' }
    # Tag
    ## font
    $tag = @()
    $tag += if ($hasParentDir) { '`hasParentDir`' }
    $isFont = $_.BaseName -like "Font-*"
    $tag += if ($isFont) { '`Font`' }
    ## confirm
    $isConfirm = $false
    foreach ($_ in @('pre_install', 'post_install', 'pre_uninstall', 'post_uninstall')) {
        if (!$isConfirm) {
            $isConfirm = ($json.$_ -join "`n") -match '\nconfirm\s+'
        }
    }
    foreach ($_ in @('installer', 'uninstaller')) {
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

    $match = $content | Select-String -Pattern "<!-- prettier-ignore-start -->"

    if ($match) {
        $matchLineNumber = ([array]$match.LineNumber)[0]
        $result = $content | Select-Object -First $matchLineNumber
        $result
    }
}

(get_static_content $path) + $content + "<!-- prettier-ignore-end -->" | Out-File $path -Encoding UTF8 -Force
