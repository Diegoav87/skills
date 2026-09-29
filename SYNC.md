# Sync record

Last reviewed commit per reference repo, and the decision per skill. Update this whenever a comparison is done.

## mattpocock/skills

- Cloned at: `c55ee46` (2026-09-18)
- Last full comparison: none yet. Our skills were copied on 2026-08-05 from an unrecorded commit.

| Our skill | Upstream path | Decision |
|---|---|---|
| to-spec, to-tickets, code-review, resolving-merge-conflicts | skills/engineering/* | Reviewed 2026-09-28; ours kept, upstream changes were punctuation only. |
| tdd | skills/engineering/tdd | Ours kept (seams agreed once). Two rules added from pstack's tdd. |
| implement | skills/engineering/implement | Ours kept; upstream is six lines. Added a reading-guide ending and a comment readability rule. |
| diagnosing-bugs | skills/engineering/diagnosing-bugs | Ours kept (post-mortem). Redact section taken from upstream. |
| handoff, research | skills/* | Reviewed 2026-09-28; ours kept unchanged. |
| wayfinder, triage, improve-codebase-architecture, grill-me, wait-what, teach, to-questionnaire | skills/* | Reviewed 2026-09-28, not taken. Six labels adopted instead of triage. |
| ask-skills | skills/engineering/ask-matt | Ours kept as the map. Added more starting points and his phase-boundary tree; PHASE-BOUNDARIES.md copied verbatim (2026-09-28). wizard, reflect (pstack) not taken. |
| grill-with-docs | skills/engineering/grill-with-docs | His invocation line (2026-09-28); our description. grill-me and wait-what reviewed and not taken. |
| prototype | skills/engineering/prototype | Copied verbatim at `c55ee46` (2026-09-28). |
| grilling | skills/productivity/grilling | Blended (2026-09-28): his rounds, frontier and question format; our stakes sort and defaults list. |
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
