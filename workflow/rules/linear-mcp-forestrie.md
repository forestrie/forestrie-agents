# Linear MCP (Forestrie repos)

> **Mechanism preference:** Prefer the **direct GraphQL API** keyed by
> `LINEAR_API_KEY` (see "Direct API" below) over MCP. On setups that define a
> personal `linear-direct-api` rule, that rule takes precedence and the MCP
> identity checks here apply only as a fallback. Use MCP only when the direct
> API is unavailable.

Applies when using the **Linear MCP server** for work in Forestrie org repos:

- `canopy`, `arbor`, `arbor-flux`, `forest-1`, `univocity`, `univocity-tools`,
  `mandate`, `devdocs`, `forestrie-agents`
- any other repository under `github.com/forestrie/*`

## Required identity

| Setting | Expected value |
|---------|----------------|
| Login user | `robinbryce@gmail.com` |
| Workspace | `forestrie` (Linear org/team **Forestrie**, key `FOR`) |

## Before the first Linear MCP call

1. Confirm the active workspace is a Forestrie repository (see list above, or
   a `github.com/forestrie/*` git remote).
2. Call **`get_user`** with `query: "me"`.
3. Verify **`email`** is exactly **`robinbryce@gmail.com`**.
4. Verify the user belongs to the **Forestrie** workspace (team key **`FOR`**).

If either check fails, **stop** — do not create, update, or query Linear issues,
projects, or documents.

## Wrong account or workspace

Tell the user Linear MCP is authenticated as the wrong user or workspace. Ask
them to re-authenticate in Cursor (**Settings → MCP → Linear**) as
**`robinbryce@gmail.com`** on the **`forestrie`** workspace, then retry after
calling **`get_user`** with `"me"` again.

Do not guess issue IDs, team keys, or project names from another workspace.

## Direct API (non-MCP)

For shell scripts and GraphQL via `LINEAR_API_KEY`, load from
`~/Dev/personal/forestrie/.envrc` when present. MCP OAuth is separate.
