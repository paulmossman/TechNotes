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

# Command-line Arguments
number of arguments: $#
script name:         $0
first:               $1, etc...

## Get script path and filename
```
SCRIPT=`realpath "$0"`
SCRIPTPATH=`dirname "${SCRIPT}"`
SCRIPTNAME=`basename "${SCRIPT}"`
```

## Send both stderr and stdout to a file
```bash
$ ls does-not-exist &> file.txt
$ cat file.txt
ls: cannot access 'does-not-exist': No such file or directory
```

## Redirect stderr to stdout
```bash
$ ls does-not-exist > file.txt 2>&1
$ cat file.txt
ls: cannot access 'does-not-exist': No such file or directory
```
Note: The ```2>&1``` must be *after* the stdout redirection.

# Misc

## One-liner: Run a single command until it succeeds
```bash
until redis-cli PING; do sleep 1; done
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
