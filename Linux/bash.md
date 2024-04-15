**<span style="font-size:3em;color:black">Bash</span>**
***

# stdout & stderr

## Tee
```bash
$ echo fun | tee fun.txt
fun
$ cat fun.txt
fun
```
echo into a priviledged file:
```bash
echo "<USERNAME> ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
```


# Command-line Arguments
- number of arguments: $#
- script name:         $0
- first:               $1, etc...

## Get script path and filename
```
SCRIPT=`realpath "$0"`
SCRIPTPATH=`dirname "${SCRIPT}"`
SCRIPTNAME=`basename "${SCRIPT}"`
```

## Parse
```bash
usage() {
    echo "Usage: $0 -o|--one=<...> -t|--two=<...> -h|--three=<...>">&2
    exit 2
}

PARAMS=""
while (( "$#" )); do
   case "$1" in
      -o|--one)
         if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
            ONE=$2
            shift 2
         else
            echo "Error: Argument for $1 is missing" >&2
            usage
         fi
         ;;
      -t|--two)
         if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
            TWO=$2
            shift 2
         else
            echo "Error: Argument for $1 is missing" >&2
            usage
         fi
         ;;
      -h|--three)
         if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
            THREE=$2
            shift 2
         else
            echo "Error: Argument for $1 is missing" >&2
            usage
         fi
         ;;
      -*|--*=) # unsupported flags
         usage
         ;;
      *) # preserve positional arguments
         PARAMS="$PARAMS $1"
         shift
         ;;
   esac
done


```

# Misc

## Send both stderr and stdout to a file
```bash
$ ls does-not-exist &> file.txt
$ cat file.txt
ls: cannot access 'does-not-exist': No such file or directory
```

## Send both stderr and stdout to /dev/null
```bash
ls . no-such-file > /dev/null 2>&1
```bash

## Redirect stderr to stdout
```bash
$ ls does-not-exist > file.txt 2>&1
$ cat file.txt
ls: cannot access 'does-not-exist': No such file or directory
```
Note: The ```2>&1``` must be *after* the stdout redirection.

## One-liners

### Run a single command until it succeeds
```bash
until redis-cli PING; do sleep 1; done
```

### For loop
```bash
for i in {1..5}; do echo "$i"; done
```

## if/else
```bash
if [ $? -eq 0 ]; then echo 1; else echo 0; fi
```

## While loop
```bash
while true; do ls -al; sleep 5; done
```

## Flatten multiple lines onto one line
```bash
ls -l | tr '\n' ' '
ls -l | awk '{print}' ORS=' '
ls -l | xargs
```

# Misc script snippets

## If the exit status of a command isn't success, then exit with that same status
```bash
ls file-that-does-not-exist
RESULT=$?
if [ ${RESULT} != "0" ]; then
   exit ${RESULT}
fi
```

## Cat multiple lines as piped stdin
```bash
cat << EOF | aws configure --profile easy-aws-privacy-vpn
${AccessKeyId}
${SecretAccessKey}
ca-central-1
json
EOF
```

## Cat multiple lines to a file
```bash
cat <<EOF > print.sh
#!/bin/bash
echo \$PWD
echo $PWD
EOF
```

## Loop over a range of numbers
```bash
for i in {1..5}; do
   echo $i
done
```

## Loop over strings
```bash
strings=("a" "b" "c")
for i in "${strings[@]}" ; do echo "$i"; done
```

## String contains 
Note double square brackets.
```bash
string='My string';
if [[ "$string" == *My* ]]
then
  echo "It contains!";
fi
```

## String equals
```bash
string='My string';
if [[ "$string" = "My string" ]]
then
  echo "It's equal!";
fi
```

## String not equals
```bash
if [ "$PHONE_TYPE" != "NORTEL" ] && [ "$PHONE_TYPE" != "NEC" ] && [ "$PHONE_TYPE" != "CISCO" ]
```

## String not empty - empty string
```bash
if [ -n "$pid" ]; then
  echo "The string is not empty - $pid"
fi

if [ -z "$var" ]; then
      echo "\$var is empty"
else
      echo "\$var is NOT empty"
fi
```

## Conditionals
```bash
-ne
    Not equals
-gt
    Greater than
-lt
    Less than
-eq
    Equals
-a
    AND
-o
    OR
-a file
    True if file exists.
-s file
    True if file exists and has a size greater than zero.
-d file
    True if file exists and is a directory.
-f file
    True if file exists and is a regular file.
-h file
    True if file exists and is a symbolic link.
-r file
    True if file exists and is readable.
-w file
    True if file exists and is writable.
-x file
    True if file exists and is executable.
-N file
    True if file exists and has been modified since it was last read.
-z string
    True if the length of string is zero.  (Empty string)
-n string
    True if the length of string is non-zero.
```
They can be combined, e.g. -fs → True for existing regular file with size greater than zero.

### Conditionals example
```bash
usage() {
   echo "Usage: $0 <Mandatory Parameter> [Optional Parameter]">&2
   exit 2
}

if [ "$#" -gt "2" -o "$#" -lt "1" ]; then
   usage
fi
MANDATORY_PARAMETER=$1
if [ "$#" -eq "2" ]; then
   OPTIONAL_PARAMETER=$2
else
   OPTIONAL_PARAMETER="default"
fi
```