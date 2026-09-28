# Issue tracker: GitHub

Issues and PRDs for this repo live as GitHub issues. Use the `gh` CLI for all operations.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --comments`, filtering comments by `jq` and also fetching labels.
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` with appropriate `--label` and `--state` filters.
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Infer the repo from `git remote -v` — `gh` does this automatically when run inside a clone.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.

## Parent work items

Read by `/implement` when it finishes a ticket, to keep the thing the ticket came
out of true.

A **parent** is any issue a ticket was carved out of — an epic, a spec, a PRD, a
tracking issue. On GitHub, find one by: the ticket's **sub-issue** link, a
`Part of #<n>` or `## Parent` line at the top of the ticket body, or a **task list**
in another issue that names this ticket.

Most parents carry their state as a **markdown checklist** of scope. Keep it true:

- A checked box names the ticket that delivered it — `- [x] … — #43`.
- An unchecked box names the ticket it's waiting on — `- [ ] … → #45` — or says
  outright that no ticket covers it yet.
- Where a parent and a ticket disagree, **the ticket wins**. Fix the parent.

A parent that tracks state some other way — a status field, a progress table, a
"Remaining" section — gets the same treatment in its own shape. A parent that's pure
prose has no state to move; leave it alone.

Parents are **not** closed by an agent, same as tickets.

## Blocking and sub-issues

Used by `/to-tickets` to wire tickets together on GitHub.

- **Sub-issue**: link a child ticket to its parent as a GitHub sub-issue (`gh api` on the sub-issues endpoint). Where sub-issues aren't enabled, add the child to a task list in the parent body and put `Part of #<parent>` at the top of the child body.
- **Blocking**: GitHub's **native issue dependencies** — the canonical, UI-visible representation. Add an edge with `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`, where `<blocker-db-id>` is the blocker's numeric **database id** (`gh api repos/<owner>/<repo>/issues/<n> --jq .id`, _not_ the `#number` or `node_id`). GitHub reports `issue_dependencies_summary.blocked_by` (open blockers only — the live gate). Where dependencies aren't available, fall back to a `Blocked by: #<n>, #<n>` line at the top of the child body. A ticket is unblocked when every blocker is closed.
- **Frontier**: the tickets you can start now are the open ones with no open blocker (`issue_dependencies_summary.blocked_by == 0`). Work those first, one at a time with `/implement`.
