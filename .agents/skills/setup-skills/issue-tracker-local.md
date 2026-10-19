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
