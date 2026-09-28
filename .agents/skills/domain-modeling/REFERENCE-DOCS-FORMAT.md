# Reference documents

Some facts are true of the whole system and belong to no single level: the complete
database schema, the shape of parts not built yet, infrastructure and deployment, a
cross-cutting inventory whose value is that it's in one place (every scheduled job,
every external integration, every feature flag). They can't go in the descent —
`ARCHITECTURE.md` is per-level — and they're too large for a file every session
pays to read. So they live in `docs/`, outside the descent, and are **registered in
`CLAUDE.md`**, one row each:

```md
| Document | Open it when | Update it when |
|---|---|---|
| `docs/dbdiagram.dbml` | you will touch the schema, or implement a module whose tables don't exist yet | the schema changes — always, in the same change |
```

## Both triggers are required

- **Open it when.** Written so a reader can rule the document out _without opening
  it_. A document that can't be ruled out is read every time or never.
- **Update it when.** A concrete event you can answer yes or no to at the end of a
  change — "the schema changed", not "things moved".

A document you can't write both triggers for is not a reference document. Re-check
whether it's really architecture (then it belongs at a level) or really backlog
(then it belongs in the tracker).

## Scope

Reference documents cover **what is and what is planned to be**. Work to be built
goes to the tracker; how the project got here goes to git and the issue threads.
Two or three documents is normal for a project of any size; a long register means
history is being refiled instead of dropped.

## Two contracts, never mixed

- **Maintained reference** — present tense, updated with the change that moves it,
  trusted without checking its age.
- **Dated note** — `docs/research/`, dated in the filename, **never updated**.
  Rewriting one destroys the only thing that made it safe: knowing what it was true
  of, and when.

## Precedence

For anything already built, the code and the per-level `ARCHITECTURE.md` win. A
reference document that contradicts them is out of date and gets fixed in the same
change.
