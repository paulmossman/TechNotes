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