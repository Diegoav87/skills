# Skills

A small, opinionated set of agent skills for shipping software with an AI coding agent: sharpen the idea, write it down once, build it in slices, and review it.

Nineteen skills, one workflow, one documentation file. Setup is two questions, and nothing in the skills assumes a language, framework, or repo layout. Works with Claude Code, Codex, and any agent that reads `SKILL.md` files from `.agents/skills/`.

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
- **Model-invoked**: the agent reaches for them when the task fits, like `/tdd` while implementing or `/code-review` when you ask for a review. You can still call them by name.

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

It asks two questions: where issues live (GitHub, local markdown files, or something you describe) and whether to keep the default label names. It writes `docs/agents/issue-tracker.md` and adds a four-line `## Agent skills` block to your `CLAUDE.md` or `AGENTS.md`.

If the project already has documentation in another shape (ADRs, architecture docs, design docs), it offers to retire it: domain terms move into `GLOSSARY.md`, unbuilt plans go to the tracker, and the old files are deleted in their own commit.

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

A branch ready to merge
  └── you review the commits ──► /pr ──► you merge

You had to correct the agent for something that will happen again
  └── /retro, before you clear the session

An idea you cannot work on now
  └── file it as a two-line issue labelled needs-grilling; pick it up later

A plan whose decisions belong partly to someone else
  └── /grill-with-docs ──► questionnaire issue ──► answers ──► resume the grill ──► /to-spec
```

The full flow, step by step:

1. **`/grill-with-docs`**. The agent interviews you about the plan in rounds. Each round asks every question whose answer does not depend on another open question, with a recommended answer for each. Big decisions get their own question; small ones collapse into a defaults list you accept in a word. As terms settle, it writes them into `GLOSSARY.md`. Nothing is built yet. If a question cannot be settled on paper, `/prototype` answers it with throwaway code. If a question is someone else's call, say so: the interview carries on with the rest, then pauses on a questionnaire issue holding what you settled and what the other person must decide. When the answers are in, it asks only what they unblocked.
2. **`/to-spec`**. Turns the conversation into a spec on your issue tracker. No new interview. It labels the issue `spec` and `ready-for-agent`.
3. **`/to-tickets`**. Splits the spec into tracer-bullet vertical slices, each declaring which tickets block it. Only when slices can genuinely run in parallel. If the work is one slice, it stays one ticket.
4. **`/implement`**, one ticket per fresh session. Marks the ticket `in-progress`, uses `/tdd` at seams agreed up front, reviews the change at the right scale and fixes what the review finds, marks the ticket `needs-review`, and commits to the current branch. It never pushes, merges, or rewrites history. It ends with a reading guide: what changed, which files to read in which order, and what was run.
5. **`/pr`**, once you have read the commits and the branch is ready. It reruns the tests, pushes, and opens a pull request against `main` whose body shows the change, the evidence it works, and the risk of merging, with `Closes #n` for each ticket. Merging it closes them. One pull request per branch, however many `/implement` sessions built it.

Keep steps 1 to 3 in one context window. Between phases, `/ask-skills` has a five-step tree for deciding whether to continue, clear, hand off, send work to a subagent, or compact.

---

## Skills reference

Each entry says who invokes the skill, what it does, and then the same thing in plain words.

### The main flow

**`grill-with-docs`**, invoked by you. Runs `grilling` with `domain-modeling` active, so the interview keeps the glossary current.
In plain words: the agent asks you questions about what you want to build, and writes down the words you agree on as it goes.

**`to-spec`**, invoked by you. Turns the current conversation into a spec on the tracker, labelled `spec` and `ready-for-agent`. If the work fits one session, it tells you to skip it.
In plain words: it writes up what you just discussed as one issue that someone else, or a later session, can build from. It first checks the work is big enough to deserve that.

**`to-tickets`**, invoked by you. Spec to tracer-bullet tickets with blocking edges, as sub-issues of the spec. Handles wide refactors as expand, migrate, contract. Publishes as tracker issues or as one file per ticket under `.scratch/`.
In plain words: it cuts a spec into pieces that can each be built and tested on their own, and records which piece has to finish before which. A tracer bullet is a thin slice that goes all the way through, from database to screen, rather than one layer at a time.

