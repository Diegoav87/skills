# Domain Docs

How to read this repo's documentation. The rules for writing it live in the
`domain-modeling` skill.

## The three files

- **`CLAUDE.md`** — how to _work_ here: commands, conventions, environment quirks,
  and the read path below.
- **`ARCHITECTURE.md`** — what the system _is_, and why it's shaped that way.
- **`CONTEXT.md`** — what the words _mean_.

## The read path

The same pair repeats at every level of the repo: a `CONTEXT.md` (the vocabulary
that level introduces) and an `ARCHITECTURE.md` (what that level is, why, and which
children it has). Reading is a **descent**: start at the root and walk down only
the branch your task touches.

1. Read the root `CONTEXT.md` and `ARCHITECTURE.md`. Always.
2. The `## Modules` list names this level's children in one line each, written so
   you can rule one out **without opening it**. Pick the child your task touches.
3. Check the `### Edges` at this level. If an edge shows your work reaching into a
   sibling — a shared type, an event, a call signature, an HTTP route — that
   sibling is part of your task and gets read too.
4. Descend into the chosen children and repeat from step 1.
5. Stop at a level with no children, or no files of its own.

A task in `auth` reads root → `auth`, and nothing about `payments` or `posts`
beyond their one-line description and any edge that touches them. A level with no
`CONTEXT.md` or no `ARCHITECTURE.md` had nothing of its own to say; proceed
silently, don't suggest creating files. If you can't tell which branch owns the
task, ask rather than reading everything.

Everything in the descent is present tense and trusted without checking its age.
Everything else is opened **only on demand**, when the task needs it and you can
name why, never as background:

- **Reference documents** — the register in `CLAUDE.md`. Open one when its "open
  it when" trigger fires. For anything already built, the code and the per-level
  `ARCHITECTURE.md` win; a reference document that contradicts them is out of date
  and gets fixed, not worked around.
- **`docs/research/`** — dated notes, never updated. Check the date and verify
  against reality before acting on one.
- **Issues, specs, and tickets** — the work item you were given, not a survey.
- **Git history.**

## Use the glossary's vocabulary

When your output names a domain concept — an issue title, a refactor proposal, a
hypothesis, a test name — use the term as `CONTEXT.md` defines it. If the concept
you need isn't there, either you're inventing language the project doesn't use, or
there's a gap to note for `/domain-modeling`.

## Keep documentation out of the code

Code does not reference architecture docs: no `// see ARCHITECTURE.md`, no comment
restating a decision the docs record. Comments explain the local logic beside them
and nothing else. The pointer runs one way: `ARCHITECTURE.md` names the module a
decision governs, and nothing in the code points back.

## When your work contradicts the architecture

If what you're about to build conflicts with `ARCHITECTURE.md`, stop and say so
before building:

> _This contradicts the port boundary in ARCHITECTURE.md — worth reopening because…_

If the user confirms the change, overwrite `ARCHITECTURE.md` to state the new truth
in the same change. The old decision is replaced, not marked superseded; the
history of the reversal lives in the commit and the issue thread.
