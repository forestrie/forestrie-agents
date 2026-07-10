#!/usr/bin/env bash
# PreToolUse hook for the "ExitPlanMode" tool.
#
# Blocks the transition from planning to execution when the session is
# working directly in a Forestrie repo's home clone. Plan execution must
# happen in a git worktree under <forestrie-parent>/.worktrees/, named per
# forestrie-agents/workflow/rules/branch-naming.md and each repo's
# AGENTS.md "Git worktrees" section.
set -euo pipefail

input="$(cat)"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"
[ -n "$cwd" ] || cwd="${CLAUDE_PROJECT_DIR:-$PWD}"

# Not a git repo — nothing to enforce.
repo_root="$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)" || exit 0

# Only applies to Forestrie org repos (origin remote under github.com/forestrie).
remote="$(git -C "$repo_root" remote get-url origin 2>/dev/null || true)"
case "$remote" in
  *github.com*/forestrie/*|*github.com:forestrie/*) ;;
  *) exit 0 ;;
esac

# Already inside a linked worktree — allow. A worktree's path lives under
# .worktrees/, and its git-dir differs from the common (home clone) git-dir.
case "$repo_root" in
  */.worktrees/*) exit 0 ;;
esac

git_dir="$(git -C "$repo_root" rev-parse --absolute-git-dir 2>/dev/null || true)"
common_dir="$(git -C "$repo_root" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"
if [ -n "$git_dir" ] && [ -n "$common_dir" ] && [ "$git_dir" != "$common_dir" ]; then
  exit 0
fi

repo_name="$(basename "$repo_root")"
parent_dir="$(dirname "$repo_root")"
example="${parent_dir}/.worktrees/${repo_name}-for-<issue-no>-<short-desc>"

reason="$(cat <<EOF
Plan execution must run in a git worktree, not the home clone (${repo_root}).

Naming scheme (forestrie-agents/workflow/rules/branch-naming.md):
  branch:   <user>/for-<issue-no>-<short-desc>   e.g. robin/for-167-onboard-design
  worktree: ${example}

Create it, then re-run the plan from inside that worktree:
  cd ${repo_root}
  git fetch origin
  git worktree add ${example} -b <user>/for-<issue-no>-<short-desc> origin/main
EOF
)"

jq -n --arg reason "$reason" '{decision: "deny", reason: $reason}' >&2
exit 2
