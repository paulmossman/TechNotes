**<span style="font-size:3em;color:black">Cygwin</span>**
***

# Setup

## Common

ln -s /cygdrive/c/ /c

## Packages I need that aren't installed by default
- dos2unix
- jq
- curl
- postgres
- wget
- xmllint
- openssh  (The Windows ssh/scp requires Windws path for -i.)
- nc

# Windows Paths

## Adjust paths to Windows format in scripts
This is required to pass a path as a parameter to a Windows executable, like ```java.exe```.
```
if [[ $(uname -s) == CYGWIN* ]]; then
   # Running under Cygwin.
   JAR=`cygpath -w ${JAR}`
fi
```
Note: Double marks (aka squar brackets) is required.

## Open Windows Explorer in a particular directory
```bash
explorer `cygpath -d src/test`
```

A useful script:
```bash
#!/bin/bash
OPEN_PATH="."
if [ "$#" -gt "0" ]; then
   OPEN_PATH=$1
fi
explorer `cygpath -d $OPEN_PATH`
```

# Call from Windows CMD

   C:\cygwin64\bin\bash.exe -l
   (The "-l" option is required to setup PATH.)
   
   C:\cygwin64\bin\bash.exe -l -c "'/cygdrive/c/Users/me/call_a_script.sh'"
