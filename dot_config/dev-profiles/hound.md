# Personal layer — hound

Applied on top of the repo's own `CLAUDE.md` (which is authoritative; this only
adds personal workflow). Universal rules (plain git, conventional commits,
Co-Authored-By, commit-when-asked) come from the global `~/.claude/CLAUDE.md`.

## Stacked, dependent PRs (squash-merge only)

1. Branch each change off the previous one (`git switch -c branch-2 branch-1`).
2. Push all branches, open chained PRs with `--base` pointing at the parent branch.
3. After a PR squash-merges, `git fetch && git rebase origin/main` the next
   branch and `gh pr edit <next> --base main`.

## Review history

Once a PR has review comments, do NOT force-push (it orphans inline comments).
Push additive commits instead; squash-merge collapses them at merge time.
- Before review: rewrite freely (rebase, amend, force-push).
- After review starts: additive only.
