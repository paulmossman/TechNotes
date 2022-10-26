**<span style="font-size:3em;color:black">Windows Miscellaneous</span>**
***

# Networking

## What process is using a port?
PowerShell ***run as Administrator***:
```PowerShell
netstat -anob | Select-String -Pattern "8080" -Context 0,1
```

# Screen Record

Windows key + G

In the "Capture" box, click the "Start recording" button.

Then click on the window you want to record.  (It'll only record that window.)

After stopping the recording there will be an MP4 in your Videos\Capture folder.

# Screenshot

## Copy to clipboard

Entire screen: Ctrl + Shift + Print Screen
Active window: Ctrl + Alt + Print Screen  (But this often causes "hover" dialogs/popups to disappear.)

# Select area from screen

Windows + Shift + S   (Useful for capturing "hover" dialogs/popups.)

# Task Scheduler

Want the task to keep running after your next Windows password change?  Then select: "Do not store password. The task will only have access to local computer resources."

# Paste without formatting
Unlike MacOS, it depends on whether the application supports it.

A neat trick is to use the Run dialog:
```
Win + R
Ctrl + V
Ctrl + A
Ctrl + C
Esc
```

