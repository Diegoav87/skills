# Domain Docs

How the engineering skills consume this repo's documentation.

## Where this fits

`CLAUDE.md` is the entry point — it's loaded automatically, before anything else,
in every session. It carries the descent instruction inline, because a rule that
governs how everything else is read can't depend on a pointer being followed.

This file holds the fuller rules: the reasoning behind the read path, and what to
do in the cases `CLAUDE.md` doesn't cover.

The division between the three files the agent may hold at once:

- **`CLAUDE.md`** — how to _work_ here: commands, conventions, environment quirks,
  and the read path. Not what the system is.
- **`ARCHITECTURE.md`** — what the system _is_, and why it's shaped that way.
- **`CONTEXT.md`** — what the words _mean_.

A fact in two of them is a fact that will be updated in one. `CLAUDE.md` in
particular attracts architecture description, because it's always loaded and so
feels like the safe place to put things — that instinct is what makes it the file
most likely to go stale.

## The read path

Documentation repeats the same pair at every level of the repo: a `CONTEXT.md`
(the vocabulary that level introduces) and an `ARCHITECTURE.md` (what that level is,
why it's shaped that way, and which children it has).

So reading is a **descent**, not a survey. Start at the root and walk down only the
branch your task touches:

1. Read the root `CONTEXT.md` and `ARCHITECTURE.md`. Always — this is the general
   context every task needs.
2. The `## Modules` list names this level's children in one line each, written so
   you can rule one out **without opening it**. Pick the child your task touches.
3. Check the `### Edges` at this level. If an edge shows your work reaching into a
   sibling — a shared type, an event, a call signature, an HTTP route — that
   sibling is part of your task and gets read too. A ticket filed under `auth` that
   changes something `posts` consumes is an `auth` + `posts` task.
4. Descend into the chosen children and repeat from step 1, accumulating vocabulary
   and decisions as you go.
5. Stop when you reach a level with no children, or no files of its own.

**Read only the branch.** A task in `auth` reads root → `auth`, and nothing about
`payments` or `posts` beyond the one-line description and any edge that touches it.
The cost is proportional to the depth of the tree, not the size of the repo — a
fifty-module system costs the same as a five-module one.

Levels state only what they add, so nothing you read is redundant and nothing you
skip was inherited. If a level has no `CONTEXT.md` or no `ARCHITECTURE.md`, it
simply had nothing of its own to say — that's normal, not a gap. **Proceed
silently**: don't flag it, don't suggest creating files upfront. `/domain-modeling`
creates them when there's something real to write.

If you can't tell which branch owns the task, ask rather than reading everything.

Everything in the descent is present-tense, and therefore trustworthy without
checking its age. Everything else is opened **only on demand**, when the current task actually needs
it and you can name why:

- **Reference documents** — the register in `CLAUDE.md`; open one when its trigger fires
- Issues, specs, and tickets — the work item you were given, not a survey of past ones
- `docs/research/` — dated notes; check the date before trusting them
- Git history

Never read these as background before starting. They describe how the project got
here; implementing correctly needs to know where _here is_.

## Reference documents

> Optional. A project of any size rarely needs more than
> two or three. If this project has none, delete this section and the register in
> `CLAUDE.md` — an empty register is one more thing to read that says nothing.

Some facts are true of the whole system and belong to no single level: the complete
database schema, the shape of parts not built yet, infrastructure and deployment,
or a cross-cutting inventory whose value is that it's in one place. They can't go in
the descent — `ARCHITECTURE.md` is per-level and present-only, and a file every
session pays for can't carry the whole map. So they live in `docs/`, outside the
descent, and are registered in `CLAUDE.md`.

**Each one carries two triggers, and both are load-bearing:**

- **When to read it.** Written so you can rule the document out _without opening it_
  — the same discipline the `## Modules` list already demands. A document you can't
  rule out is one you'll either read every time (expensive) or never (useless).
- **What makes it false.** A concrete, checkable event — "the schema changed", not
  "things moved". `Keep the docs up to date` is the instruction everyone writes and
  nobody follows; a trigger you can answer yes or no to at the end of a change is
  the only version that survives.

**A document without both triggers doesn't belong in the register.** That's the
alarm, not a formatting nit: it means nobody knows when to read it or what makes it
wrong, so it will rot and be believed anyway.

### The two contracts

They are not the same kind of thing and must not share a rule:

- **Maintained reference** — present tense, updated with the change that moves it,
  trusted without checking its age.
- **Dated note** — `docs/research/`. **Never updated.** Read with its date in hand
  and verified against reality before acting on it. Rewriting one to keep it current
  destroys the only thing that made it safe: knowing what it was true of, and when.

Flatten these into one bucket and eventually someone implements against research
into a provider that changed its API a year ago.

### The boundary

Reference documents cover **what is and what is planned to be** — nothing else.

- Work that's going to be built → the issue tracker, not here.
- How the project got here → git and the issue threads, not here.

That boundary is the whole safeguard. Without it `docs/` grows back into the pile
of stale planning that this structure exists to prevent, and stale context is worse
than absent context, because the agent trusts it.

### Precedence

For anything already built, the code and the per-level `ARCHITECTURE.md` win. A
reference document that contradicts them is out of date — fix it, don't work around
it and don't note the discrepancy in passing.

## What "minimum context" means

The goal is the least context that still produces correct work — not the most
context available. Two failure modes, and the second is the expensive one:

- Too little: the agent invents vocabulary, re-decides settled questions, or
  contradicts the existing shape of the system.
- Too much: the agent burns its budget on decisions that were reversed, plans that
  were dropped, and specs that were overtaken — and then implements against a state
  of the world that no longer exists. Stale context is worse than absent context,
  because the agent trusts it.

`ARCHITECTURE.md` and `CONTEXT.md` are kept current-only precisely so that
everything in the read path can be trusted without checking its age.

## Use the glossary's vocabulary

When your output names a domain concept — an issue title, a refactor proposal, a
hypothesis, a test name — use the term as `CONTEXT.md` defines it. Don't drift to
synonyms the glossary explicitly avoids.

If the concept you need isn't in the glossary, that's a signal: either you're
inventing language the project doesn't use (reconsider), or there's a real gap
(note it for `/domain-modeling`).

## Keep documentation out of the code

Code does not reference architecture docs. No `// see ADR-0004`, no comment
restating a decision that `ARCHITECTURE.md` already records.

Both directions rot, for different reasons: a comment that restates a decision is
a second copy that silently drifts, and a comment that merely points at a document
becomes a dangling reference the moment that document is rewritten. Either way the
code — which moves under every refactor — becomes something you have to keep in
sync with prose.

The pointer runs one way only: `ARCHITECTURE.md` names the module or area a
decision governs. Nothing in the code points back.

Comments explaining _local_ non-obvious logic are fine and unaffected — this rule
is about cross-references to project documentation.

## When your work contradicts the architecture

If what you're about to build conflicts with `ARCHITECTURE.md`, stop and surface it
rather than silently overriding:

> _This contradicts the port boundary in ARCHITECTURE.md — worth reopening because…_

If the user confirms the change, `ARCHITECTURE.md` is **overwritten** to state the
new truth, in the same change. The old decision is not marked superseded and not
kept alongside — it's replaced. The history of the reversal lives in the commit and
the issue thread.

Leaving the file stale is the failure that compounds: every future session pays to
read it and then gets it wrong.
