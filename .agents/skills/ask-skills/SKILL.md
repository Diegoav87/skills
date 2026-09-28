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
- **`/handoff`** — compact the conversation into a markdown file so a fresh
  session can pick up. Forks; `/compact` (built-in) continues in place.

## Preconditions

- **`/setup-skills`** — configure the issue tracker, labels, and doc
  layout the other skills assume. Run once, cheap.
- **`/migrate-docs`** — only for a project already documented some other way
  (ADRs, RFCs, design docs, another skill system). Folds what's still true into
  `CONTEXT.md` + `ARCHITECTURE.md`, routes unbuilt plans to the tracker, and drops
  the history. A one-time cost that buys every later session a small read path.
