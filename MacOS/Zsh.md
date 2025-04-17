# Zsh

## Parameter expansion
```
GRADE="A" ; echo ${GRADE:+grade/}${GRADE:+}${GRADE:-none}   # grade/A
unset GRADE ; echo ${GRADE:+grade/}${GRADE:+}${GRADE:-none} # none
GRADE="" ; echo ${GRADE:+grade/}${GRADE:+}${GRADE:-none}    # none
```

(This doesn't work in Bash.)

