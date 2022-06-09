**<span style="font-size:3em;color:black">Bash</span>**
***

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

## One-liner: Run a single command until it succeeds
```bash
until redis-cli PING; do sleep 1; done
```