# Windows Miscellaneous

## Networking

### What process is using a port?
PowerShell ***run as Administrator***:
```PowerShell
netstat -anob | Select-String -Pattern "0:8080" -Context 0,1
```

## Screen Record

Windows key + G

In the "Capture" box, click the "Start recording" button.

Then click on the window you want to record.  (It'll only record that window.)

After stopping the recording there will be an MP4 in your Videos\Capture folder.