**`prototype`**, invoked by the agent. Throwaway code that answers one design question: an HTML file that drives a state model through hard cases, or several UI variations on one route. Lands on a throwaway branch; main keeps only the decision.
In plain words: when talking cannot settle whether a design is right, the agent builds a quick disposable version so you can click through it and decide.

**`implement`**, invoked by you. Builds one ticket. TDD at agreed seams, review scaled to the change with its findings fixed, moves the ticket's labels and its parent's checklist, commits on the branch, ends with a reading guide.
In plain words: it builds one piece of work, checks it, and finishes by telling you what changed and in which order to read the files.

**`pr`**, invoked by you. Checks the branch is ready and the tests pass, pushes it, and opens a pull request against `main` (or the branch you name). The body has a summary visual, before and after evidence from real runs, a one-way or two-way door call with the blast radius, and `Closes #n` for each ticket the branch completes.
In plain words: when you are happy with the commits, this writes a pull request a reviewer can take in at a glance, and opens it. Merging is still yours.

**`flow-map`**, invoked by you. Traces existing code from its entry points to its effects, then draws it: state diagrams, sequence diagrams and a write map in one self-contained HTML page, every arrow cited to a `file:line` in an evidence table, dated with the commit it traces. Ends with the surprises: what the code does that the docs and tests leave unsaid.
In plain words: when a flow is too tangled to hold in your head, it reads the code for you and draws what actually happens, with a pointer to the line behind every arrow. Run it before grilling a change to that flow.

**`code-review`**, invoked by the agent. Three-axis review of a diff since a fixed point, each axis in its own subagent and reported separately: **Standards** (repo conventions plus a fixed smell baseline), **Spec** (does it do what was asked), and **Correctness** (bugs, edge cases, security, and whether the new behaviour is tested well). For diffs that touch shared code, a fourth block names the one fact the change is safe because of and proves it by running code.
In plain words: three fresh reviewers look at the change. One asks "is this written the way this project writes code", one "does it do what the ticket asked", one "where does it break". If the change touches something other code depends on, a last check says what could break elsewhere and how sure it is.

### Building

**`tdd`**, invoked by the agent. The red-green loop, with what a good test is, where tests go (seams), and the anti-patterns to avoid. Each proposed seam comes with what it catches and what it misses. Prefers no new test over a bad one. Refactoring is left to review.
In plain words: write a test that fails, write just enough code to make it pass, repeat. Tests go at the places you agreed on up front, and if the only test you could write would be a bad one, the agent uses a script or a manual check instead and says so.

**`codebase-design`**, invoked by the agent. The deep-module vocabulary `tdd` uses when the shape of an interface is the question: module, interface, seam, adapter, depth, leverage, locality. Includes guides for deepening a cluster and designing an interface twice.
In plain words: one idea, that a good module hides a lot of work behind a few functions, so whoever calls it, including a test, only has to learn a little. A **seam** is the place where you can swap what is behind the interface, and an **adapter** is one concrete thing plugged in there, like a real Postgres store or an in-memory fake for tests.

### Language and interviews

**`domain-modeling`**, invoked by the agent. Sharpens the project's terms as you design and keeps them in one `GLOSSARY.md` at the repo root.
In plain words: it keeps a list of what the project's words mean, and which words to avoid. When the code calls something by a different name, the glossary says so.

**`grilling`**, invoked by the agent. Interview to stress-test a plan, in rounds over the decision tree. Big decisions get their own question, small ones collapse into a defaults list. A decision that belongs to someone outside the session is deferred: the interview pauses on a questionnaire issue and resumes when the answers are in.
In plain words: the questioning engine behind `grill-with-docs`. Use it alone for a decision that touches no code. When a question is your boss's call, it writes your boss a questionnaire instead of guessing.

### Around the session

**`research`**, invoked by the agent. Delegates reading to a background agent that works from primary sources and writes a cited note, dated and naming the versions it checked. Notes are never updated; newer findings get a new note.
In plain words: you ask a question, an agent reads the official docs in the background and leaves a dated note. The date is there because research goes stale fast.

