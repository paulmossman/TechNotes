#!/bin/bash

SCRIPT=`realpath "$0"`
SCRIPTPATH="${SCRIPT%/*}"
    
# Limitation: git mv __ __ is not handled. 
#     e.g.        renamed:    Git.md -> Git-misc.md

# Note: .gitignore'd files are *not* included in the backup (a feature), except...
# Limitation: .gitignore'd files in new directories *are* included in the backup.


BACKUP_DIR="${SCRIPTPATH}/backups/"`date '+%Y-%m-%d-%H%M'`

pushd /Users/paul/Git-repos/TechNotes > /dev/null

# Modified files.
MODIFIED_FILES=`git status | grep "modified:" | cut -f2 -d:`

# Are there Untracked files and/or directories?
UNTRACKED_CRUMB="to include in what will be committed"
UNTRACKED_FILES_AND_DIRS=`git status | sed -n -e '/'"${UNTRACKED_CRUMB}"'/,$p' | grep -v "${UNTRACKED_CRUMB}" | grep -v "no changes added to commit" | grep -v "nothing added to commit but untracked files present"`

# IFS --> Internal Field Separator
while IFS= read -r fileOrDir; do
   # Remove leading and trailing whitespace.  (MacOS compatible.)
   fileOrDir=`echo ${fileOrDir} | sed -E 's/[ '$'\t'']+$//'`

   if [ -d "${fileOrDir}" ]; then
      # A directory with 1+ files.
      UNTRACKED_FILES_IN_DIR=`find "${fileOrDir}" -type f`
      while IFS= read -r file; do
         UNTRACKED_FILES="${UNTRACKED_FILES}
${file}"
      done <<< "$UNTRACKED_FILES_IN_DIR"
   else
      # A single file.
      UNTRACKED_FILES="${UNTRACKED_FILES}
${fileOrDir}"
   fi   
done <<< "$UNTRACKED_FILES_AND_DIRS"

FILES="${UNTRACKED_FILES}"
while IFS= read -r file; do
   # Remove leading and trailing whitespace.  (MacOS compatible.)
   file=`echo ${file} | sed -E 's/[ '$'\t'']+$//'`

   if [ -n "$file" ]; then
      FILES="${FILES}
${file}"
   fi
done <<< "$MODIFIED_FILES"

if [ "$FILES" == "/" ]; then
   echo No modified or untracked files.
   # TODO: This doesn't work anymore.  It's a single space, or a newline???
   # if [ -z "$FILES" ] --> Also doesn't work.
else
   mkdir -p "${BACKUP_DIR}"
   while IFS= read -r file; do
      if [ -n "$file" ]; then
         path=`dirname "${file}"`
         mkdir -p "${BACKUP_DIR}/${path}"
         cp "${file}" "${BACKUP_DIR}/${path}"
      fi
   done <<< "$FILES"
   git branch --show-current > "${BACKUP_DIR}/BRANCH.txt"
   echo Modified and untracked files copied to: ${BACKUP_DIR}
fi
