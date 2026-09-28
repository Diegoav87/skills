---
name: setup-skills
description: Configure this repo for the engineering skills — set up its issue tracker and domain doc layout. Run once before first use of the other engineering skills.
disable-model-invocation: true
---

# Setup Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — where issues live (GitHub by default)
- **Labels** — the `ready-for-agent` label the skills apply
- **Domain docs** — where `CONTEXT.md` and `ARCHITECTURE.md` live, and the consumer rules for reading them

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config` — is this a GitHub repo? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section in either?
- `CONTEXT.md` and `ARCHITECTURE.md`, at the repo root and at any level below it
- **Existing documentation in some other shape** — `docs/adr/`, `docs/rfc/`, `architecture/`, `design/`, planning files from another skill system, a `CLAUDE.md` that has grown into a design document. Note what you find and **stop there**: this skill scaffolds config, it does not migrate content. Point the user at `/migrate-docs` and let them decide.
- `docs/agents/` — does this skill's prior output already exist?
- **The module structure of the code** — the level at which it's carved into areas a task would touch one at a time: `src/*/`, `apps/*/src/*/`, top-level packages with distinct responsibilities. This is what the doc levels mirror.
- **Repo shape** — a `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or a populated `apps/*` or `packages/*`. This tells you how deep the levels run: a monorepo gets one more level than a standalone project, and nothing else changes.

### 2. Present findings and ask

Summarise what's present and what's missing. Then take the sections in order — one section, one answer, then the next.

Lead each section with the recommended answer so the user can accept it in a word. Give a one-line explainer only when the choice genuinely branches; skip the section entirely when exploration already settled it (Section C when there's no monorepo).

**Section A — Issue tracker.**

> Explainer: The "issue tracker" is where issues live for this repo. Skills like `to-spec`, `to-tickets`, `implement`, and `code-review` read from and write to it — they need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe. Pick the place you actually track work for this repo.

Default posture: these skills are set up for GitHub. If a `git remote` points at GitHub, propose that. Otherwise (or if the user prefers), offer:

- **GitHub** — issues live in the repo's GitHub Issues (uses the `gh` CLI)
- **Other** (GitLab, Jira, Linear, local markdown, etc.) — ask the user to describe the workflow in one paragraph; the skill will record it as freeform prose

Record the choice in `docs/agents/issue-tracker.md`.

**Section B — Labels.** The engineering skills apply one label: `ready-for-agent`, marking an issue/ticket as fully specified and ready to implement (`/to-spec` and `/to-tickets` apply it; `/implement` picks it up). Ask exactly one question:

> Keep the default label string `ready-for-agent`? (recommended: **yes**)

On **yes**, record it as-is. Only if the user's tracker already uses a different string, collect the override so the skills apply the existing label instead of creating a duplicate.

**Section C — Domain docs.** The layout is always the same pair — `CONTEXT.md` + `ARCHITECTURE.md` — repeated at each level of the repo, with each level listing its children. The only thing to settle is **what the levels are**.

Propose the levels from what exploration found, mirroring the repo's real structure:

- A standalone project → root + one level of modules.
- A monorepo → root + one level per app + the modules inside each app.

Then confirm with the user, and note two things so they aren't surprised later:

- **Only the root files are guaranteed.** Everything below is created lazily, and only where a level has something of its own to say. Most modules end up with an `ARCHITECTURE.md` and no `CONTEXT.md`; some end up with neither and just a line in their parent's module list.
- **Nothing is repeated downward.** A fact lives at the highest level where it's true. That's what makes the descent cheap and what keeps two levels from disagreeing.

See `ARCHITECTURE-FORMAT.md` and `CONTEXT-FORMAT.md` in the `domain-modeling` skill.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `docs/agents/issue-tracker.md` and `docs/agents/domain.md`

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create — don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa) — always edit the one that's already there.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Reading this repo

Read `CONTEXT.md` and `ARCHITECTURE.md` at the root before exploring.
`ARCHITECTURE.md` lists this level's modules in one line each and the edges between
them. Descend only into the modules your task touches, reading each level's
`CONTEXT.md` + `ARCHITECTURE.md` on the way down. Don't read branches you aren't
changing.

Check the edges as you descend: if your work crosses into a sibling module — a
shared type, an event, a call signature, a route — that module is part of your task
and gets read too.

These files are present-tense and can be trusted without checking their age.
Project history lives in the issue tracker and in git; don't read it as background.

Fuller rules, including what to do when your work contradicts them:
`docs/agents/domain.md`.

### Reference documents

[Omit this whole section if the project has none]

Outside the descent. Don't read them as background: open one only when its trigger
fires, and update it in the same change that makes it false.

| Document | Open it when                                                       | Update it when                            |
| -------- | ------------------------------------------------------------------ | ----------------------------------------- |
| [path]   | [trigger, written so it can be ruled out without opening the file] | [the concrete change that makes it false] |

For anything already built the code and the `ARCHITECTURE.md` files win; a reference
document that contradicts them is out of date.

**Dated notes** (`docs/research/`): never maintained, never trusted without
checking. They describe a moment — verify against reality before acting.

### Issue tracker

[one-line summary of where issues are tracked, and that `ready-for-agent` marks work an agent may pick up]. See `docs/agents/issue-tracker.md`.

### Domain docs

[one-line summary of the levels — e.g. "root + modules under `src/`", or "root + apps + their modules"]. See `docs/agents/domain.md`.
```

The descent instruction is written out **inline** rather than left behind the
pointer, and deliberately so. `CLAUDE.md` is the only file guaranteed to be read;
`docs/agents/domain.md` is read only if the agent follows the link. A rule that
governs how everything else gets read has to live in the file that's always there,
or it's a rule that sometimes doesn't apply. Everything that's reference rather than
instruction stays behind the pointer.

The **register of reference documents** is inline for the same reason, and it's the
stronger case: a document nobody knows exists is never opened, and one whose write
trigger nobody has read is never updated. Behind a pointer, the register fails in
both directions at once. Keep it to one row per document — the fuller rules on what
qualifies live in `docs/agents/domain.md`.

**Check the rest of `CLAUDE.md` while you're in it.** It should hold only how to
_work_ in the repo: commands, conventions not visible from the code, environment
quirks, and this block. Point out to the user, without rewriting their sections,
any of these:

- **Architecture description** — belongs in `ARCHITECTURE.md`.
- **Domain vocabulary** — belongs in `CONTEXT.md`.
- **History** — what the project used to do, migrations in progress. Delete.

If it has grown well past that, offer `/migrate-docs`.

Then write the docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub issue tracker, including the `ready-for-agent` label
- [domain.md](./domain.md) — domain doc consumer rules + layout

For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` directly later — re-running this skill is only necessary if they want to switch issue trackers or restart from scratch.
