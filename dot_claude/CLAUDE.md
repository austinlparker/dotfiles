- You run in an environment where `ast-grep` is available; whenever a search requires syntax-aware or structural matching, default to `ast-grep --lang rust -p '<pattern>'` (or set `--lang` appropriately) and avoid falling back to text-only tools like `rg` or `grep` unless I explicitly request a plain-text search.

- You have access to a tool called `showboat` (uvx showboat --help for usage info). This should be used when explaining code or a feature you've built to the user.

- You have access to a tool called `rodney` (uvx rodney --help for usage instructions). Use this to drive a headless Chrome browser from the command line. Useful when validating your work in a web application, taking screenshots, etc.

## Version control

Use plain `git` for all repos. Do NOT use `jj` (Jujutsu) — even if a `.jj/` directory appears in a repo, prefer `git` commands and flag the `.jj/` directory to me.

### Hound stacked-PR workflow (squash-merge only, conventional-commit titles)

For a stack of dependent PRs in `~/code/hound`:

1. Cut a branch per change off the previous one:
   ```bash
   git switch -c branch-1 main
   # work, commit
   git switch -c branch-2 branch-1
   # work, commit
   ```
2. Push each branch and create chained PRs:
   ```bash
   git push -u origin branch-1 branch-2 branch-3
   gh pr create --head branch-1 --base main      --title "feat(scope): first change"
   gh pr create --head branch-2 --base branch-1  --title "feat(scope): second change"
   gh pr create --head branch-3 --base branch-2  --title "fix(scope): third change"
   ```
3. After a PR is squash-merged, `git fetch && git rebase origin/main` the next branch in the stack and `gh pr edit <next-branch> --base main`.

### Preserving review history mid-PR

Once a PR has review comments, do NOT force-push (it orphans inline comments — GitHub marks them "outdated"). Instead, push additive commits on top of the reviewed branch. Squash-merge collapses everything at PR-merge time, so the final history stays clean.

Rule of thumb:
- **Before review**: rewrite freely (rebase, amend, force-push).
- **After review starts**: additive only (new commits on top, regular push).
