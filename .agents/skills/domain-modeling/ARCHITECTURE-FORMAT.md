# ARCHITECTURE.md Format

`ARCHITECTURE.md` describes a level of the system **as it is right now**, the reason
behind each choice that isn't self-evident from the code, and — when the level has
children — which children exist and how they connect.

Together with `CONTEXT.md` it is what an agent reads on its way down to the code it
has to change.

## The governing rule: one tense

This file is written entirely in the present. It never records that something
changed, only what is true.

Banned, without exception:

- "previously", "we used to", "migrated from", "originally"
- Dates, status fields, version numbers of the document itself
- Superseded / deprecated markers
- Sections describing what no longer applies

If you catch yourself writing a *diff* between two states of the system, stop —
that belongs in the commit message or the issue thread, not here. Edit the file so
it simply states the new truth, and delete what stopped being true.

**The size test:** this file grows with the size of the thing it describes, never
with the age of the project. Removing a component removes its lines. If the file is
growing while the system isn't, it has started accumulating history.

## The same shape at every level

One `ARCHITECTURE.md` per level, describing that level and pointing at the level
below. Depth follows the repo — a standalone API is two levels, a monorepo is
three, and nothing about the format changes.

```
/                             ← the system
├── CONTEXT.md
├── ARCHITECTURE.md           ← what the system is; lists auth, payments, posts
├── auth/
│   ├── CONTEXT.md            ← only terms auth adds
│   └── ARCHITECTURE.md       ← only auth's own shape
├── payments/…
└── posts/…
```

```
/                             ← the monorepo
├── CONTEXT.md
├── ARCHITECTURE.md           ← what the product is; lists api, web, mobile
└── apps/
    ├── api/
    │   ├── CONTEXT.md
    │   ├── ARCHITECTURE.md   ← what the API is; lists auth, payments, posts
    │   ├── auth/ARCHITECTURE.md
    │   └── payments/ARCHITECTURE.md
    └── web/…
```

**Each level states only what it adds.** The root says the system runs on Postgres;
`auth/` does not repeat it. A fact belongs to the highest level where it's true, and
appears exactly once. Repeating a parent's decision in a child is how the two start
disagreeing.

**Create a child's files only when the child has something of its own to say.** A
module with no special vocabulary gets no `CONTEXT.md`. A module whose shape is
obvious from its code gets no `ARCHITECTURE.md` — it still appears in its parent's
module list, which is what routing needs. Most modules need less than you'd think;
this scheme turns into ceremony the moment files get created out of symmetry rather
than need.

## Structure

```md
# Architecture — {what this level is}

{One paragraph: what this level is and what it's responsible for.}

## {Area}

{What exists now, in the present tense.}

**{Choice}** — {the criterion that produced it.}
**Not {alternative}** — {why, only when an agent would otherwise propose it again.}

## Modules

{Only when this level has children. One line each — see below.}

### Edges

{How those children depend on each other.}
```

Example — the root of a standalone API:

```md
# Architecture — Notifications API

An API for scheduling and sending customer notifications.

## Background work

Anything slower than a request goes on a queue handled by a worker pool. The API
never blocks on it.

**A durable queue rather than in-process async** — jobs have to survive a deploy.
**At-least-once delivery** — handlers are idempotent so retries are safe.

## Persistence

Postgres, one schema per module, no cross-schema joins.

**Postgres** — the team already runs it in production.
**Not a document store** — every module joins on customer id; document modelling
was tried in a spike and the joins moved into application code.

## Modules

- **auth** (`auth/`) — issues and validates the credentials every other module trusts.
- **payments** (`payments/`) — takes card charges and refunds.
- **posts** (`posts/`) — user-authored content and its moderation state.

### Edges

- **payments → auth**: reads the account owner from the session claims. Adding or
  removing a claim affects every module, this one included.
- **posts → payments**: a post can only be promoted if the account has an active
  charge. Posts calls `hasActiveCharge()`; changing that signature breaks posts.
```

Note what the example does *not* say: which queue providers were evaluated, or
what the queue used to be. Every line is load-bearing for someone about to write
code, and the one rejected alternative is there because it would be proposed again.

## The module list is the routing

The one-line description has to be good enough that an agent can decide *"not
mine"* **without opening anything**. Write what the module is responsible for, not a
label. "posts — user-authored content and its moderation state" lets a reader rule
it out; "posts — post logic" forces them to open the file to find out.

That single line is what keeps reading cost proportional to the depth of the tree
rather than the size of the repo. Write it carefully; it's read far more often than
anything it points at.

## Edges are the safety net

An agent working on `auth` reads auth and nothing else — so the edges are what stop
it changing a session claim and breaking `payments`, which it never opened. They
also tell it when a ticket that looks like auth work actually reaches into `posts`,
and that module has to be read too.

Record, for each edge:

- **Which direction the dependency runs**, and which side is unaware of the other
- **What crosses** — a function call, an event, a shared type, an HTTP route
- **What would break** if the thing that crosses changed

A line or two each. If an edge needs a paragraph, those two modules are entangled
enough to be one module.

Edges live at the level that owns **both** ends. `auth ↔ posts` belongs to their
parent; `api ↔ web` belongs to the monorepo root.

## Rules

- **State the criterion.** "Postgres — the team already runs it" is enough to stop
  someone proposing a different database. Add a `**Not X** — why` line only when
  the rejection is not obvious and an agent would otherwise propose X again. One
  line; if the rejection needs more, it is a spike result and belongs in
  `docs/research/`.

- **Only decisions that need a reason get one.** Apply all three tests — hard to
  reverse, a reader would otherwise wonder why, and there was a genuine trade-off.
  If any is missing, describe the thing and skip the reason; the code says what it
  does.

- **One line per decision.** If a choice needs three paragraphs to justify, either
  it isn't settled yet (leave it in the spec until it is) or it's several decisions
  wearing one name — split it.

- **Name modules and areas, not file paths**, except in the module list, where the
  path is what routes.

- **No implementation detail the code states more precisely.** Signatures, schemas,
  and config values belong in the code.

- **Delete rather than annotate.** When a decision is reversed, overwrite the line.
  Git and the issue tracker hold the history; this file holds the present.

## When the file gets long

A long `ARCHITECTURE.md` is a signal, not a formatting problem. **Past 80 lines,
run these checks before adding a line**, and say in your summary which one applied.
Don't add a table of contents — the `##` headings already are one.

Ask which of these is true:

- **It's accumulating history.** Apply the size test above and delete.
- **It's drifting into implementation detail** the code states better. Cut it.
- **It's describing its children instead of pointing at them.** Move that content
  down a level and leave one line in the module list.
- **The level genuinely covers too much.** Split it into modules, each with its own
  file and an entry in the list here.
