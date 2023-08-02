# xargs

... | xargs -I {} echo This {}

For every line of input ({}), run "echo This {}"

# Sed Examples

## Change all lines containing a string
```bash
grep -R "Constants.FF" src/test | cut -f1 -d: | uniq | xargs -r -L1 sed -i -e "s/Constants\.FF/true/g"
```

## Delete all lines containing a string
```bash
grep -R "Constants\.FF" src/ | cut -f1 -d: | uniq | xargs -r -L1 sed -i -e "/assumeTrue(Constants\.FF)/d"
```