**`retro`**, invoked by you. Looks back at a session where the agent went wrong and proposes changes to its environment: an automated check for a mechanical mistake, a rule in `CODING_STANDARDS.md` for a judgement call, a glossary entry, a pointer to a hard-to-find file. Applies only the ones you pick, and shows each new check failing on the real mistake first.
In plain words: when you had to correct the agent, this makes the repo stop the same mistake next time. Run it in the same session, and only for mistakes that will come back.

**`handoff`**, invoked by you. Writes a portable markdown file to your temp folder so a session elsewhere can pick up. Narrow: for a new tool, a new folder, a colleague, or a side task.
In plain words: a note for a different session to continue from. Most of the time you do not need it; `/ask-skills` explains the other four options.

**`ask-skills`**, invoked by you. The router. Tells you which skill or flow fits your situation, and what to do at the boundary between two phases of work.
In plain words: the map. When you do not know what to run, run this.

**`writing-for-agents`**, invoked by the agent. Rules for any text an agent will read: skills, `CLAUDE.md`, pointed-to docs. Loaded when creating or editing a skill.
In plain words: how to write instructions so an agent follows them the same way every time. Used when editing this repo.

**`unslop`**, invoked by the agent. Cuts AI tells from any text you will read: filler, hedging, fancy words, em dashes, chatbot phrases. Copied from pstack.
In plain words: makes the agent's writing read like a person wrote it. Fires on answers, summaries, docs, and comments.

### Setup

**`setup-skills`**, invoked by you. One-time repo configuration: issue tracker and labels. Offers to retire documentation in another shape.
In plain words: run once per project. It asks two questions and writes the small file the other skills read.

---

## The documentation model

One file: **`GLOSSARY.md`** at the repo root, monorepos included. It holds the project's domain terms, one or two sentences each, with the words to avoid and the code's name for the term when it differs:

```md
**Fletero** (`carrier`):
Whoever offers the transport and owns the vehicles. A person or a company.
_Avoid_: transportista, proveedor, socio
```

`domain-modeling` creates it the first time a term settles and rewrites an entry when its meaning changes. It holds terms and nothing else.

Everything else has a home that changes with it:

- **A decision being made** lives in the conversation, then in the spec and its tickets.
- **A decision that's built** lives in the code. The agent reads code faster than it reads a description of it.
- **A reason the code can't show** goes in a comment beside the code it governs, and is deleted with it.
- **A rule for the whole repo**, one an agent would otherwise break, goes in `CLAUDE.md` as a convention.

Why only a glossary: an earlier version of these skills kept an `ARCHITECTURE.md` and a `CONTEXT.md` at every level of the repo, updated by every ticket. In a real project the architecture files grew with the number of tickets rather than the size of the system: two thirds of the commits over six weeks touched them, one reached 1,100 lines, and parts went stale. The glossary in the same project stayed short and useful. Terms change rarely, and the code can't tell an agent that the business says "fletero" for what the code calls `carrier`, and never "transportista".

Two kinds of file are snapshots and say so: research notes and flow maps open with the date and the versions or commit they describe, and are never updated.

---

## Conventions the skills assume

- **The agent commits; it pushes only when you run `/pr`.** Committing is local and reversible, so skills do it on the current branch and say what they committed. Pushing happens only through `/pr`, which you invoke after reading the commits. Merging, rebasing, amending, force-pushing, and committing on `main` are yours.
- **Comments are about the code beside them.** They explain non-obvious logic and the reasons the code can't show. No pointers to specs, tickets, or issue numbers. Written in plain words, because comments are text you read.
- **Issue tracker.** GitHub Issues through the `gh` CLI, local markdown files under `.scratch/`, or anything you describe once. `docs/agents/issue-tracker.md` says which, and the skills follow it.
- **Labels are moved by skills, not by hand.** Four states, `needs-grilling`, `ready-for-agent`, `in-progress`, `needs-review`, each applied and removed by the skill that changes it, so a filter on any one of them is always true. Two kinds, `bug` and `spec`, set once when filing. The tracker file lists who owns each.
- **`.scratch/` is scaffolding**, not record. Local tickets live there, get deleted when done, and the directory is gitignored.
- **`docs/research/`** holds research notes, unless the repo already keeps them elsewhere.

---

## How this differs from the original

