# Cygwin


## Setup

## Common

ln -s /cygdrive/c/ /c

### Packages I need that aren't installed by default

dos2unix
jq
curl
postgres
wget
email
xmllint

## Call from Windows CMD

   C:\cygwin64\bin\bash.exe -l
   (The "-l" option is required to setup PATH.)
   
   C:\cygwin64\bin\bash.exe -l -c "'/cygdrive/c/Users/me/call_a_script.sh'"
