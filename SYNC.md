# Sync record

Last reviewed commit per reference repo, and the decision per skill. Update this whenever a comparison is done.

## mattpocock/skills

- Cloned at: `c55ee46` (2026-09-18)
- Last full comparison: none yet. Our skills were copied on 2026-08-05 from an unrecorded commit.

| Our skill | Upstream path | Decision |
|---|---|---|
| to-spec | skills/engineering/to-spec | Rebased on his text at `49dd158` (2026-10-18). Ours keeps: the size gate, waiting on an open questionnaire, the `spec`/`ready-for-agent`/`needs-grilling` labels, and lean user stories instead of his "extremely extensive" list. |
| to-tickets | skills/engineering/to-tickets | Rebased on his text at `49dd158` (2026-10-18), taking sub-issues under the source issue and dropping "Blocked by" when edges are native. Ours keeps: the size gate, the parent left for `/implement` to move, and the closing one-ticket-per-`/implement` line. |
| code-review | skills/engineering/code-review | Reviewed at `49dd158` (2026-10-18). Taken: search for every standards file, foreground sub-agents. Ours adds a Correctness axis (bugs and test quality), `file:line` on every finding, review without a tracker file, and the blast-radius block. |
| resolving-merge-conflicts | skills/engineering/resolving-merge-conflicts | Removed (2026-10-19), as upstream did at `49dd158`: the agent resolves conflicts without it. |
| tdd | skills/engineering/tdd | Ours kept (seams agreed once). Two rules added from pstack's tdd. His per-seam catches/misses note taken at `49dd158` (2026-10-18). |
| implement | skills/engineering/implement | Ours kept; upstream is six lines. Taken at `49dd158` (2026-10-18): fetch the ticket and state its title, Skill tool calls. Ours: labels, review scaled to size and findings fixed, glossary and comment checks, parent moved, commit only, reading guide. implement-spec reviewed and not taken (worktree machinery against a simple workflow). |
| diagnosing-bugs | skills/engineering/diagnosing-bugs | Removed (2026-10-19): never used; bugs get fixed inside `/implement`. Re-add from upstream if a hard bug calls for it. |
| handoff | skills/productivity/handoff | His temp-dir resolution and Skill-tool wording taken at `49dd158` (2026-10-19); ours also reports the path. |
| research | skills/engineering/research | Reviewed at `49dd158` (2026-10-19). Ours kept: dated notes under `docs/research/` unless the repo keeps them elsewhere, never updated; adds a short answer to the user. |
| wayfinder, triage, improve-codebase-architecture, grill-me, wait-what, teach | skills/* | Reviewed 2026-09-28, not taken. Six labels adopted instead of triage. |
| to-questionnaire | skills/productivity/to-questionnaire | Not taken as a skill. Its document template folded into grilling/QUESTIONNAIRE.md at `c55ee46` (2026-10-04); the grill defers questions owned by someone else and pauses on a `needs-grilling` issue. |
| ask-skills | skills/engineering/ask-matt | Ours kept as the map. Added more starting points and his phase-boundary tree; PHASE-BOUNDARIES.md copied verbatim (2026-09-28). wizard, reflect (pstack) not taken. Rewritten for the glossary model (2026-10-19); took his line to read a skill's SKILL.md before asserting what it does. |
| setup-skills | skills/engineering/setup-matt-pocock-skills | Rewritten (2026-10-19): tracker and labels only, plus an optional step that retires old docs (replaces our migrate-docs, removed). From his: `gh issue view --json`, `--parent` sub-issues, and a local-markdown tracker template adapted to our labels. Not taken: GitLab template, triage labels, `domain.md`. |
| grill-with-docs | skills/engineering/grill-with-docs | His invocation line (2026-09-28); our description, now naming the glossary only (2026-10-18). grill-me and wait-what reviewed and not taken. |
| domain-modeling | skills/engineering/domain-modeling | Adopted his at `49dd158` (2026-10-18): one root `GLOSSARY.md` and `GLOSSARY-FORMAT.md`. Not taken: ADRs and `GLOSSARY-MAP.md`. Ours adds the code identifier in backticks and rewriting an entry in place. Our `ARCHITECTURE.md` descent and reference documents retired. |
| prototype | skills/engineering/prototype | Copied verbatim at `c55ee46` (2026-09-28); upstream unchanged at `49dd158`. |
| grilling | skills/productivity/grilling | Blended (2026-09-28): his rounds, frontier and question format; our stakes sort and defaults list. His "yes accepts the recommendation" line taken at `49dd158` (2026-10-18). |
| writing-for-agents | skills/productivity/writing-for-agents | Copied at `c55ee46` (2026-09-28) with SKILL-MECHANICS.md. Ours adds two Pruning lines taken from pstack's authoring-a-skill playbook. |
| (others pending first comparison) | | |

## cursor/plugins (pstack)

- Cloned at: `ecc249f` (2026-09-25), sparse checkout of `pstack/` only
- Last full comparison: none yet.

| Our skill | pstack path | Decision |
|---|---|---|
| blast-radius | skills/blast-radius | Not copied; its certainty ladder and one-safety-fact rule folded into code-review (2026-09-28). |
| tdd | skills/tdd | Not copied; two rules folded into our tdd. |
| architect, interrogate, show-me-your-work, no-comments | skills/* | Reviewed 2026-09-28, not taken. |
| unslop | skills/unslop | Copied at `ecc249f` (2026-09-28). Ours: model-invoked, with a trigger description. Body unchanged; re-diff on each sync. |
| (others pending first comparison) | | |
