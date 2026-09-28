---
name: domain-modeling
description: Build and sharpen a project's domain model. Use when discussing codebase terminology, or when writing or editing a CONTEXT.md or an ARCHITECTURE.md.
---

# Domain Modeling

Actively build and sharpen the project's domain model as you design — challenging
terms, inventing edge-case scenarios, and writing the glossary and the architecture
record down the moment they crystallise. (Merely *reading* those files is not this
skill — that's a one-line habit any skill can do. This skill is for when you're
changing the model, not just consuming it.)

## The documents

Everything here is written in the **present tense**, and between them these files
are the entire default read path — so they stay small on purpose.

Two documents do the work, and the **same pair repeats at every level** of the
repo:

- **`CONTEXT.md`** — the vocabulary this level introduces
- **`ARCHITECTURE.md`** — what this level is, why it's shaped that way, and which
  children it has

Depth follows the repo. Nothing else changes.

**A standalone API with three modules** — two levels:

```
/
├── CONTEXT.md              ← User, Account, Money
├── ARCHITECTURE.md         ← the system; lists auth, payments, posts + their edges
├── auth/
│   ├── CONTEXT.md          ← Session, Claim — only what auth adds
│   └── ARCHITECTURE.md     ← only auth's own shape
├── payments/…
└── posts/…
```

**A monorepo** — the same thing with one more level on top:

```
/
├── CONTEXT.md
├── ARCHITECTURE.md         ← the product; lists api, web, mobile + their edges
└── apps/
    ├── api/
    │   ├── CONTEXT.md
    │   ├── ARCHITECTURE.md ← the API; lists auth, payments, posts + their edges
    │   ├── auth/…
    │   └── payments/…
    └── web/…
```

Create files lazily, and only where a level has something of its own to say. A
module with no special vocabulary gets no `CONTEXT.md`; one whose shape is obvious
from its code gets no `ARCHITECTURE.md` — it still appears in its parent's module
list, which is all routing needs. Files created out of symmetry rather than need are
how this turns into ceremony.

Project history — what the plan used to be, what got abandoned, why a decision was
revisited — lives in the issue tracker and in git. It never lives in these two
files, and an agent about to implement never needs it.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in
`CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X,
but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term.
"You're saying 'account' — do you mean the Customer or the User? Those are
different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific
scenarios. Invent scenarios that probe edge cases and force the user to be precise
about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you
find a contradiction, surface it: "Your code cancels entire Orders, but you just
said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term is resolved, update `CONTEXT.md` right there. Don't batch these up.
Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` is a glossary and nothing else. Keep implementation detail,
architecture, and decisions out of it.

### Update ARCHITECTURE.md when the shape of the system changes

When a decision is settled — not while it's still being argued — reflect it in
`ARCHITECTURE.md`. Use the format in [ARCHITECTURE-FORMAT.md](./ARCHITECTURE-FORMAT.md).

Record a **reason** alongside the decision only when all three hold:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you
   picked one for specific reasons

If any is missing, describe what exists and skip the reason — the code already
says what it does.

Write the **criterion**: "Postgres — the team already runs it in production" is
what stops someone re-proposing a different database. Name a rejected alternative
only when the rejection is not obvious and an agent would otherwise propose it
again: one line, `**Not X** — why`, next to the choice it lost to.

### When a decision reverses, overwrite it

This is the step that keeps the read path from growing forever.

A reversed decision is **edited in place**: the old line is replaced by the new
truth, and anything the change made false is deleted from the file. Do not mark
the old decision as superseded, do not keep it beside the new one, do not add a
note explaining that things changed.

If overwriting turns out to be awkward — part of an entry still holds and part
doesn't — that entry was several decisions sharing one name. Split it into
separate lines with separate reasons, then overwrite only the one that died.
Decisions with different lifetimes should never share an entry.

The record of *what changed and why* is the commit and the issue thread. Neither
belongs in `ARCHITECTURE.md`.
