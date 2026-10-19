---
name: pr
description: "Push the current branch and open a pull request against main, with a body that shows the change, the evidence it works, and the risk of merging."
disable-model-invocation: true
metadata:
  credits:
    skill: show-me
    author: Dex Horthy
    organisation: Humanlayer
    url: "https://github.com/humanlayer/skills/blob/main/plugins/show-me/skills/show-me/SKILL.md"
---

# PR

Open a pull request for the current branch. The user running this skill is their permission to push. Merging stays with the user.

The base is `main` unless the user names another branch.

## 1. Check the branch is ready

Stop and say why if any of these fails:

- You are on a branch other than the base.
- The working tree has no uncommitted changes.
- The branch has commits ahead of the base: `git log <base>..HEAD --oneline`.
- The typecheck and the full test suite pass. Run them now; their output is the evidence in step 3.

If `gh` can't open a pull request here (no GitHub remote, not logged in), write the title and body to a file in the OS temp directory, report its path, and stop before pushing.

If the branch already has an open pull request (`gh pr view`), update its title and body instead of opening a second one.

## 2. Gather

- The diff, `git diff <base>...HEAD`, and the commit list.
- The tickets: every issue the commits or the conversation reference.
- What the session already produced: `/implement`'s reading guide, a `/code-review` report and its blast-radius block. Build on them rather than redoing the work.

## 3. Write the title and body

The title is a short plain sentence in the imperative that names the change: "Add expiry dates to carrier documents". No prefix.

The body:

```markdown
## Summary

<one or two sentences: what changes for the user, and why>

<the smallest visual that makes the change clear>

## Evidence

- **Before:** <screenshot / output / failing test run>
  **After:** <screenshot / output / passing test run>

## Merge danger

**Door:** <one-way or two-way>. <one sentence on why, when it isn't obvious>

**Blast radius:** <what the change can affect outside the diff>

Closes #<n>
```

- **Summary.** Pick the visual from [VISUALS.md](VISUALS.md): one, sometimes two.
- **Evidence.** Only from runs: the test output from step 1, a screenshot when the change is visible and the environment can take one, a test that failed before the change and passes after it. A new feature with no before shows only the after, and says so. Name anything you did not run.
- **Door.** Two-way when reverting the merge undoes the change. One-way when it migrates or deletes data, changes an API or a format that something outside the repo consumes, or sends something out (emails, payments, notifications).
- **Blast radius.** From the `/code-review` blast-radius block when it ran. Otherwise, name what calls the changed code beyond the diff, and how sure you are.
- **Tickets.** `Closes #<n>` for each ticket the branch completes, `Part of #<n>` for a spec it only advances. Leave the line out on a local tracker.

Use the terms in `GLOSSARY.md`. Write in the language of the repo's commits and docs, as the `unslop` skill prescribes, and skip preambles.

## 4. Push and open

1. `git push -u origin HEAD`. If the push is rejected, stop and report it; never force-push.
2. Write the body to a file in the OS temp directory, then `gh pr create --base <base> --title "<title>" --body-file <file>`. Open it ready for review, not as a draft.
3. Report the URL.
