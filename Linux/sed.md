**<span style="font-size:3em;color:black">Sed</span>**
***

(Not strictly Linux-only...)

# General

Make the changes to the file itself, instead of stdout:
```bash
sed -i ___
```
(Note: Mac isn't Linux...  On a Mac you need to specify the extension of a backup file, e.g. ```-i.bak```, otherwise the next parameter will be used.)

# Useful Examples

Replace all tabs with two sapces:
```bash
sed -i -e "s/[\t]/  /g" <file>
```

Edit a file:
```bash
sed -i -e "s/one/two/g" <file>
```

Replace all lines that start with GATEWAY:
```bash
sed -i "s/^GATEWAY.*$/#REPLACED/g" <file>
```

Delete all lines that start with GATEWAY:
```bash
sed -i "/^GATEWAY.*$/d" <file>
```

Convert to uppercase:
```bash
echo mossman | sed -e "s/[a-z]/\u&/g"
```

Convert to lowercase:
```bash
echo MOSSMAN | sed -e "s/[A-Z]/\l&/g"
```

To include the original search string in the output, use ```&```:
```bash
$ echo "Fun for Bob." | sed -e "s/Bob/& and Alice/g"
Fun for Bob and Alice.
```

Remove leading and trailing whitespace:
```bash
sed -i 's/[ \t]*$//' <file>
```
(Note: Mac isn't Linux...  The above removes trailing ts on a Mac.  Below is Mac compatible):
```bash
sed -i '' -E 's/[ '$'\t'']+$//' <file>
```

## Groups
```bash
$ echo "npm:@xlts.dev/angular@1.9.0" | sed -e 's/npm:@xlts.dev\/\(.*\)@1.9.0/npm:@xlts.dev\/\1@1.9.1/g'
npm:@xlts.dev/angular@1.9.1
```
Above is just one group (```\1```), but you can have more.  The text to match can be more complex than ```.*```.

Replace `~>3.X` / `~> 3.X` with `=>3.X, <4.0`:
```bash
$ echo "version = \"~>3.120"\" | sed "s/\(\~>[ ]*\)\(3\.[0-9]*\)/>=\2, <4.0/g"
version = ">=3.120, <4.0"
$ echo "version = \"~> 3.120"\" | sed "s/\(\~>[ ]*\)\(3\.[0-9]*\)/>=\2, <4.0/g"
version = ">=3.120, <4.0"
```