---
name: plan-with-linear
description: Plan a Forestrie change against a Linear FOR issue and grill the plan against existing ADRs, ARCs, and domain language.
when_to_use: The user wants to plan a feature or fix, mentions a FOR issue, or says "plan this with Linear".
argument-hint: "[FOR-123 | description of the work]"
---

# plan-with-linear

Plan a change with Linear issue tracking and a grilling session against existing
docs and domain language.


Arguments: `$ARGUMENTS`

## 1. Resolve or create Linear issue

Team: **FOR** (Forestrie). Workspace: **forestrie**.

Before the first Linear MCP call, verify identity per linear-mcp-forestrie rules
(`get_user` with `"me"` → `robinbryce@gmail.com`, team **FOR**).

- Search Linear for an existing issue matching the work
- If none exists, create one on team **Forestrie (`FOR`)** with:
  - Title: concise summary
  - Description: problem in one short paragraph
  - Acceptance criteria: testable outcomes (behaviour, tests, observable fixes)

Record the issue id (e.g. `FOR-1234`).

## 2. Load minimal context

| Source | When |
|--------|------|
| The matching `arc-*` glossary skill | Domain terms |
| Repo `AGENTS.md` or `forest/agents/AGENTS.md` | Repo-specific routes |
| [protocol glossary.md](https://github.com/forestrie/protocol/blob/main/glossary.md) | Shared vocabulary |
| Relevant plan or ARC | If user named a path |

Do **not** bulk-load devdocs arc/adr trees or full repo doc trees.

## 3. Run grill-with-docs

Follow [grill-with-docs](../../../vendored/matt-skills/skills/engineering/grill-with-docs/SKILL.md):

- Interview relentlessly; one question at a time with recommended answers
- Challenge terms against the [protocol glossary.md](https://github.com/forestrie/protocol/blob/main/glossary.md) and the `arc-*` glossary skill
- Update repo `CONTEXT.md` or glossary docs lazily when terms crystallise
- Offer ADRs only when hard to reverse, surprising, and trade-off driven — use
  [docs-layout](../../rules/docs-layout/SKILL.md) for the doc itself, **not** the
  vendored `ADR-FORMAT.md` the skill links to

Where things go (see [docs-layout](../../rules/docs-layout/SKILL.md#canon-and-work)):

- The implementation plan: [forestrie/work](https://github.com/forestrie/work) `plans/`, whichever repos it changes
- ADRs and ARCs: `docs/adr/`, `docs/arc/` in the repo they affect; devdocs when cross-repo
- Current-state changes: the named living doc for the area, not a new context file

## 4. Output

Once the user approves the plan, run
[persist-plan](../persist-plan/SKILL.md) to write it into forestrie/work
`plans/` per [docs-layout](../../rules/docs-layout/SKILL.md), with a
`## Rules check` section. It allocates the id with
`dox new plan <slug> [--dir]`; never hand-pick one. Then produce:

1. **Linear issue** updated with link to the persisted plan and acceptance criteria
2. **Behaviours to test** list (not implementation steps) for TDD handoff

## 5. Handoff to implementation

When the user approves the plan:

- Branch name: `robin/for-<issue-no>-<short-desc>` — see [branch-naming](../../rules/branch-naming/SKILL.md)
- Create worktree per repo `AGENTS.md` (`../.worktrees/<repo>-for-<issue>-<slug>`)
- Invoke [tdd](../../../vendored/matt-skills/skills/engineering/tdd/SKILL.md) for vertical slices
- Run [pre-commit-checks](../pre-commit-checks/SKILL.md) before commit

Do not implement until the user confirms the plan.
