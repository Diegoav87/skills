---
name: flow-map
description: Trace existing code and draw its flow as diagrams in one HTML file, every arrow cited to the code.
disable-model-invocation: true
---

# Flow map

A flow map is a **trace of what the code does today**, drawn. The code is the source; `ARCHITECTURE.md` is the map for finding it and the tests are claims to check against it.

The target is whatever the user names: a module, a feature, a file, an endpoint, or a flow that crosses modules.

## 1. Find the entry points

Resolve the target to the places where execution starts: HTTP routes, webhook handlers, queue processors and schedulers, socket events, and exported services that other modules call.

Done when every entry point of the target is listed with its `file:line`. For a target larger than about ten entry points, show the list to the user and agree which ones to trace.

## 2. Trace each entry point to its effects

Follow each entry point through the code, across module edges, until it reaches its **effects**:

- rows written (table, columns, inside which transaction, under which lock)
- status transitions (from → to, and the condition that guards them)
- Redis keys and queue jobs written
- calls to external providers, and what happens when the provider fails
- what runs after the commit, and whether its failure is swallowed

Done when every entry point has its effects listed with a `file:line` each, and every literal of each status union involved has a transition leading into it or is marked unreachable.

## 3. Pick the views

One view per question the target raises:

- **State diagram**: an entity with a status column. One per entity.
- **Sequence diagram**: a request that crosses modules, providers, or queues. One per entry point worth telling; group the trivial ones.
- **Write map**: a table of entry point × table written, when several entry points write the same tables.

## 4. Write the file

One self-contained HTML file named after the target, in the folder where the repo already keeps diagrams; `docs/diagrams/` when it has none. Build the page from [PAGE.md](PAGE.md). In this order:

1. **Overview**: one diagram and one paragraph a non-developer can follow, in business words.
2. **Detail**: the views from step 3. Under each diagram, an evidence table: one row per arrow, with what it does and its `file:line`.
3. **Surprises**: what the code does that the docs or tests leave unsaid, and paths with no test.
4. **Your explanation against the code**, only when the user explained the flow earlier in the conversation: each of their claims marked right, wrong, or missing, with the `file:line` that settles it.

Write the text in the language of the repo's docs. Name the file in that language too.

## 5. Check

- Every arrow in every diagram has a row in its evidence table.
- Every `file:line` was read in this session.
- The file renders: open it in a browser when one is available; otherwise say in the reply that rendering is unchecked.

Reply with the path, the surprises, and nothing the file already says.
