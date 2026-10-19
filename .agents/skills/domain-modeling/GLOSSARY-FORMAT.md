# GLOSSARY.md Format

## Structure

```md
# {Project name}

{One or two sentences: what the project is and who it serves.}

## {Area}

**Order**:
{One or two sentences on what the term is.}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer** (`account`):
A person or organization that places orders.
_Avoid_: Client, buyer
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others under `_Avoid_`.
- **Keep definitions tight.** One or two sentences max. Define what it IS, not what it does.
- **Only include terms specific to this project.** General programming concepts (timeouts, error types, utility patterns) don't belong even if the project uses them extensively. Before adding a term, ask: is this a concept unique to this project, or a general programming concept? Only the former belongs.
- **Name the code identifier when it differs.** When the code calls the concept something else (another language, an older name), put the identifier in backticks after the term, so a reader can go from the word to the code.
- **Group terms under `##` headings by area** as clusters emerge. A flat list is fine while the glossary is small.
