---
name: migrate-docs
description: "Restructure an existing project's documentation into the CONTEXT.md + ARCHITECTURE.md descent these skills expect — folding in whatever ADRs, RFCs, design docs, or wiki pages the project already has, keeping what's still true and dropping what isn't."
disable-model-invocation: true
---

# Migrate Docs

Take a project documented some other way — ADRs, RFCs, design docs, a sprawling
`CLAUDE.md`, planning files from another skill system — and restructure it into the
layout these skills read: `CONTEXT.md` + `ARCHITECTURE.md` repeated per level, each
level listing its children.

This is a **re-filing operation, not a design review.** You are moving facts to
where they belong and dropping facts that stopped being true. You are not
re-deciding anything. If a decision looks wrong, note it at the end — don't fix it.

## What success looks like

The output is **smaller than the input, by a lot**. That's the point: the old docs
accumulated history, the new ones hold only the present. If the new
`ARCHITECTURE.md` files are about as long as what they replaced, the migration
failed — you re-filed history instead of dropping it.

Report the before/after size at the end. It's the honest measure of whether this
worked.

## Cost

Migration costs real tokens once — every old doc has to be read at least once, and
there's no way around that. The guarantee is that it's read **once, in a subagent,
and never in the main context**. The main thread holds extracts, not source
material. A repo with forty documents doesn't put forty documents in your window.

That one-time cost is what buys every future session a fixed, small read path.

## Process

### 1. Inventory without reading

List what exists — don't open it yet. Documentation hides in more places than
`docs/`:

- `docs/`, `doc/`, `documentation/`, `.docs/`, wiki directories
- `docs/adr/`, `docs/rfc/`, `docs/decisions/`, `architecture/`, `design/`
- `CLAUDE.md`, `AGENTS.md`, `README.md`, `CONTRIBUTING.md`, `ARCHITECTURE.md`
- `.scratch/`, `.plans/`, `.tasks/`, or whatever a previous skill system left
- Long-lived planning files anywhere in the tree

Report: how many files, roughly how large in total, and where they cluster. Then
say what you intend to do and **get the user's go-ahead before reading anything**.
This is the step where they can tell you a whole directory is already dead and save
the entire cost of reading it.

### 2. Decide the levels from the code

Propose the module tree from **the code's actual structure**, not from how the docs
were organised — the docs are what you're fixing.

- Standalone project → root + one level of modules
- Monorepo → root + one level per app + the modules inside each app

Confirm the tree with the user before extracting. Everything downstream files into
it, so a wrong tree here is wasted work.

### 3. Extract in parallel subagents

Split the inventory into clusters — by module where the docs are already organised
that way, otherwise by directory — and spawn one subagent per
cluster. Send them in a single message so they run concurrently.

Each subagent gets: the file list for its cluster, the module tree from step 2, and
**the extraction brief below pasted in full** — it has no other access to it.

<extraction-brief>

Read the listed files. Return only structured extracts — never prose copied from
the source.

For each fact you find, classify it:

- **Current** — describes how the system is now. Keep it.
- **Stale** — contradicted by the code, or by a newer document in your cluster.
  Drop it. Do not report what it said.
- **Planned, not built** — describes intended future work. Report separately; it is
  not architecture.
- **History** — records that something changed, was evaluated, was rejected, or
  used to be different. Drop it entirely, including rejected alternatives.

Verify every "current" fact against the code before reporting it. The code wins:
if a doc claims the provider is X and the code calls Y, the fact is Y and the doc
was stale. Say when you couldn't check.

Return:

1. **Decisions** — one line each: the decision, the module it belongs to, and the
   criterion behind it. Only include a criterion when the decision is hard to
   reverse, surprising, and the result of a real trade-off; otherwise the decision
   alone. Never name a technology the system doesn't use.
   Mark a decision **system-wide** when it belongs to no single module — hosting,
   environments, a scheduling mechanism, a cross-cutting inventory. These have no
   level to land on and are the ones a migration drops silently.
2. **Structural facts** — what exists in each module, present tense, a sentence or
   two each.
3. **Edges** — dependencies between modules: direction, what crosses (call, event,
   shared type, route), what would break if it changed.
4. **Glossary candidates** — domain terms with a one-line definition, and which
   level you think owns each.
5. **Conflicts** — where two documents disagree and the code couldn't settle it.
   Quote both, briefly.
6. **Planned, not built** — one line each.

Under 600 words. Compression is the job: if your output is a summary of the
documents rather than a set of facts, you've done it wrong.

</extraction-brief>

### 4. Reconcile

