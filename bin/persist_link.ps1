param(
    [string]$data_path,
    [string]$persist_path
    # [string]$persist_dir
)
$base_data_path = Split-Path -Path $data_path -Parent
$base_persist_path = Split-Path -Path $persist_path -Parent

if (!(Test-Path $persist_dir)) {
    mkdir $persist_dir > $null
}
if (Test-Path $persist_path) {
    if (Test-Path $data_path) {
        Remove-Item -Force -Recurse $data_path
    }
}
else {
    if (Test-Path $data_path) {
        $isLink = (Get-Item $data_path).Attributes -match "ReparsePoint"
        if ($isLink) {
            Remove-Item -Force -Recurse $data_path
        }
        else {
            if (!(Test-Path $base_persist_path)) { mkdir $base_persist_path > $null }
            Move-Item $data_path $base_persist_path
        }
    }
}
if (!(Test-Path $base_data_path)) { mkdir $base_data_path > $null }
if (!(Test-Path $persist_path)) { mkdir $persist_path > $null }
$currentScriptPath = $MyInvocation.MyCommand.Path
$parentDirectory = Split-Path $currentScriptPath -Parent
Invoke-Expression "$parentDirectory\sudo.ps1 New-Item -ItemType SymbolicLink $data_path -Target $persist_path"
