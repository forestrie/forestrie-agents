# go-task over ad-hoc shell scripts

**Scope:** Repos using go-task (`Taskfile.yml`, `taskfiles/*.yml`) — canopy,
univocity, forest-1, arbor (via _deps/taskfiles), and others.

- **Prefer** the repo's Taskfile and taskfiles for repeatable CI, local ops, and
  documented command entrypoints.
- **Do not** add new committed `.sh` files (or other shell-first automation
  entrypoints used as the primary way to run repo tasks) **without** explicit
  justification in the PR: why `task` is insufficient and what alternatives were
  considered.
- **Inline** `run: |` blocks in GitHub Actions YAML are fine for workflow
  orchestration; this rule targets **new committed scripts** intended as reusable
  automation surfaces.
