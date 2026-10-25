# Issue tracker: Local markdown

Specs and tickets for this repo live as markdown files under `.scratch/`, which is gitignored.

## Layout

- One directory per feature: `.scratch/<feature-slug>/`.
- The spec is `.scratch/<feature-slug>/spec.md`. It is the parent of that feature's tickets.
- Tickets are one file each at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` in dependency order, never one combined file.
- A paused grill's questionnaire is `.scratch/questionnaire-<slug>.md`.

## Operations

- **Publish**: create the file, and its directory if needed.
- **Fetch a ticket**: read the file at the path the user passed.
- **State**: a `Status:` line near the top of each file, holding one of `needs-grilling` or `ready-for-agent`. `/implement` deletes a ticket's file when its work is done, so there is no done state.
- **Blocking**: a `Blocked by:` line listing ticket numbers. A ticket is unblocked once none of the files it lists still exist.
- **Frontier**: the ticket files in the feature's `issues/` directory with no remaining blocker; lowest number first.
- **Comments**: append to the bottom of the file under a `## Comments` heading.

## Wayfinding operations

Used by `/wayfinder`. The map is a file with one file per ticket beside it.

- **Map**: `.scratch/<effort-slug>/map.md`.
- **Ticket**: `.scratch/<effort-slug>/issues/<NN>-<slug>.md`, numbered from `01`, with a `Type:` line holding `research`, `prototype`, `grilling`, or `task`. Resolved tickets stay: the map links them.
- **Blocking**: a `Blocked by:` line listing ticket numbers. A ticket is unblocked when every ticket it lists is resolved.
- **Claim**: add `Status: claimed` and save, before any other work. Release by removing the line.
- **Waiting on an owner**: a `Waiting on: <owner>` line, removed when the answer is posted.
- **Frontier**: ticket files with no `Status:` line, no unresolved blocker, and no `Waiting on:` line; lowest number first.
- **Resolve**: append the answer under an `## Answer` heading, set `Status: resolved`, then add the gist and link to the map's Decisions so far.
- **Reopen**: remove the `Status:` line and note the conflict under `## Comments`.
