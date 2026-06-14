# Personal layer — hound

This is Austin's personal instruction layer, applied on top of the repo's own
`CLAUDE.md`. The repo's `CLAUDE.md` is authoritative for project conventions;
this file only adds personal workflow preferences. When the two conflict, the
repo wins.

## Version control

- Plain `git` only. If a `.jj/` directory appears, ignore it and flag it.
- Stacked, dependent PRs — squash-merge only, conventional-commit titles:
  1. Branch each change off the previous one (`git switch -c branch-2 branch-1`).
  2. Push all branches, open chained PRs with `--base` pointing at the parent branch.
  3. After a PR squash-merges, `git fetch && git rebase origin/main` the next
     branch and `gh pr edit <next> --base main`.
- Once a PR has review comments, do NOT force-push (it orphans inline comments).
  Push additive commits instead; squash-merge collapses them at merge time.
  Before review: rewrite freely. After review starts: additive only.

## Commits / PRs

- End commit messages with the Co-Authored-By trailer.
- Commit or push only when asked.
