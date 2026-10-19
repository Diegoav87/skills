---
name: setup-skills
description: "Configure this repo for the skills: its issue tracker and labels. Run once before first use of the other skills."
disable-model-invocation: true
---

# Setup Skills

Scaffold the small per-repo configuration the other skills read:

- **Issue tracker**: where specs and tickets live, written to `docs/agents/issue-tracker.md`
- **Labels**: the six labels the skills apply and remove
- **An `## Agent skills` block** in `CLAUDE.md` or `AGENTS.md` pointing at the tracker file and at `GLOSSARY.md`

Explore, present what you found, confirm with the user, then write.

## 1. Explore

Read whatever exists; don't assume:

- `git remote -v`: is this a GitHub repo? Which one?
- `CLAUDE.md` and `AGENTS.md` at the repo root: does either exist, and does it already have an `## Agent skills` block?
- `docs/agents/issue-tracker.md`: output from an earlier run
- `.scratch/`: a sign that local markdown tickets are already in use
- `GLOSSARY.md` at the root
- **Documentation in another shape**: `docs/adr/`, `ARCHITECTURE.md` or `CONTEXT.md` files at any level, design docs, planning files from another skill system, a `CLAUDE.md` grown into an architecture description. List these; don't read them yet.

## 2. Ask

Take the questions in order, one answer each. Lead each with the recommended answer so the user can accept it in a word.

**Issue tracker.** If a remote points at GitHub, propose GitHub. Otherwise offer:

- **GitHub**: issues in the repo's GitHub Issues, through the `gh` CLI
- **Local markdown**: files under `.scratch/` in this repo, for solo work or a repo without a remote
- **Other** (GitLab, Jira, Linear, ...): the user describes the workflow in a paragraph

**Labels.** GitHub and other trackers only. Ask one question: keep the default label names? (recommended: **yes**). Only if the tracker already uses other names, collect the overrides so the skills apply the existing labels.

**Old documentation.** Only if exploration found some. Agents that come across it will believe it, and no skill keeps it true. Recommend retiring it (step 4).

## 3. Confirm, then write

Show the user drafts of the `## Agent skills` block and `docs/agents/issue-tracker.md`, and let them edit before writing.

Write the block into `CLAUDE.md` if it exists, else into `AGENTS.md` if that exists. If neither exists, ask which one to create. Update an existing `## Agent skills` block in place and leave the rest of the file alone.

```markdown
## Agent skills

Read `GLOSSARY.md` at the repo root, if it exists, before exploring. Use its terms when you name things: code, tests, issues, commit messages.

Specs and tickets live in [GitHub Issues / `.scratch/` / ...]; `ready-for-agent` marks work an agent may pick up. How to read and write them: `docs/agents/issue-tracker.md`.
```

Write `docs/agents/issue-tracker.md` from the template for the chosen tracker:

- [issue-tracker-github.md](./issue-tracker-github.md)
- [issue-tracker-local.md](./issue-tracker-local.md); also add `.scratch/` to `.gitignore`

For any other tracker, write it from the user's description, covering the same operations as the GitHub template, and keep its label table.

On GitHub, create each label the repo lacks: check with `gh label list`, then `gh label create <name>`. If `gh` is missing or not logged in, tell the user to install it or run `gh auth login`, and finish the rest of the setup.

## 4. Retire old documentation

Only when the user agreed in step 2.

1. Read the old documents in subagents when there are more than a few, so the main context holds only what they extract.
2. Move the project's domain terms into `GLOSSARY.md`. Call the Skill tool with "domain-modeling" for the format.
3. List any planned work the documents describe that isn't built yet, and offer to file it on the tracker.
4. Delete the old documents in their own commit, so the removal reverts cleanly. In `CLAUDE.md`, remove only the sections the user agrees to.

## 5. Done

Tell the user what was written and created. They can edit `docs/agents/issue-tracker.md` directly later; rerunning this skill is only needed to switch trackers.
