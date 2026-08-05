---
name: research
description: Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent.
---

Spin up a **background agent** to do the research, so you keep working while it reads.

Its job:

1. Investigate the question against **primary sources** — official docs, source code, specs, first-party APIs — not a secondary write-up of them. Follow every claim back to the source that owns it.
2. Write the findings to a single Markdown file, citing each claim's source.
3. Save it to `docs/research/`, matching the existing convention there if one exists.

Research notes rot faster than anything else in the repo — an API changes and the
note is quietly wrong. So they sit outside the default read path and carry their own
expiry signal: open the file with the date it was written and the exact versions it
was verified against. A later reader checks that line before trusting a word of it.
