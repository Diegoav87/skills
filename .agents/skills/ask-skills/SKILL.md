---
name: ask-skills
description: Ask which skill or flow fits your situation. A router over the skills in this repo.
disable-model-invocation: true
---

# Ask Skills

You don't remember every skill, so ask. Before stating what a skill does or recommending a step be skipped, read that skill's SKILL.md: the summaries here are for orientation only.

## The one decision that sets the route: how big is the work?

Default to the shortest path that fits.

- **Bug or one-file change** → `/implement`, or just fix it. No spec, no tickets.
- **Feature that fits one session, one dev** → `/grill-with-docs` to sharpen it, then `/implement` right here. The conversation is the spec.
- **Feature that spans several sessions or several people** → the main flow below.
- **An idea you can't work on now** → file it as a two-line issue labelled `needs-grilling`, plus `bug` if it's a defect. `/grill-with-docs` picks it up later; `/to-spec` retires the label.
- **A grill blocked on someone else's answer** → say whose call it is and keep going. The grill pauses on a questionnaire issue labelled `needs-grilling`, holding what you settled and what they must. Once the answers are in, say so here or run `/grill-with-docs` on the issue; it asks only what the answers unblocked, then `/to-spec`.

## The main flow: only for big or shared work

1. **`/grill-with-docs`**: sharpen the idea by interview, in rounds; low-stakes calls get batched. Settled terms go into `GLOSSARY.md`.
2. **`/to-spec`**: the conversation becomes a spec on the tracker.
3. **`/to-tickets`**: the spec becomes tracer-bullet tickets, each with its blocking edges. Only when slices can run in parallel.
4. **`/implement`** per ticket, clearing context between each: `/tdd` at agreed seams, review scaled to the change, a commit on the current branch. Pushing and merging stay with you.

Keep steps 1–3 in one context window; each `/implement` starts fresh.

## Other starting points

- **A repo that hasn't used these skills** → `/setup-skills` once. It also offers to retire documentation in another shape.
- **Removing something** → `/implement`. If callers are spread across the codebase, it's a wide refactor: `/to-tickets` sequences it as expand, migrate, contract.
- **A refactor that touches many files** → `/to-tickets`, same reason.
- **A branch another session or person left** → `/code-review` against `main`, then continue from what it reports.
- **A flow too tangled to explain before you change it** → `/flow-map` on it. It traces the code and draws it, every arrow cited. Then `/grill-with-docs` with the map in context.
- **A design question the interview can't settle on paper** → `/prototype`: throwaway code that answers one question. Feed the verdict back into the grill or the spec.

## Pulled in by other skills, callable on their own

- **`/grilling`**: the interview engine behind `/grill-with-docs`. Alone, for a decision that touches no code.
- **`/domain-modeling`**: sharpens the project's terms and keeps `GLOSSARY.md` current.
- **`/tdd`**: the red-green loop at agreed seams.
- **`/code-review`**: three sub-agents review a diff since a fixed point, reported separately: Standards, Spec, Correctness.
- **`/codebase-design`**: the deep-module vocabulary (module, interface, depth, seam, adapter) that `/tdd` uses.

## Standalone

- **`/research`**: a background agent reads primary sources and leaves a dated note with citations.
- **`/handoff`**: a portable file so a session elsewhere can pick up. Narrow: see Phase boundaries.

## Phase boundaries

A phase is a chunk of work: the grilling, the implementation, the review. At the boundary between two, five options, tried in this order; the first yes wins:

1. **Continue**: the next phase needs this conversation as its source (grilling → implement is the standard case), or there's room left. Costs nothing.
2. **`/clear`**: nothing here matters to what's next.
3. **`/handoff`**: only for a new harness, a new directory, a colleague, or a side task forked mid-phase. It buys portability; if nothing travels, skip it.
4. **Subagent**: the task is scoped tightly enough to run without you.
5. **`/compact`**: the default, at the bottom because the four above are cheaper. Pass it what the next phase needs: `/compact we're going to QA this area`.

Decide at the boundary, never mid-phase. The reasoning behind each branch: [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md).
