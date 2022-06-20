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