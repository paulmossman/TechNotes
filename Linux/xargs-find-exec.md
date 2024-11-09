# xargs / find exec

# find

## find exec
```
find . -name '*.java' -exec grep -H "some text" {} \;
```

## find multiple filenames
```
find . \( -name 'ops.yaml' -or -name 'ops.yml' \)
find . \( -name 'Dockerfile' -or -name 'Containerfile' \)
```

# xargs
... | xargs -I {} echo This {}

For every line of input ({}), run "echo This {}"

## Sed Examples

### Change all lines containing a string
```bash
grep -R "Constants.FF" src/test | cut -f1 -d: | sort | uniq | sed 's/^/"/;s/$/"/' | xargs -r -L1 sed -i -e "s/Constants\.FF/true/g"
```
Note: The first sed adds double quotes around the filename and path, in case it contains spaces.


### Delete all lines containing a string
```bash
grep -R "Constants\.FF" src/ | cut -f1 -d: | uniq | xargs -r -L1 sed -i -e "/assumeTrue(Constants\.FF)/d"
```