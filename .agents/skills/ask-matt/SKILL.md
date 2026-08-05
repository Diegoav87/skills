---
name: ask-matt
description: Ask which skill or flow fits your situation. A router over the skills in this repo.
disable-model-invocation: true
---

# Ask Matt

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
   `CONTEXT.md` + ADRs.
2. **`/to-spec`** — synthesize the thread into a spec on GitHub Issues.
3. **`/to-tickets`** — split the spec into tracer-bullet vertical slices, each
   with its blocking edges as native GitHub links. Only when slices can run in
   parallel.
4. **`/implement`** per ticket, clearing context between each — drives `/tdd` at
   agreed seams, reviews scaled to the change size, and stops without touching
   git so you review the diff yourself.

Keep steps 1–3 in one context window; each `/implement` starts fresh.

## On-ramp

- **Something's broken** → **`/diagnosing-bugs`**. For the hard ones: builds a
  tight red-capable feedback loop before theorising, then fixes with a
  regression test.

## Vocabulary underneath (pulled in by other skills)

- **`/domain-modeling`** — sharpen domain language; keep `CONTEXT.md` a clean
  glossary; record hard-to-reverse decisions as ADRs.
- **`/codebase-design`** — deep-module vocabulary (module, interface, depth,
  seam, adapter, leverage, locality). `/tdd` speaks it.

## Standalone

- **`/research`** — delegate reading to a background agent; it investigates
  primary sources and leaves a cited Markdown file. Feed it into `/grill-with-docs`.
- **`/handoff`** — compact the conversation into a markdown file so a fresh
  session can pick up. Forks; `/compact` (built-in) continues in place.

## Precondition

- **`/setup-matt-pocock-skills`** — configure the issue tracker, labels, and doc
  layout the other skills assume. Run once.
