# Personal layer — infra

Applied on top of the repo's own `CLAUDE.md` (authoritative; this only adds
personal preferences). Universal VC rules come from the global `~/.claude/CLAUDE.md`.

## This repo

Honeycomb infrastructure: Terraform, Packer, Chef, Kubernetes/Argo, Kafka.
Changes here are high blast-radius and visible to the whole org.

## Guardrails

- Treat `terraform apply`, `packer build`, and any Argo/k8s mutation as
  confirm-first, visible-to-others actions — never run them without an explicit go.
- `terraform plan` and read-only inspection are fine to run freely.
- Never apply on my behalf; prefer plan review before proposing changes.

## Review history

Once a PR has review comments, do NOT force-push. Push additive commits instead.
- Before review: rewrite freely. After review starts: additive only.
