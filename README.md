# Skills

A small, opinionated set of agent skills for shipping software with an AI coding agent: sharpen the idea, write it down once, build it in slices, review it, and keep the project's documentation true along the way.

Sixteen skills, one workflow. Works with Claude Code, Codex, and any agent that reads `SKILL.md` files from `.agents/skills/`.

Based on [mattpocock/skills](https://github.com/mattpocock/skills). See [How this differs from the original](#how-this-differs-from-the-original) for what changed and why.

---

## Table of contents

- [What a skill is](#what-a-skill-is)
- [Install](#install)
- [The workflow](#the-workflow)
- [Skills reference](#skills-reference)
- [The documentation model](#the-documentation-model)
- [Conventions the skills assume](#conventions-the-skills-assume)
- [How this differs from the original](#how-this-differs-from-the-original)
- [Credit and license](#credit-and-license)

---

## What a skill is

A skill is a folder with a `SKILL.md` file: a prompt with frontmatter that tells the agent when to use it and what to do. The agent loads it on demand, either because you typed `/skill-name` or because the task matched its description.

Two kinds live in this repo:

- **User-invoked** (`disable-model-invocation: true`): you call them explicitly, like `/implement` or `/to-spec`. They take actions with consequences, so the agent never picks them on its own.
- **Model-invoked**: the agent reaches for them when the task fits, like `/tdd` while implementing or `/diagnosing-bugs` when you say something is broken. You can still call them by name.

Each skill folder also carries an `agents/openai.yaml` so the same skill works in Codex without changes.

---

## Install

### Option A: the `skills` CLI (any agent)

```bash
npx skills@latest add Diegoav87/skills
```

This copies the skills into the agent directories it detects in your project.

### Option B: clone and link (Claude Code)

Clone the repo somewhere and point your project at it. On Windows, use a junction so git in the target project does not follow it:

```powershell
git clone https://github.com/Diegoav87/skills.git C:\path\to\skills
New-Item -ItemType Junction -Path .claude\skills -Target C:\path\to\skills\.agents\skills
```

On macOS or Linux:

```bash
git clone https://github.com/Diegoav87/skills.git ~/skills
ln -s ~/skills/.agents/skills .claude/skills
```

Add `.claude/skills/` to that project's `.gitignore`. To make the skills available in every project instead, link into `~/.claude/skills/`.

### Then, once per repo

```
/setup-skills
```

This configures the three things the other skills read: which issue tracker to use, the `ready-for-agent` label, and where `CONTEXT.md` and `ARCHITECTURE.md` live. It writes `docs/agents/*.md` and adds an `## Agent skills` block to your `CLAUDE.md` or `AGENTS.md`.

If the project already has documentation in another shape (ADRs, RFCs, design docs, a `CLAUDE.md` that grew into an architecture document), run `/migrate-docs` afterwards.

---

## The workflow

Everything routes off one question: **how big is the work?** Default to the shortest path that fits. If you forget the map, `/ask-skills` prints it.

```
Bug or one-file change
  └── /implement (or just fix it)

Feature that fits one session, one developer
  └── /grill-with-docs ──► /implement

Feature that spans several sessions or several people
  └── /grill-with-docs ──► /to-spec ──► /to-tickets ──► /implement (per ticket)
```

The full flow, step by step:

1. **`/grill-with-docs`**. The agent interviews you about the plan, one load-bearing question at a time, and batches the trivial ones. As terms and decisions settle, it writes them into `CONTEXT.md` and `ARCHITECTURE.md`. Nothing is built yet.
2. **`/to-spec`**. Synthesizes the conversation into a spec on your issue tracker. No new interview. The spec references decisions already recorded in `ARCHITECTURE.md` instead of restating them.
3. **`/to-tickets`**. Splits the spec into tracer-bullet vertical slices, each declaring which tickets block it. Only when slices can genuinely run in parallel. If the work is one slice, it stays one ticket.
4. **`/implement`**, one ticket per fresh session. Uses `/tdd` at seams agreed up front, reviews the change at the right scale, updates `ARCHITECTURE.md` if the shape of the system moved, retires the ticket, and stops **without running any git command** so you review the diff yourself.

Keep steps 1 to 3 in one context window. Each `/implement` starts clean, with `/handoff` if the next session needs context the docs do not carry.

---

## Skills reference

### The main flow

| Skill | Invoked by | What it does |
|---|---|---|
| `grill-with-docs` | you | Runs `grilling` with `domain-modeling` active, so the interview leaves a paper trail in the docs. |
| `to-spec` | you | Turns the current conversation into a spec on the tracker and labels it `ready-for-agent`. Refuses to be ceremony: if the work fits one session, it tells you to skip it. |
| `to-tickets` | you | Spec to tracer-bullet tickets with blocking edges. Handles wide refactors as expand, migrate, contract. Publishes as GitHub issues or as one file per ticket under `.scratch/`. |
| `implement` | you | Builds one ticket. TDD at agreed seams, review scaled to the change, keeps `ARCHITECTURE.md` true, retires the ticket, never touches git. |
| `code-review` | agent | Two-axis review of a diff since a fixed point: **Standards** (repo conventions plus a fixed Fowler smell baseline) and **Spec** (does it do what was asked). Each axis runs in its own subagent and they are reported separately, never merged. |

### Building and fixing

| Skill | Invoked by | What it does |
|---|---|---|
| `tdd` | agent | The red-green loop, with what a good test is, where tests go (seams), and the anti-patterns to avoid. Refactoring is deferred to review. |
| `diagnosing-bugs` | agent | Six-phase discipline for hard bugs. Phase 1 is the whole skill: build a tight, red-capable feedback loop before forming any hypothesis. No loop, no theories. |
| `resolving-merge-conflicts` | agent | Resolve an in-progress merge or rebase by reading the intent behind each side, then run the project's checks. |

### Shared vocabulary

| Skill | Invoked by | What it does |
|---|---|---|
| `codebase-design` | agent | The deep-module vocabulary the other skills speak: module, interface, seam, adapter, depth, leverage, locality. Includes guides for deepening a cluster and designing an interface twice. |
| `domain-modeling` | agent | Builds the project's glossary and architecture record as you design. Defines the `CONTEXT.md` and `ARCHITECTURE.md` formats and the rules for keeping them small. |

### Around the session

| Skill | Invoked by | What it does |
|---|---|---|
| `grilling` | agent | Interview to stress-test a plan. Maps the decision tree first, then grills only the load-bearing branches and batches the rest. |
| `research` | agent | Delegates reading to a background agent that works from primary sources and writes a cited note under `docs/research/`, dated and versioned so it carries its own expiry. |
| `handoff` | you | Compacts the conversation into a handoff file for a fresh session. References existing artifacts instead of duplicating them. |
| `ask-skills` | you | The router. Tells you which skill or flow fits your situation. |

### Setup

| Skill | Invoked by | What it does |
|---|---|---|
| `setup-skills` | you | One-time repo configuration: issue tracker, label, doc layout. |
| `migrate-docs` | you | Refiles existing documentation into the `CONTEXT.md` and `ARCHITECTURE.md` layout. Old docs are read once, in subagents, never in the main context. Success is measured by how much smaller the output is than the input. |

---

## The documentation model

The skills share one idea about project documentation, and it is the part most worth understanding before using them.

Two files, repeated at every level of the repo:

- **`CONTEXT.md`**: the vocabulary this level introduces. A glossary and nothing else.
- **`ARCHITECTURE.md`**: what this level is, why it is shaped that way, its modules in one line each, and the edges between them.

```
/
├── CONTEXT.md              ← User, Account, Money
├── ARCHITECTURE.md         ← the system; lists auth, payments, posts + their edges
├── auth/
│   ├── CONTEXT.md          ← Session, Claim: only what auth adds
│   └── ARCHITECTURE.md     ← only auth's own shape
├── payments/…
└── posts/…
```

A monorepo gets one more level on top. Nothing else changes.

Why this shape:

- **Reading is a descent, not a survey.** An agent working on `auth` reads root, then `auth`. The cost is proportional to the depth of the tree, not the size of the repo. Fifty modules cost the same as five.
- **Each level states only what it adds.** A fact lives at the highest level where it is true and appears exactly once.
- **Each level records the edges between its children.** That is how an agent working on `auth` learns its ticket also reaches into `posts` without reading everything.
- **Present tense only.** When a decision reverses, the old line is overwritten. Nothing is marked superseded. History lives in git and the issue tracker, and an agent about to implement never needs it.
- **Files are created lazily.** A module with nothing of its own to say gets no files, just a line in its parent's module list.

`/setup-skills` writes the descent rule into your `CLAUDE.md`, `/grill-with-docs` and `/implement` keep the files true, and `/migrate-docs` gets an existing project into this shape.

---

## Conventions the skills assume

- **The agent does not run git.** `/implement` leaves every change unstaged so you review the diff. You commit. The one exception is `resolving-merge-conflicts`, whose whole job is finishing a merge.
- **Issue tracker.** GitHub Issues by default, through the `gh` CLI. Anything else (Linear, Jira, local markdown) is described once in `docs/agents/issue-tracker.md` and the skills follow it.
- **The `ready-for-agent` label** marks a spec or ticket as fully specified. `/to-spec` and `/to-tickets` apply it; `/implement` picks it up.
- **`.scratch/` is scaffolding**, not record. Local tickets live there, get deleted when done, and the directory is gitignored.
- **`docs/agents/`** holds the per-repo config the skills read. Edit it directly; rerun `/setup-skills` only to switch trackers.
- **`docs/research/`** holds research notes, outside the default read path, each opening with the date and versions it was verified against.

---

## How this differs from the original

This started as a fork of [mattpocock/skills](https://github.com/mattpocock/skills). The original ships 37 skills across four directories. This repo keeps 15 of them, adds one, and flattens everything into a single namespace. The reasoning behind each change:

**Fewer skills.** A skill you do not use is not free. It is one more thing the agent can reach for, and one more thing you have to remember exists before deciding it does not apply. Dropped: the eight `in-progress/` skills (unfinished upstream, so their behavior was unpredictable), the four `misc/` skills (one-off tooling tied to a TypeScript setup), five prose-oriented productivity skills, and five engineering skills that overlapped with something kept or targeted a stage of work that rarely comes up. Thirty-seven is a library. Sixteen is a workflow.

**A size gate at the front.** Upstream's recommended flow is always spec, then tickets, then implement. That generates ceremony for work that fits in one session. Here, `/to-spec` and `/to-tickets` both check first whether they are worth running, and `/ask-skills` routes by size before anything else. The full flow exists only for work that spans sessions or people.

**`implement` grew from 15 lines to 71.** It was the thinnest skill upstream and the one used most. It now spells out review scaled to the change (inline for a slice, full `/code-review` for a ticket), the two documentation checks before finishing, retiring the ticket, and the rule to never touch git.

**`ARCHITECTURE.md` instead of ADRs.** Upstream records decisions as ADR files. ADRs accumulate: every reversal adds a document, and an agent has to read the whole stack to know the current state. This repo replaces them with a single present-tense `ARCHITECTURE.md` per level that is overwritten when things change. `domain-modeling` doubled in size to define the two file formats and the rules for keeping them small. Specs and tickets reference recorded decisions instead of restating them, so each fact has one home.

**`setup-skills` writes the read path into `CLAUDE.md`.** The descent instruction is inlined rather than left behind a pointer, because `CLAUDE.md` is the only file guaranteed to be loaded. The skill also flags architecture description and history that have crept into `CLAUDE.md`, since that file is paid for in every session.

**`migrate-docs` is new.** Adopting the documentation model on an existing project means refiling whatever is already there. The skill reads old docs once in subagents, classifies each fact as current, stale, planned, or history, keeps only the first, routes the planned work to the tracker, and drops the rest. It reports before and after size, because a migration that produces docs as long as the ones it replaced has refiled history instead of dropping it.

**`research` notes carry an expiry.** They go to a fixed place, `docs/research/`, outside the default read path, and each one opens with the date and the exact versions it was verified against. Research rots faster than anything else in a repo, so the reader checks that line before trusting the rest.

---

## Credit and license

Built on [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock, whose README says *"Hack around with them. Make them your own."* If you are starting from scratch, read the original first. It is more complete, and you may cut it differently than this repo did.

MIT. See [LICENSE](LICENSE).
