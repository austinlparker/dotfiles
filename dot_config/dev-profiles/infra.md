# Personal layer — infra

Austin's personal instruction layer, applied on top of the repo's own
`CLAUDE.md`. The repo's `CLAUDE.md` is authoritative; this only adds personal
preferences. Repo wins on conflict.

## This repo

Honeycomb infrastructure: Terraform, Packer, Chef, Kubernetes/Argo, Kafka.
Changes here are high blast-radius and visible to the whole org.

## Guardrails

- Treat `terraform apply`, `packer build`, and any Argo/k8s mutation as
  confirm-first, visible-to-others actions — never run them without an explicit go.
- `terraform plan` and read-only inspection are fine to run freely.
- Prefer `plan` review before proposing changes; never apply on my behalf.

## Version control

- Plain `git` only. Conventional-commit titles. Co-Authored-By trailer on commits.
- Commit or push only when asked.
