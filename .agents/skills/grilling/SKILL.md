---
name: grilling
description: Grill the user about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user until you reach a shared understanding. Map the plan as a
**design tree**: every decision branches into the decisions that hang off it. Show
the tree first, each branch with your recommended answer, so the user can prune
before you ask anything.

## Work the tree in rounds

The **frontier** is every decision whose prerequisites are settled: the questions
you can ask now without guessing at answers you haven't heard. A question that
depends on another question still open belongs to a later round.

Sort the frontier by stakes:

- **Load-bearing** — hard to reverse, branches the tree, a real trade-off. Each one
  is its own numbered question with your recommended answer.
- **Low-stakes** — an obvious default, cheap to change later. One list at the end of
  the round, recommended answer each; the user accepts them in a word or overrides
  the few they care about.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, may include choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body>

➡️ <your recommended answer>

**Defaults** — say "ok" to accept all:
- <decision>: <recommended answer>
- <decision>: <recommended answer>
```

Wait for the answers. Each round reshapes the tree: settled decisions push the
frontier outward and unblock what depended on them. Recompute the frontier and ask
the next round.

## Facts are yours, decisions are the user's

Finding facts (filesystem, tools, code, docs) is your job, never the user's. When a
frontier question needs a fact, dispatch a sub-agent to find it and don't block on
it: only the questions downstream of that fact wait; ask the rest of the frontier
now. The decisions are the user's: put each to them and wait.

## Stop when the stakes run out

The session is done when the frontier is empty, or when only low-stakes decisions
remain: list those with their defaults and ask for one confirmation. Don't
manufacture questions to seem thorough. Do not act on any of it until the user
confirms you have reached a shared understanding.
