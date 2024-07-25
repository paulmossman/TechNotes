**<span style="font-size:3em;color:black">GitLab</span>**
***


# GitLab-specific

References: https://docs.gitlab.com/ee/user/markdown.html#gitlab-specific-references
e.g.
- Issues: `#45`, `namespace/project#45`
    - Add `+` to include the title, e.g. `#6+`.
- Merge request: `!50`, `namespace/project!50`

Actions: https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically
e.g.
```
Closes #45
Related to #17
Related to !50
Related to namespace/project!50
```

# Pipeline

In `yml` file, if a top-level item:
- starts with a `.` then it's a re-usable chunk; otherwise
- a Job.

## CI/CD Catalog 
"Make the reusing pipeline configurations easier and more efficient"

https://docs.gitlab.com/ee/ci/components/#cicd-catalog

# REST API

[Documentation](https://docs.gitlab.com/ee/api/rest/)

## Get raw file from repository

See [here](https://docs.gitlab.com/ee/api/repository_files.html#get-raw-file-from-repository), but note that the `file_path` and `id` values must be URL-encoded!  i.e. `/` is replaced with `%2F`, and `.` is replaced with `%2E`.


# `glab` CLI

Open source: https://gitlab.com/gitlab-org/cli/

https://docs.gitlab.com/ee/editor_extensions/gitlab_cli/

`glab auth login`

## Clone many repositories
```bash
glab repo clone --group "<group ID>" --preserve-namespace --with-shared --paginate --archived=false 
```

`preserve-namespace` to get sub-directories reflecting the namespace structure.
`with-shared` to include those shared into the group
`paginate` to get them all, instead of only the first "page" (whose size is configurable)

## Create an MR
```bash
glab mr create \
    --assignee ${ASSIGNEE_ID} \
    --reviewer ${REVIEWER_ID} \
    --source-branch ${BRANCH_NAME} \
    --remove-source-branch \
    --squash-before-merge \
    --fill \
    --yes
```

## View Project Issues
```bash
glab issue list
```

Table form, interactive.  But will offer boards in the parent namespace also.
```bash
glab issue board view
```