# Personal layer — default

Austin's default instruction layer for personal / non-work repos, applied on
top of any repo-local `CLAUDE.md`. The repo wins on conflict.

## Defaults

- Plain `git` only. If a `.jj/` directory appears, ignore it and flag it.
- Conventional-commit titles. End commit messages with the Co-Authored-By trailer.
- Commit or push only when asked.
- No side files (NOTES.md, planning docs) unless asked.
