---
name: persist-plan
description: Persist an approved plan (plan-mode output, a Cursor plan file, or an ad hoc design discussion) as a plan document in forestrie/work.
when_to_use: Immediately after the user approves a plan, before implementation begins.
argument-hint: "[slug] [--dir]"
---

# persist-plan

Write an approved plan (Claude Code plan-mode output, a Cursor
`.cursor/plans/*.plan.md`, or an ad hoc design discussion) as a plan in
[forestrie/work](https://github.com/forestrie/work) `plans/`. Every
Forestrie plan lives there, whichever repos it changes. Layout, ids and
frontmatter follow [docs-layout](../../rules/docs-layout/SKILL.md).

Run it right after approval, before implementation.

Arguments: `$ARGUMENTS`

## 1. Get a forestrie/work worktree

Reuse the work worktree in the current task container if there is one;
otherwise `git -C <work clone> worktree add ../.worktrees/work-<slug> -b <branch> origin/main`.
Never write on the primary clone's `main`.

## 2. Allocate the id

Prefer `/plan-new <slug> [--dir]` (the personal `core:plan-new` skill),
run with the work worktree's `plans/` as root. Without it, allocate the
next ordinal for the current month against the remote:

```bash
git fetch -q origin
yymm=$(date +%y%m)
{ git ls-tree -r --name-only origin/main -- plans archive
  gh pr list -R forestrie/work --json files --jq '.[].files[].path'
} | grep -oE "plan-$yymm-[0-9]{2}" | sort -u | tail -1
```

Next is that ordinal plus one, or `01`. Never hand-pick.

## 3. Write the plan

`plans/plan-YYMM-NN-<slug>.md`:

```yaml
---
id: plan-YYMM-NN-<slug>
title: <title>
status: draft
created: <today>
updated: <today>
repos: [<every repo the plan changes>]
issues: [FOR-<n>]
refs: [<canon it serves, e.g. devdocs:ADR-0071, canopy:ARC-0004>]
---
```

Body: what the approved plan actually contains (outcomes, context,
decisions, open questions). This is persistence, not a rewrite. Drop
harness scaffolding (Cursor plan metadata, plan-mode preambles).

Always include a `## Rules check` section: each rule of the road the plan
touches (platform `P#`, repo rule ids), marked honoured or amendment
proposed with a link. An unjustified violation blocks the plan.

## 4. Directory plans

Stay flat unless the plan has two or more independently landable slices.
Then use `plan-YYMM-NN-<slug>/README.md` (the plan, with a slice table),
`01-<slug>.md`, `02-<slug>.md`, and optionally `handoff.md` and
`decisions.md`. Only `README.md` carries frontmatter.

## 5. Hand off

Commit, open the forestrie/work PR, and link the plan from the Linear
issue. Then continue with [plan-with-linear](../plan-with-linear/SKILL.md)
step 5. Code PRs link the plan; they do not carry it.

In Claude Code, the `require-worktree` hook
([harness/claude-code.md](../../../harness/claude-code.md#hooks)) blocks
leaving plan mode from a repo's primary clone.
