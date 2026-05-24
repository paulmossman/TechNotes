**<span style="font-size:3em;color:black">Misc macOS</span>**
***

[TOC]

# Keyboard Shortcuts

## Open file/folder location

```
Command + Shift + G
```

From the file/folder open dialog, this will bring up an edit box where you can paste/type a path. And it does tab completion.

## Character Viewer (Emoji & Symbols)
```
Control + Command + space
```
Click on the upper right icon to expand and see more categories.

## Paste without formatting
```
Option + Command + Shift + V
```
Helpful: Option + Shift in one hand. Then it's a normal Command + V in the other hand.

## Lock Screen
```
Ctrl + Command + Q 
```

## See all open windows (Mission Control)
```
Ctrl + ↑
```
Also: 3 finger swipe **up**.

## See all open windows for the current app (even on other Desktops)
```
Ctrl + ↓
```

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

On the server computer enable screen sharing: System Preferences → Sharing → select "Screen Sharing".

On the client computer:
- MacOS: Enter `vnc://[IP] in Safari, which launches "Screen Sharing".
- other: [RealVNC viewer](https://www.realvnc.com/download/viewer/)

# Command-line `open` Finder

```bash
open .
```

# Magnet: Organize your windows

https://magnet.crowdcafe.com/ ($5)

# Networking

## What process is using a port?
```bash
sudo lsof -i -P | grep LISTEN | grep :8080
```

# Sleep

## Avoid

Avoid display sleep, idle sleep, disk sleep, and system sleep:

```bash
caffeinate -dimsu
```
