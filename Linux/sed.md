# sed

## General

Make the changes to the file itself, instead of stdout:
```bash
sed -i ___
```

## Useful Examples

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
echo "Fun for Bob." | sed -e "s/Bob/& and Alice/g"
```

Groups:
```bash
echo "npm:@xlts.dev/angular@1.9.0" | sed -e 's/npm:@xlts.dev\/\(.*\)@1.9.0/npm:@xlts.dev\/\1@1.9.1/g'
```
This is just one group (```\1```), but you can have more.  The text to match can be more complex than ```.*```.