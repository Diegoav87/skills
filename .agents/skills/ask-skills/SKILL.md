---
name: ask-skills
description: Ask which skill or flow fits your situation. A router over the skills in this repo.
disable-model-invocation: true
---

# Ask Skills

You don't remember every skill, so ask. This is the map of the trimmed flow.

## The one decision that sets the route: how big is the work?

Everything routes off size. Default to the shortest path that fits.

- **Bug / one-file change** → just `/implement` (or fix it directly). No spec,
  no tickets.
- **Feature that fits one session, one dev** → `/grill-with-docs` to sharpen it,
  then `/implement` right here. The conversation is the spec — skip `/to-spec`
  and `/to-tickets`.
- **Feature that spans multiple sessions or multiple people** → the full flow.
- **An idea you can't work on now** → file it as a two-line issue labelled
  `needs-grilling`. `/grill-with-docs` picks it up later; `/to-spec` retires the
  label. Add `bug` if it's a defect.
- **A grill blocked on someone else's answer** → say whose call it is and keep
  going. The grill pauses on a questionnaire issue, labelled `needs-grilling`,
  holding what you settled and what they must. Once the answers are in, say so
  here or run `/grill-with-docs` on the issue; it asks only what the answers
  unblocked, then `/to-spec`.

## Other starting points

- **A project from scratch** → `/setup-skills` first, then `/grill-with-docs`,
  then the size gate above.
- **Removing something** → `/implement` directly. Its doc check deletes the lines
  that described what's gone. If callers are spread across the codebase, it's a
  wide refactor: `/to-tickets` sequences it as expand, migrate, contract.
- **A refactor that touches many files** → `/to-tickets`, same reason.
- **Picking up a branch another session or person left** → `/code-review`
  against `main` first, then continue from what it reports.

## The main flow: idea → ship (only for big or shared work)

1. **`/grill-with-docs`** — sharpen the idea by interview, one load-bearing
   question at a time; trivial calls get batched. Leaves a paper trail in
   `CONTEXT.md` + `ARCHITECTURE.md`.
2. **`/to-spec`** — synthesize the thread into a spec on the configured tracker.
3. **`/to-tickets`** — split the spec into tracer-bullet vertical slices, each
   with its blocking edges as links on the tracker. Only when slices can run in
   parallel.
4. **`/implement`** per ticket, clearing context between each — drives `/tdd` at
   agreed seams, reviews scaled to the change size, and commits to the current
   branch. It never pushes, merges, or rewrites history; that stays with you.

Keep steps 1–3 in one context window; each `/implement` starts fresh.

## Detour

- **A design question the interview can't settle on paper** → **`/prototype`**.
  Throwaway code that answers one question: a single HTML file to push a state
  model through hard cases, or several UI variations on one route. Feed the
  verdict back into `/grill-with-docs` or `/to-spec`.

## On-ramp

- **Something's broken** → **`/diagnosing-bugs`**. For the hard ones: builds a
  tight red-capable feedback loop before theorising, then fixes with a
  regression test.
- **A merge or rebase stopped on conflicts** → **`/resolving-merge-conflicts`**.
  Reads the intent behind each side, resolves, then runs the project's checks.

## Inside the build (pulled in by `/implement`, callable on their own)

- **`/tdd`** — the red-green loop at seams agreed up front. What a good test is,
  where tests go, the anti-patterns.
- **`/code-review`** — two-axis review of a diff since a fixed point: Standards
  (repo conventions plus a smell baseline) and Spec (does it do what was asked).
  Each axis in its own subagent, reported separately.
- **`/grilling`** — the interview engine behind `/grill-with-docs`. Use it alone
  to stress-test a decision that touches no code.

## Vocabulary underneath (pulled in by other skills)

- **`/domain-modeling`** — sharpen domain language; keep `CONTEXT.md` a clean
  glossary and `ARCHITECTURE.md` a present-tense record of what the system is and
  why. Both are overwritten when things change — never appended to.
- **`/codebase-design`** — deep-module vocabulary (module, interface, depth,
  seam, adapter, leverage, locality). `/tdd` speaks it.

## Standalone

- **`/research`** — delegate reading to a background agent; it investigates
  primary sources and leaves a cited Markdown file. Feed it into `/grill-with-docs`.
- **`/handoff`** — write a portable markdown file so a session elsewhere can
  pick up. Narrow: see Phase boundaries.

## Phase boundaries

A phase is a chunk of work: the grilling, the implementation, the review. At the
boundary between two, five options, tried in this order; the first yes wins:

1. **Continue** — the next phase needs this conversation as its source (grilling →
  implement is the standard case), or there's room left. Costs nothing.
2. **`/clear`** — nothing here matters to what's next.
3. **`/handoff`** — only for a new harness, a new directory, a colleague, or a
  side task forked mid-phase. It buys portability; if nothing travels, skip it.
4. **Subagent** — the task is scoped tightly enough to run without you.
5. **`/compact`** — the default, at the bottom because the four above are cheaper.
  Pass it what the next phase needs: `/compact we're going to QA this area`.

Decide at the boundary, never mid-phase. The reasoning behind each branch:
[PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md).

## Preconditions

- **`/setup-skills`** — configure the issue tracker, labels, and doc
  layout the other skills assume. Run once, cheap.
- **`/migrate-docs`** — only for a project already documented some other way
  (ADRs, RFCs, design docs, another skill system). Folds what's still true into
  `CONTEXT.md` + `ARCHITECTURE.md`, routes unbuilt plans to the tracker, and drops
  the history. A one-time cost that buys every later session a small read path.
