**<span style="font-size:3em;color:black">PowerShell</span>**
***

# Reboot
```
Restart-Computer -Force
```

# Unzip
```
Expand-Archive -Path $sourcePath -DestinationPath $destinationPath -Force
```

# Path Env var
```
echo $env:PATH
```

# "curl"
```
Invoke-WebRequest -Uri https://github.com/hairyhenderson/gomplate/releases/download/v4.3.0/gomplate_windows-amd64.exe -OutFile  gomplate.exe
```

# "grep"
```
dir | Select-String -Pattern 'dir_name'
```

# "tail -n 10 example.txt"
```
Get-Content -Path .\example.txt -Tail 10
```

# "sed" (regex, and -i)
```
(Get-Content sample.txt) -replace 'old_text.*$', "new_text" | Set-Content sample.txt
```

# "bash -x"
```
$DebugPreference - "Continue"
```

# Schedule Tasks
```
Get-ScheduledTask "TaskName" | Select-Object -ExpandProperty Actions
```

Last time it entered "Running" state:
```
$ServiceName = "TaskName"
Get-WinEvent -LogName System | Where-Object {
    $_.Id -eq 7036 -and $_.Message -match "$ServiceName.*running"
} | Select-Object -First 1 TimeCreated, Message
```

# "sort"
```
sshd -T | Sort-Object
```

# "echo"

## stdout
```
Write-Output "Hello, world!"
```

## stderr
```
Write-Error "Error: ..."
```