Merge the extracts. Most of this resolves without asking:

- **Duplicates** — the same fact from several documents collapses to one line.
- **Code-settled conflicts** — already resolved by the subagents. Nothing to ask.
- **Level assignment** — a fact goes to the highest level where it's true, and
  appears exactly once. If two modules both report it, it belongs to their parent.

Take to the user only the **genuine conflicts** — where documents disagree and the
code can't arbitrate, which mostly means unbuilt intentions. Batch them into one
numbered list with your recommended answer each, so they can accept the lot in one
pass and override the few they care about. Don't ask them one at a time.

### 5. Split `CLAUDE.md`

Treat it separately from the rest, because it's the one file loaded automatically in
every session — whatever stays in it is paid unconditionally, forever.

Most `CLAUDE.md` files in a project this size have grown into a mix of four things.
Route each:

- **How to work here** — build, test, and lint commands, conventions not visible
  from the code, environment quirks. **Stays.**
- **What the system is** — architecture, module descriptions, data flow. **Moves**
  to the relevant `ARCHITECTURE.md`.
- **What the words mean** — domain vocabulary. **Moves** to `CONTEXT.md`.
- **History and in-flight plans** — what's being migrated, what changed recently,
  what's coming. **Drops**, or goes to the tracker as backlog like anything else
  planned-not-built.

Show the user the split before writing it. `CLAUDE.md` is usually hand-written and
they'll have opinions about their own file that you don't.

### 6. Write the new structure

Write `CONTEXT.md` and `ARCHITECTURE.md` per level, following
`ARCHITECTURE-FORMAT.md` and `CONTEXT-FORMAT.md` in the `domain-modeling` skill.

Create a level's files **only where that level has something of its own to say**.
Migration is where this scheme most easily turns into ceremony — you have a pile of
extracted facts and it's tempting to give every module a file. Most modules need an
`ARCHITECTURE.md` and no `CONTEXT.md`; some need neither and just a line in their
parent's module list.

Leave the old documents in place for now. Both structures existing at once is what
lets the user diff them.

### 7. Route the planning that isn't built

Everything classified "planned, not built" is **backlog, not architecture**. It
doesn't go in `ARCHITECTURE.md` — a reader can't tell intention from reality once
they're in the same file, which is how these documents rot in the first place.

Publish it to the configured issue tracker instead (see
`docs/agents/issue-tracker.md`), or hand the user the list if they'd rather file it
themselves. This is the step that preserves the project's planning, so don't skip
it and don't silently drop items — say how many you routed.

### 7b. Route what fits neither level nor ticket

Some material is neither present-tense architecture nor a work item, and both
previous steps drop it on the floor. Two shapes recur, and both are worth
recognising because a migration loses them silently:

- **The whole-system panorama** — the complete database schema, the parts not built
  yet and how they fit, infrastructure and deployment. True or intended of the
  system as a whole, so no level owns it, and too large for a file every session
  pays to read.
- **The cross-cutting inventory** — the kind of list whose value is that it's in one
  place: every scheduled job, every external integration, every feature flag. Split
  across the tickets that will build each entry, the list stops existing, and
  nobody notices until something is missing from it.

These become **reference documents**: they stay in `docs/`, outside the descent, and
get registered in `CLAUDE.md` with two triggers — when to read the document, and
what change makes it false. A document you can't write both triggers for isn't a
reference document; re-check whether it's really architecture or really backlog.

Vendor research, benchmarks and investigation notes are a different contract:
`docs/research/`, dated in the filename, **never maintained**, and read with the
date in hand. Don't fold them into a maintained document — the date is what makes
them safe.

Propose the set to the user before writing it. Two or three is normal for a project
of any size; a long list means you're re-filing history instead of dropping it.

### 8. Retire the old documents

Once the user has reviewed the new structure, move the old documents out and
commit the removal **separately** from the commit that added the new documents,
so it reverts cleanly if something turns out to be missing.

Default to deleting them: git holds the history, the issue tracker holds the
planning, and an archive directory is just the same accumulation problem one level
down. Offer `docs/archive/` if the user isn't comfortable yet, and note that it
should be deleted once they are.

Delete any doc cross-references you find in code comments while you're here —
`// see ADR-0004` and similar. They point at documents that no longer exist.

### 9. Report

- Size before and after — file count and rough total length
- What was dropped as history or stale, in one line per category (**not** per fact —
  a list of everything you dropped rebuilds the problem you just solved)
- How many items went to the tracker as backlog
- Anything you couldn't verify against the code, so the user can check
- Decisions that looked wrong to you — flagged only, never changed
