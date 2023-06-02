if (!$env:SCOOP_HOME) {
    $env:SCOOP_HOME = Resolve-Path (scoop prefix scoop)
}
$checkver_script = "$env:SCOOP_HOME/bin/checkver.ps1"
$dir = "$PSScriptRoot/../bucket" # checks the parent dir
Invoke-Expression -command "& '$checkver_script' -dir '$dir' $($args | ForEach-Object { "$_ " })"

