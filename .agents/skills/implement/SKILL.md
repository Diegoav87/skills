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

Three checks before you finish. All are cheap and all prevent the slow rot that
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

**Did this change fire a reference document's write trigger?** `CLAUDE.md` registers
the project's reference documents, and each one states what makes it false — a
schema change, a new module, an infrastructure decision. Walk that register and
update every document whose trigger fired, **in this change**, not in a follow-up.

Deferring is what makes these documents dangerous rather than useful: a schema
diagram that lost one migration is worse than no diagram, because the next agent
reads it and believes it. If a document contradicts what you just built and you
can't tell which is right, say so in your summary rather than guessing.

Documents in `docs/research/` are dated notes and are **never** updated — leave them
exactly as they are, even when they've been overtaken.

If the project registers no reference documents, this check is a no-op. Skip it
silently.

**Did you leave documentation references in the code?** Code doesn't point at
project docs, and doesn't restate decisions those docs already record. Comments
explaining local non-obvious logic are fine — cross-references to specs, tickets,
`ARCHITECTURE.md`, or a reference document are not.

## Retire the ticket

Work items are scaffolding, not record. Once the work is done, the ticket has no
further readers — and a stale ticket left lying around is something a future
session will read and believe.

- **Local files** under `.scratch/` → delete the ticket file. `.scratch/` should be
  gitignored; nothing there is a record of anything.
- **A real tracker** → leave the issue for the user to close. Don't close it
  yourself. Work that looks done can still come back — a bug, a review comment, a
  follow-up in the same session — and closing is the user's call.

## Move the parent

Tickets are usually carved out of something bigger: an epic, a spec, a PRD, a
tracking issue. That parent outlives every ticket under it, and it's the piece that
rots — the ticket gets done, the parent doesn't move, and a later session reads a
parent full of unchecked scope and concludes none of it is built.

So when the work is done, **update the parent in the same session**:

- Only if the ticket **has** a parent, and only if that parent **carries state** — a
  checklist, a scope list, a status field, a progress table. A parent that's pure
  prose has nothing to move. No parent, nothing to do. Skip silently either way.
- Move the state to match what you delivered, and **name the ticket on the line you
  move**, so the parent records what delivered it rather than just that something
  did. Follow the shape the parent already uses; don't impose a new one.
- The tracker file (`docs/agents/issue-tracker.md` or equivalent) says how parents
  are represented here and how to find one. Read it before guessing.

The parent moves when the **work** is done, not when the ticket closes — the ticket
stays open for the user, and nobody will be around at closing time to do this. If
review sends the work back, the same follow-up that fixes the code fixes the parent.

**Say exactly what you moved in the parent, in your summary.** The parent lives in
the tracker, not the working tree: the user can't see it in the diff and can't undo
it by discarding changes. Anything you changed there has to be visible in what you
report, or it's a silent edit.

Say in your summary which ticket you retired.

## Do not touch git

When the work is done, **stop — do not run any git command**. No `git add`, no
`git commit`, no staging. Leave every change unstaged in the working tree so the
user can review it through the VS Code diff view. The user commits themselves
after reviewing. End by summarising what changed and where.
