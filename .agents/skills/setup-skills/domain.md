# Domain Docs

How the engineering skills consume this repo's documentation.

## Where this fits

`CLAUDE.md` is the entry point — it's loaded automatically, before anything else,
in every session. It carries the descent instruction inline, because a rule that
governs how everything else is read can't depend on a pointer being followed.

This file holds the fuller rules: the reasoning behind the read path, and what to
do in the cases `CLAUDE.md` doesn't cover.

The division between the three files the agent may hold at once:

- **`CLAUDE.md`** — how to *work* here: commands, conventions, environment quirks,
  and the read path. Not what the system is.
- **`ARCHITECTURE.md`** — what the system *is*, and why it's shaped that way.
- **`CONTEXT.md`** — what the words *mean*.

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

- Issues, specs, and tickets — the work item you were given, not a survey of past ones
- `docs/research/` — dated notes; check the date before trusting them
- Git history

Never read these as background before starting. They describe how the project got
here; implementing correctly needs to know where *here is*.

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

Comments explaining *local* non-obvious logic are fine and unaffected — this rule
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
