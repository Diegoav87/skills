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

## Leave the documentation true

Two checks before you finish. Both are cheap and both prevent the slow rot that
makes future sessions expensive.

**Did this change make `ARCHITECTURE.md` false?** If the shape of the system moved
— a new module, a replaced adapter, a decision reversed — overwrite the affected
lines so the file states the new truth, and delete what stopped being true. Don't
mark anything superseded, don't keep the old wording alongside the new. If the
change didn't move the shape of the system, touch nothing: most tickets shouldn't.

Update it at the **level that owns the fact** — the module's own file for something
local to that module, the parent's for something that spans its children. Don't
push a module-local detail up to the root, and don't restate a root decision in a
module.

Two updates are easy to miss and both live in the **parent**:

- **The module list**, when you added or removed a module.
- **The edges**, when you changed something that crosses between modules — a shared
  type, an event shape, a call signature, an HTTP route. That section is what the
  next agent relies on to work safely *without* reading your module.

**Did you leave documentation references in the code?** Code doesn't point at
project docs, and doesn't restate decisions those docs already record. Comments
explaining local non-obvious logic are fine — cross-references to specs, tickets,
or `ARCHITECTURE.md` are not.

## Retire the ticket

Work items are scaffolding, not record. Once the work is done, the ticket has no
further readers — and a stale ticket left lying around is something a future
session will read and believe.

- **Local files** under `.scratch/` → delete the ticket file. `.scratch/` should be
  gitignored; nothing there is a record of anything.
- **A real tracker** → leave the issue for the user to close. Don't close it
  yourself.

Say in your summary which ticket you retired.

## Do not touch git

When the work is done, **stop — do not run any git command**. No `git add`, no
`git commit`, no staging. Leave every change unstaged in the working tree so the
user can review it through the VS Code diff view. The user commits themselves
after reviewing. End by summarising what changed and where.
