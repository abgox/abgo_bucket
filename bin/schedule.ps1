param(
    $taskName,
    $scriptPath
)
if (!$scriptPath) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    return
}
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

if ($existingTask -ne $null) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" -WindowStyle Hidden"

$trigger = New-ScheduledTaskTrigger -AtLogOn

$task = New-ScheduledTask -Action $action -Trigger $trigger

Register-ScheduledTask -TaskName $taskName -InputObject $task
