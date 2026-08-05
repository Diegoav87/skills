---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at seams agreed once up front — don't re-litigate the
seams on each slice.

Run typechecking regularly and the affected tests as you go; run the full test
suite once at the end.

## Review, scaled to the change

Match review effort to the size of the change — don't spin up subagents for a
one-liner:

- **Small, localized change** (a single slice, one or a few files): review it
  inline yourself — against the spec/ticket, and for obvious smells. No subagents.
- **Substantial change** (a whole ticket or spec, multiple modules): run the
  full `/code-review` — the two-axis Standards + Spec pass in parallel subagents.

## Do not touch git

When the work is done, **stop — do not run any git command**. No `git add`, no
`git commit`, no staging. Leave every change unstaged in the working tree so the
user can review it through the VS Code diff view. The user commits themselves
after reviewing. End by summarising what changed and where.
