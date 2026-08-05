# CONTEXT.md Format

## Structure

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others under `_Avoid_`.
- **Keep definitions tight.** One or two sentences max. Define what it IS, not what it does.
- **Only include terms specific to this project's context.** General programming concepts (timeouts, error types, utility patterns) don't belong even if the project uses them extensively. Before adding a term, ask: is this a concept unique to this context, or a general programming concept? Only the former belongs.
- **Group terms under subheadings** when natural clusters emerge. If all terms belong to a single cohesive area, a flat list is fine.

## Where the glossary lives

A `CONTEXT.md` can sit at any level, next to that level's `ARCHITECTURE.md`. The
rule that decides which level is simple:

**A term is defined at the highest level where it's true, and only there.**

The root glossary holds vocabulary the whole system shares — `User`, `Account`,
`Money`. A module's glossary holds only what that module *adds* — `auth/` defines
`Session`, `Claim`, `Refresh Token`, and says nothing about `User`, because the root
already did.

That's inheritance, not duplication. An agent reading down from the root to `auth/`
accumulates exactly the vocabulary it needs, and no term ever appears twice.

**Create a level's glossary only when that level introduces vocabulary of its own.**
Most modules don't. A module with no special terms simply has no `CONTEXT.md`, and
that's the normal case — not a gap to fill.

## Never copy a definition downward

A term repeated in a child glossary is a second copy that will drift, and then two
parts of the system quietly mean different things by the same word. If you're about
to restate a parent's term, don't — the reader already has it.

The one legitimate exception is genuine divergence: two siblings really do mean
different things by the same word. Then define it in each, and say in each
definition what it means *here*. That divergence is real information about the
boundary between them, and worth the words.

## Redefining a parent's term is a design smell

If a module needs to contradict the root's definition of `User`, either the root's
definition is too narrow, or the module is a different domain than its siblings.
Surface it rather than quietly overriding — it usually means the boundaries are in
the wrong place.
