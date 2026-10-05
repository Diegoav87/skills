# The page

One HTML file, no build step, diagrams in Mermaid rendered by the browser. Mermaid is the only external script.

## Head

Load Mermaid as an ES module and set the look once for every diagram on the page:

```html
<script type="module">
  import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@12/dist/mermaid.esm.min.mjs";
  const dark = matchMedia("(prefers-color-scheme: dark)").matches;
  mermaid.initialize({
    startOnLoad: true,
    look: "handDrawn",
    layout: "elk",
    theme: dark ? "dark" : "neutral",
    themeVariables: { edgeLabelBackground: dark ? "#141a28" : "#f8fafc" }, // the card color
    fontFamily: "inherit",
    state: { useMaxWidth: false },
    flowchart: { useMaxWidth: false },
    sequence: { mirrorActors: false, wrap: true },
  });
</script>
```

Mermaid 12 bundles ELK; pin `@12`, since `@11` needs ELK registered from a separate package and fails with "Unknown layout algorithm" otherwise. `look` and `layout` apply to flowcharts and state diagrams. Sequence diagrams keep the classic look; the theme still applies. `look: "neo"` with `theme: "redux"` (or `"redux-dark"`) is the flat alternative when the user prefers it over the sketch.

## Diagrams

Each diagram sits in `<pre class="mermaid">` inside a card, with `font: inherit` on the `pre` so `fontFamily: "inherit"` picks up the page font and not the monospace default. Rules that keep them readable:

- `autonumber` on every sequence diagram, so the number on each message is the `#` of its evidence row.
- `alt`, `opt`, `break` and `par` for the branches a request can take; a provider failure is a `break` or an `alt` branch, never a second diagram.
- A composite state (`state Paid { ... }`) for sub-statuses that only matter inside one status.
- One question per diagram. A state diagram with more than ~15 states, or a sequence with more than ~20 messages, splits in two along a natural boundary (before and after payment, happy path and failures).
- Edge labels carry the guard condition in business words, not the function name. The function goes in the evidence table.
- Group states and participants that belong to one actor or system: `state "Monato" as m { ... }`, `box Monato ... end`.
- `useMaxWidth: false` keeps every diagram at its natural size; a wide one scrolls inside its card instead of shrinking until the labels are unreadable. Direction `TB` for a state diagram whose main path is longer than about six states, `LR` for shorter ones.
- Mark failure states so they read at a glance with a stroke, never a fill, so both themes stay legible: `classDef bad stroke:#e5484d,stroke-width:2px` then `class Cancelled,Failed bad`.

## Evidence tables

Under each diagram, one table, one row per arrow in diagram order: `#`, what happens, `file:line`. Render `file:line` in `<code>`. The row count equals the arrow count; that is the check in step 5.

## Styling

Design tokens on `:root`, redefined under `@media (prefers-color-scheme: dark)`, explicit `body` background, 16px side gutters, no horizontal page scroll. A table of contents at the top when the page has more than four sections. Code and paths in monospace; everything else in the system font.
