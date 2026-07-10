# do-next-issue-in-worktree (seed)

> Status: **seed** — intent captured, not yet drafted into a command.

Use git worktrees to execute the next issue in the argument Linear project:
pick the next actionable `FOR-*` issue, create a worktree/branch per
[branch-naming](../../workflow/rules/branch-naming.md), and run the
implementation there (blocked outside a worktree by the
[require-worktree hook](../../harness/hooks/require-worktree.sh)).

Relationship: execution counterpart to
[linear-project-plan](./linear-project-plan.md), which produces the plan the
project's issues are worked from.
