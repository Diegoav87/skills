# Skills

A small, opinionated set of agent skills for shipping software with an AI coding agent: sharpen the idea, write it down once, build it in slices, review it, and keep the project's documentation true along the way.

Nineteen skills, one workflow. Works with Claude Code, Codex, and any agent that reads `SKILL.md` files from `.agents/skills/`.

Based on [mattpocock/skills](https://github.com/mattpocock/skills), with pieces from [pstack](https://github.com/cursor/plugins/tree/main/pstack). See [How this differs from the original](#how-this-differs-from-the-original) for what changed and why.

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

Skills are personal. A project does not track them in git; each developer keeps their own copy, so two people on one repo can run different skill sets without conflict. Add `.claude/skills/` and `.agents/skills/` to the project's `.gitignore`, except for any skill that documents the project itself.

### Option A: the `skills` CLI (any agent)

```bash
npx skills@latest add Diegoav87/skills
npx skills update -y        # later, to pull the latest
```

This copies the skills into the agent directories it detects in your project.

### Option B: sync from a local clone (Claude Code, Windows)

Clone the repo once, then copy it into any project with the script it ships:

```powershell
git clone https://github.com/Diegoav87/skills.git C:\path\to\skills
C:\path\to\skills\sync.ps1 C:\path\to\project
```

The script copies every skill into the project's `.claude\skills`, replaces old copies, removes skills that no longer exist here, and never touches skills the project has that did not come from this repo. Rerun it after any change to the clone.

### Then, once per repo

```
/setup-skills
```

This configures the three things the other skills read: which issue tracker to use, the labels the skills apply, and where `CONTEXT.md` and `ARCHITECTURE.md` live. It writes `docs/agents/*.md` and adds an `## Agent skills` block to your `CLAUDE.md` or `AGENTS.md`.

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

An idea you cannot work on now
  └── file it as a two-line issue labelled needs-grilling; pick it up later
```

The full flow, step by step:

1. **`/grill-with-docs`**. The agent interviews you about the plan in rounds. Each round asks every question whose answer does not depend on another open question, with a recommended answer for each. Big decisions get their own question; small ones collapse into a defaults list you accept in a word. As terms and decisions settle, it writes them into `CONTEXT.md` and `ARCHITECTURE.md`. Nothing is built yet. If a question cannot be settled on paper, `/prototype` answers it with throwaway code.
2. **`/to-spec`**. Synthesizes the conversation into a spec on your issue tracker. No new interview. The spec references decisions already recorded in `ARCHITECTURE.md` instead of restating them. It labels the issue `spec` and `ready-for-agent`.
3. **`/to-tickets`**. Splits the spec into tracer-bullet vertical slices, each declaring which tickets block it. Only when slices can genuinely run in parallel. If the work is one slice, it stays one ticket.
4. **`/implement`**, one ticket per fresh session. Marks the ticket `in-progress`, uses `/tdd` at seams agreed up front, reviews the change at the right scale, updates `ARCHITECTURE.md` if the shape of the system moved, marks the ticket `needs-review`, and commits to the current branch. It never pushes, merges, or rewrites history. It ends with a reading guide: what changed, which files to read in which order, and what was run.

Keep steps 1 to 3 in one context window. Between phases, `/ask-skills` has a five-step tree for deciding whether to continue, clear, hand off, send work to a subagent, or compact.

---

## Skills reference

Each entry says who invokes the skill, what it does, and then the same thing in plain words.

### The main flow

**`grill-with-docs`**, invoked by you. Runs `grilling` with `domain-modeling` active, so the interview leaves a paper trail in the docs.
In plain words: the agent asks you questions about what you want to build, and writes down the words and decisions you agree on as it goes.

**`to-spec`**, invoked by you. Turns the current conversation into a spec on the tracker, labelled `spec` and `ready-for-agent`. Refuses to be ceremony: if the work fits one session, it tells you to skip it.
In plain words: it writes up what you just discussed as one issue that someone else, or a later session, can build from. It first checks the work is big enough to deserve that.

**`to-tickets`**, invoked by you. Spec to tracer-bullet tickets with blocking edges. Handles wide refactors as expand, migrate, contract. Publishes as tracker issues or as one file per ticket under `.scratch/`.
In plain words: it cuts a spec into pieces that can each be built and tested on their own, and records which piece has to finish before which. A tracer bullet is a thin slice that goes all the way through, from database to screen, rather than one layer at a time.

**`prototype`**, invoked by the agent. Throwaway code that answers one design question: an HTML file that drives a state model through hard cases, or several UI variations on one route. Lands on a throwaway branch; main keeps only the decision.
In plain words: when talking cannot settle whether a design is right, the agent builds a quick disposable version so you can click through it and decide.

**`implement`**, invoked by you. Builds one ticket. TDD at agreed seams, review scaled to the change, keeps `ARCHITECTURE.md` true, moves the ticket's labels, commits on the branch, ends with a reading guide.
In plain words: it builds one piece of work, checks it, updates the docs that describe the system, and finishes by telling you what changed and in which order to read the files.

**`code-review`**, invoked by the agent. Two-axis review of a diff since a fixed point: **Standards** (repo conventions plus a fixed smell baseline) and **Spec** (does it do what was asked). Each axis runs in its own subagent and they are reported separately, never merged. For diffs that touch shared code, a third block names the one fact the change is safe because of and proves it by running code.
In plain words: two fresh reviewers look at the change, one for "is this written the way this project writes code" and one for "does it do what the ticket asked". If the change touches something other code depends on, a third check says what could break elsewhere and how sure it is.

### Building and fixing

**`tdd`**, invoked by the agent. The red-green loop, with what a good test is, where tests go (seams), and the anti-patterns to avoid. Prefers no new test over a bad one. Refactoring is deferred to review.
In plain words: write a test that fails, write just enough code to make it pass, repeat. Tests go at the places you agreed on up front, and if the only test you could write would be a bad one, the agent uses a script or a manual check instead and says so.

**`diagnosing-bugs`**, invoked by the agent. Six-phase discipline for hard bugs. Phase 1 is the whole skill: build a tight, red-capable feedback loop before forming any hypothesis. No loop, no theories. Redacts secrets from everything it shows.
In plain words: before guessing why something is broken, the agent builds one command that reliably shows the bug. Only then does it shrink the case, rank causes, and fix it with a test that would catch the bug again.

**`resolving-merge-conflicts`**, invoked by the agent. Resolve an in-progress merge or rebase by reading the intent behind each side, then run the project's checks.
In plain words: when git stops on a conflict, the agent works out what each side was trying to do instead of picking lines, then makes sure the result still builds.

### Shared vocabulary

**`codebase-design`**, invoked by the agent. The deep-module vocabulary the other skills speak: module, interface, seam, adapter, depth, leverage, locality. Includes guides for deepening a cluster and designing an interface twice.
In plain words: one idea, that a good module hides a lot of work behind a few functions, so whoever calls it, including a test, only has to learn a little. A **module** is any piece of code with an inside and an outside. Its **interface** is everything a caller has to know to use it. A **seam** is the place where you can swap what is behind the interface, and an **adapter** is one concrete thing plugged in there, like a real Postgres store or an in-memory fake for tests. When the agent uses these words in a project, this is where they come from.

**`domain-modeling`**, invoked by the agent. Builds the project's glossary and architecture record as you design. Defines the `CONTEXT.md`, `ARCHITECTURE.md`, and reference-document formats and the rules for keeping them small.
In plain words: it keeps a list of what the project's words mean, and a short present-tense description of each part of the system and why it is shaped that way. When you change your mind, the old line is replaced, not kept.

### Around the session

**`grilling`**, invoked by the agent. Interview to stress-test a plan, in rounds over the decision tree. Big decisions get their own question, small ones collapse into a defaults list.
In plain words: the questioning engine behind `grill-with-docs`. Use it alone for a decision that touches no code.

**`research`**, invoked by the agent. Delegates reading to a background agent that works from primary sources and writes a cited note under `docs/research/`, dated and versioned so it carries its own expiry.
In plain words: you ask a question, an agent reads the official docs in the background and leaves a dated note. The date is there because research goes stale fast.

**`handoff`**, invoked by you. Writes a portable markdown file so a session elsewhere can pick up. Narrow: for a new tool, a new folder, a colleague, or a side task.
In plain words: a note for a different session to continue from. Most of the time you do not need it; `/ask-skills` explains the other four options.

**`ask-skills`**, invoked by you. The router. Tells you which skill or flow fits your situation, and what to do at the boundary between two phases of work.
In plain words: the map. When you do not know what to run, run this.

**`writing-for-agents`**, invoked by the agent. Rules for any text an agent will read: skills, `CLAUDE.md`, pointed-to docs. Loaded when creating or editing a skill.
In plain words: how to write instructions so an agent follows them the same way every time. Used when editing this repo.

**`unslop`**, invoked by the agent. Cuts AI tells from any text you will read: filler, hedging, fancy words, em dashes, chatbot phrases. Copied from pstack.
In plain words: makes the agent's writing read like a person wrote it. Fires on answers, summaries, docs, and comments.

### Setup

**`setup-skills`**, invoked by you. One-time repo configuration: issue tracker, labels, doc layout.
In plain words: run once per project. It asks a few questions and writes the small files the other skills read.

**`migrate-docs`**, invoked by you. Refiles existing documentation into the `CONTEXT.md` and `ARCHITECTURE.md` layout. Old docs are read once, in subagents, never in the main context. Success is measured by how much smaller the output is than the input.
In plain words: for a project that already has docs in another shape. It keeps what is still true, sends planned work to the tracker, and drops the history.

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
- **Maps and reasons, not descriptions.** An `ARCHITECTURE.md` says what exists, what talks to what, and why a non-obvious choice was made. It does not describe what the code says more precisely. A rejected alternative gets one line, "not X, because Y", only when an agent would otherwise propose X again. Past 80 lines, the skill runs a set of checks before adding more.
- **Files are created lazily.** A module with nothing of its own to say gets no files, just a line in its parent's module list.

Facts that belong to the whole system and are too large for the read path, like the full database schema or the deployment layout, become **reference documents** in `docs/`. Each is registered in `CLAUDE.md` with two triggers: when to open it, and what change makes it false.

`/setup-skills` writes the reading rules into your `CLAUDE.md` and `docs/agents/domain.md`. The writing rules live in the `domain-modeling` skill, one format file per kind of document. `/grill-with-docs` and `/implement` keep the files true, and `/migrate-docs` gets an existing project into this shape.

---

## Conventions the skills assume

- **The agent commits, and only commits.** Committing is local and reversible, so skills do it on the current branch and say what they committed. Pushing, merging, rebasing, amending, and committing on `main` are yours. You review the diff in the pull request.
- **Comments are about the code beside them.** No pointers to specs, tickets, or `ARCHITECTURE.md`, and no restating of decisions the docs hold. Written in plain words, because comments are text you read.
- **Issue tracker.** GitHub Issues by default, through the `gh` CLI. Anything else (Linear, Jira, local markdown) is described once in `docs/agents/issue-tracker.md` and the skills follow it.
- **Labels are moved by skills, not by hand.** Four states, `needs-grilling`, `ready-for-agent`, `in-progress`, `needs-review`, each applied and removed by the skill that changes it, so a filter on any one of them is always true. Two kinds, `bug` and `spec`, set once when filing. The tracker file lists who owns each.
- **`.scratch/` is scaffolding**, not record. Local tickets live there, get deleted when done, and the directory is gitignored.
- **`docs/agents/`** holds the per-repo config the skills read. Edit it directly; rerun `/setup-skills` only to switch trackers.
- **`docs/research/`** holds research notes, outside the default read path, each opening with the date and versions it was verified against.

---

## How this differs from the original

This started as a fork of [mattpocock/skills](https://github.com/mattpocock/skills). The original ships 37 skills across four directories. This repo keeps 17 of them, adds two (`migrate-docs`, and `unslop` from pstack), and flattens everything into a single namespace. The reasoning behind each change:

**Fewer skills.** A skill you do not use is not free. It is one more thing the agent can reach for, and one more thing you have to remember exists before deciding it does not apply. Dropped: the `in-progress/` skills (unfinished upstream), the `misc/` skills (one-off tooling tied to a TypeScript setup), the productivity skills for prose and teaching, and the engineering skills built for inbound issue queues (`triage`, `wayfinder`) or occasional upkeep (`improve-codebase-architecture`, `wizard`). Thirty-seven is a library. Nineteen is a workflow.

**A size gate at the front.** Upstream's recommended flow is always spec, then tickets, then implement. That generates ceremony for work that fits in one session. Here, `/to-spec` and `/to-tickets` both check first whether they are worth running, and `/ask-skills` routes by size before anything else. The full flow exists only for work that spans sessions or people.

**`implement` grew from 15 lines to about 135.** It was the thinnest skill upstream and the one used most. It now spells out review scaled to the change (inline for a slice, full `/code-review` for a ticket), the three documentation checks before finishing, moving the parent work item, the label swaps, the line between what the agent may do in git (commit) and what it may not (push, merge, rewrite history), and a closing reading guide so the user can follow the change file by file.

**`ARCHITECTURE.md` instead of ADRs.** Upstream records decisions as ADR files. ADRs accumulate: every reversal adds a document, and an agent has to read the whole stack to know the current state. This repo replaces them with a single present-tense `ARCHITECTURE.md` per level that is overwritten when things change. `domain-modeling` defines three file formats and the rules for keeping them small. Specs and tickets reference recorded decisions instead of restating them, so each fact has one home.

**Six labels instead of five triage states.** Upstream's labels serve a triage skill for issues from strangers. Here each label is applied and removed by the skill that changes an issue's state, so none needs a human to keep it true, and two kind labels make the roadmap and the bug list filterable.

**`grilling` works in rounds and sorts by stakes.** Upstream's grilling asks every currently askable question at once. The version here keeps that, and adds a sort: load-bearing decisions get their own question, low-stakes ones collapse into a defaults list accepted in a word.

**`setup-skills` writes the read path into `CLAUDE.md`.** The descent instruction is inlined rather than left behind a pointer, because `CLAUDE.md` is the only file guaranteed to be loaded. The project's `domain.md` holds only reading rules; writing rules stay in the skills.

**`migrate-docs` is new.** Adopting the documentation model on an existing project means refiling whatever is already there. The skill reads old docs once in subagents, classifies each fact as current, stale, planned, or history, keeps only the first, routes the planned work to the tracker, and drops the rest. It reports before and after size, because a migration that produces docs as long as the ones it replaced has refiled history instead of dropping it.

**`research` notes carry an expiry.** They go to a fixed place, `docs/research/`, outside the default read path, and each one opens with the date and the exact versions it was verified against. Research rots faster than anything else in a repo, so the reader checks that line before trusting the rest.

**Borrowed from pstack.** `unslop` as a skill. In `code-review`, the blast-radius block with its ladder of how sure a finding is. In `tdd`, the rule that no new test beats a bad test. In `writing-for-agents`, the rule to state the instruction and skip the reason. pstack's mode skill, playbooks, principle files, and multi-model routing were reviewed and not taken.

`SYNC.md` records the commit of each source repo that every skill was last compared against, and the decision taken.

---

## Credit and license

Built on [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock, whose README says *"Hack around with them. Make them your own."* If you are starting from scratch, read the original first. It is more complete, and you may cut it differently than this repo did.

`unslop` is copied from [pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan (MIT), with a changed description. Ideas borrowed from pstack are listed above.

MIT. See [LICENSE](LICENSE).
