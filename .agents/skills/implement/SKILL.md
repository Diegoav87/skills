---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask. If the ticket contradicts the code or a convention in `CLAUDE.md`, stop and say so before building.

If you are on `main`, ask for a branch before touching code.

On a real tracker, mark the ticket as yours before touching code: remove `ready-for-agent`, add `in-progress`. Skip this for local files.

Call the Skill tool with "tdd" where possible, at seams agreed once up front.

Run typechecking regularly and the affected tests as you go; run the full test suite once at the end.

## Review, scaled to the change

- **Small, localized change** (a single slice, one or a few files): review it inline yourself, against the spec or ticket, for bugs, and for obvious smells. No subagents.
- **Substantial change** (a whole ticket or spec, several modules): commit the work first, so the review can see it. Then call the Skill tool with "code-review", passing the commit you started from as the fixed point and the ticket or spec as the spec source.

Fix every finding that holds up, then rerun the affected tests.

## Leave the documentation true

**The glossary.** Only when this change introduced a domain concept or changed what a term means, update `GLOSSARY.md` as the `domain-modeling` skill describes. Most changes leave it untouched.

**Comments.** A comment explains the non-obvious code beside it. When code carries a reason it can't show, such as a constraint or a decision a future reader would otherwise undo, write that reason in a comment next to it. Comments name no specs, tickets, or issue numbers. Write each one in plain words, as the `unslop` skill prescribes.

## Retire the ticket

- **Local files** under `.scratch/`: delete the ticket file.
- **A real tracker**: swap `in-progress` for `needs-review`, and leave the issue open for the user to close.

## Move the parent

When the ticket has a parent (an epic, a spec, a tracking issue) that carries state (a checklist, a scope list, a status field, a progress table), update it in this session to match what you delivered. Name the ticket on the line you move, and follow the shape the parent already uses. A parent that's pure prose has nothing to move. The tracker file (`docs/agents/issue-tracker.md`) says how parents are found here.

The parent moves when the work is done, not when the ticket closes. If review sends the work back, the follow-up that fixes the code fixes the parent too.

## Commit, but only commit

When the work is done, commit it to the current branch with a message that says what changed and why. Never push, never merge, never rewrite history (no rebase, no amend, no force push).

## End with a reading guide

Close with a summary written as the `unslop` skill prescribes, in this shape:

1. **What changed and why**, in a few sentences: what the feature or fix does from the user's side, and the one or two decisions that shaped it.
2. **Read in this order.** The new or modified files, in the order that makes the implementation easiest to follow: usually the entry point first, then what it calls, then tests. One line per file: its path and what it now does.
3. **Evidence.** What you ran and what it showed: typecheck, the affected tests, the full suite. Name anything you did not run, and why.
4. **Review.** Each finding you left unfixed, and why.
5. **Tracker.** The ticket you retired, and exactly what you changed in its parent. The user can't see either in the diff.
6. **Where it is.** The branch and the commits.
