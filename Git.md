# Git


# Cherry-Pick
Basic:
```bash
git cherry-pick <commit1> <commit2>
```

Multiple commits at once:
```bash
git cherry-pick <commit1> <commit2>
```
   <ul>
   But this seems to have problems when the commits change the same lines of code, results in merge conflict.  So in that case just do each in order, from oldest to newest.
   </ul>

---
Abort:
```bash
git cherry-pick --abort
```

# Hard reset to remote branch content
```bash
git reset --hard origin/<branch>
```

# Delete a local branch
```bash
git branch --delete <name>
```

# Merge

Abort:
```bash
git merge --abort
```

# Fetch

## Fetch the latest from another branch without switching it
Only works for fast-forward merges.
For example, for 'develop' branch:
```bash
git fetch origin develop:develop
```
Then you can git merge the branch.

# Diff

## Diff two branches
Just make sure you have the latest from each branch first:
```bash
git checkout develop
git pull
git fetch origin master:master
git diff master
```

### Diff two remote branches (regardless of local content)
```bash
git diff remotes/origin/develop remotes/origin/master
```

# Miscellaneous

## For Unix line endings
Use a `.gitattributes` file:
```
<filename> text eol=lf
```
```<filename>``` accepts wildcards.
