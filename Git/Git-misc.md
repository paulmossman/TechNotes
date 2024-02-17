# Git


# Initizalize a new repository
```bash
git init
```
Call it from inside the folder that's the root of the new repo.

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

Effectively `git merge -s theirs <their branch>`:
```bash
git checkout -b tmp origin/develop
git merge -s ours main
git checkout master
git checkout -b fix-merge-conflicts origin/main
git merge tmp
git push -u origin fix-merge-conflicts
# Then PR fix-merge-conflicts -> main
git branch -D tmp
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

## Get the repo's URL
```bash
git remote -v
```

## Three Git Configurations that Should Be the Default
https://spin.atomicobject.com/2020/05/05/git-configurations-default/