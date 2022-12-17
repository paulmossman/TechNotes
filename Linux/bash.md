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

## String contains 
Note double square brackets.
```bash
string='My string';
if [[ "$string" == *My* ]]
then
  echo "It's there!";
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
