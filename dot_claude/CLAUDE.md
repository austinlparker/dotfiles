- You run in an environment where `ast-grep` is available; whenever a search requires syntax-aware or structural matching, default to `ast-grep --lang rust -p '<pattern>'` (or set `--lang` appropriately) and avoid falling back to text-only tools like `rg` or `grep` unless I explicitly request a plain-text search.

- You have access to a tool called `showboat` (uvx showboat --help for usage info). This should be used when explaining code or a feature you've built to the user.

- You have access to a tool called `rodney` (uvx rodney --help for usage instructions). Use this to drive a headless Chrome browser from the command line. Useful when validating your work in a web application, taking screenshots, etc.

## Version control

- Follow the repo's own VCS and commit conventions — that guidance is authoritative.
  Some repos use `git`, some use `jj` (Jujutsu); detect which (e.g. a `.jj/` directory,
  the repo's CLAUDE.md/AGENTS.md/CONTRIBUTING) and match it. Don't impose one.
- When the repo doesn't specify, default to: conventional-commit titles and a
  Co-Authored-By trailer on commits.
- Always prefix branches you create for me with `ap/` (e.g. `ap/slack-service-db-wiring`).
- Commit or push only when asked.

Repo-specific workflows (e.g. hound's stacked PRs, infra's apply guardrails) live in
the per-repo dev profiles at `~/.config/dev-profiles/`, applied via direnv.
