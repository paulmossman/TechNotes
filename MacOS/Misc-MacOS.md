**<span style="font-size:3em;color:black">Misc macOS</span>**
***

# Paste without formatting
```
Option + Command + Shift + V
```
Helpful: Option + Shift in one hand.  Then it's a normal Command + V in the other hand.


# Screen record on Mac with internal audio → BlackHole

Install BlackHole

System Preferences → Sound → Output → Select “BlackHole 2ch”, then exit.

QuickTime:
 - File → New Screen Recording
 - Options → BlackHole 2ch
 - Record...

Done: System Preferences → Sound → Output → 

https://appletoolbox.com/record-screen-internal-audio-mac/#:~:text=Press%20and%20hold%20the%20Command,the%20sidebar%20on%20the%20left. 

And then of course to listen to the recorded audo, switch back to MacBook speakers.

# Remote Desktop (without the $110 Apple Mac client) - VNC

Note: Not encrypted (so trusted network only)

On the client computer use [RealVNC viewer](https://www.realvnc.com/download/viewer/)

On the server computer enable screen sharing: System Preferences → Sharing → select "Screen Sharing".

# Command-line open Finder
```bash
open .
```
 
# Networking

## What process is using a port?
```bash
sudo lsof -i -P | grep LISTEN | grep :8080
```

