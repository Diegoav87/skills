# Issue tracker: GitHub

Specs and tickets for this repo live as GitHub issues. Use the `gh` CLI for every operation; it infers the repo from `git remote -v`.

## Operations

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies. This is what "publish to the issue tracker" means.
- **Read an issue**: `gh issue view <number> --json number,title,body,labels,comments`. This is what "fetch the ticket" means.
- **List issues**: `gh issue list --state open --label <label> --json number,title,labels`.
- **Comment**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`
- **Make an issue a sub-issue of a parent**: `gh issue create --parent <parent> ...`, or `gh issue edit <parent> --add-sub-issue <child>` afterwards (`gh` 2.94+). Older `gh`: `gh api --method POST repos/<owner>/<repo>/issues/<parent>/sub_issues -F sub_issue_id=<child-db-id>`. Without sub-issues, add the child to a task list in the parent body and put `Part of #<parent>` at the top of the child body.
- **Mark an issue blocked by another**: `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`. A database id comes from `gh api repos/<owner>/<repo>/issues/<n> --jq .id`, never the `#number`. Where dependencies aren't available, put `Blocked by: #<n>, #<n>` at the top of the child body.
- **Find the frontier**: the open tickets with no open blocker (`issue_dependencies_summary.blocked_by == 0` in `gh api repos/<owner>/<repo>/issues/<n>`, or every issue in the `Blocked by` line closed).

## Labels

Four **state** labels say where an issue is in the flow. Each is applied and removed by a skill, so they never need updating by hand. Two **kind** labels say what an issue is and never change. Edit the strings if this tracker uses others.

| Label | Kind | Applied by | Removed by |
|---|---|---|---|
| `needs-grilling` | state | the user, filing a raw idea; `/grilling`, pausing on a questionnaire | `/to-spec`, when it publishes the spec |
| `ready-for-agent` | state | `/to-spec`, `/to-tickets` | `/implement`, when it starts the ticket |
| `in-progress` | state | `/implement`, when it starts | `/implement`, when the work is done |
| `needs-review` | state | `/implement`, when the work is done | the user, by closing the ticket |
| `bug` | kind | whoever files it | never |
| `spec` | kind | `/to-spec`, on the spec issue | never |

Useful queries:

- Ideas waiting for an interview: `gh issue list --label needs-grilling`
- What an agent can start now: `gh issue list --label ready-for-agent`, minus the ones with open blockers
- What is waiting for the user's review: `gh issue list --label needs-review`
- The roadmap without the tickets: `gh issue list --label spec`

## Parent work items

A **parent** is the issue a ticket was carved out of: a spec, an epic, a tracking issue. Find it through the ticket's sub-issue link, a `## Parent` section or `Part of #<n>` line in the ticket body, or a task list in another issue that names the ticket.

When a parent carries its scope as a markdown checklist, keep it true:

- A checked box names the ticket that delivered it: `- [x] … (#43)`.
- An unchecked box names the ticket it's waiting on, `- [ ] … (→ #45)`, or says no ticket covers it yet.
- Where a parent and a ticket disagree, the ticket wins. Fix the parent.

A parent that tracks state some other way (a status field, a progress table) gets the same treatment in its own shape. Parents are never closed by an agent.