This started as a fork of [mattpocock/skills](https://github.com/mattpocock/skills), which ships 31 skills plus 7 in progress across four directories. This repo keeps 17 of them, adds two (`flow-map`, and `unslop` from pstack), and flattens everything into a single namespace. The reasoning behind each change:

**Fewer skills.** A skill you do not use is not free. It is one more thing the agent can reach for, and one more thing you have to remember exists before deciding it does not apply. Dropped: the `in-progress/` skills, the `misc/` skills (one-off tooling tied to a TypeScript setup), the productivity skills for prose and teaching, the engineering skills built for inbound issue queues (`triage`, `wayfinder`) or occasional upkeep (`improve-codebase-architecture`, `wizard`), `diagnosing-bugs`, which no bug here has needed, and `implement-spec`, whose parallel worktrees cost more machinery than running `/implement` per ticket.

**A size gate at the front.** Upstream's recommended flow is always spec, then tickets, then implement. That generates ceremony for work that fits in one session. Here, `/to-spec` and `/to-tickets` both check first whether they are worth running, and `/ask-skills` routes by size before anything else.

**A glossary and no ADRs.** Upstream records decisions as ADR files next to its glossary. ADRs pile up, and many go stale as the code moves on. Here there is only the glossary; decisions live in the spec while they are being built and in the code once they are. See [The documentation model](#the-documentation-model).

**Setup in two questions.** Upstream's setup also configures triage labels and a multi-glossary layout. Here it asks where issues live and whether to keep the label names, and supports local markdown tickets for repos without GitHub.

**`implement` does more.** Upstream's is six lines. This one scales review to the size of the change and fixes what it finds, moves the ticket's labels and the parent issue's checklist, draws the line between what the agent may do in git (commit) and what it may not (push, merge, rewrite history), and closes with a reading guide so you can follow the change file by file.

**`code-review` looks for bugs.** Upstream reviews on two axes, Standards and Spec. This one adds Correctness, a third reviewer for wrong logic, edge cases, security, and the quality of the new tests, plus a blast-radius block for changes to shared code.

**Six labels instead of five triage states.** Upstream's labels serve a triage skill for issues from strangers. Here each label is applied and removed by the skill that changes an issue's state, so none needs a human to keep it true, and two kind labels make the roadmap and the bug list filterable.

**`grilling` sorts by stakes and handles other people's decisions.** Upstream's grilling asks every currently askable question at once. The version here keeps that and adds a sort: load-bearing decisions get their own question, low-stakes ones collapse into a defaults list accepted in a word. When a question is someone else's call, the interview pauses on a questionnaire issue instead of a separate `to-questionnaire` skill; the questionnaire's structure is upstream's.

**`pr` opens the pull request, and `retro` writes checks.** Upstream's `pr` is a body template the agent applies whenever it writes a PR. Here it is the one step where the agent pushes, invoked by you, and it reruns the tests for its evidence and links the tickets so merging closes them. `retro` keeps upstream's categories and its split between automated checks and `CODING_STANDARDS.md`, adds glossary fixes, and takes from pstack's `correct` the rule that a new check must be seen failing on the real mistake.

**`flow-map` is new.** Before changing a complex flow you need to know what it does today, and docs and tests only tell part of it. The skill traces the code from entry points to effects and draws the result as diagrams in one HTML page, with every arrow backed by a `file:line`. A diagram without evidence is a guess that looks like a fact.

**Borrowed from pstack.** `unslop` as a skill. In `code-review`, the blast-radius block with its ladder of how sure a finding is. In `tdd`, the rules that a test must fail for the right reason and that no new test beats a bad test. In `writing-for-agents`, the rule to state the instruction and skip the reason. pstack's mode skill, playbooks, principle files, and multi-model routing were reviewed and not taken.

`SYNC.md` records the commit of each source repo that every skill was last compared against, and the decision taken.

---

## Credit and license

Built on [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock, whose README says *"Hack around with them. Make them your own."* If you are starting from scratch, read the original first. It is more complete, and you may cut it differently than this repo did.

`unslop` is copied from [pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan (MIT), with a changed description. Ideas borrowed from pstack are listed above.

MIT. See [LICENSE](LICENSE).
