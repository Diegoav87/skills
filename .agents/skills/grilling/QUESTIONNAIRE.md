# Questionnaire

The body of the issue a paused grill files. The user lacks the answers; the owners hold them. Order questions most-important-first within each owner, since async means you may only get one pass. Every question is one idea, never compound.

Title the issue `<topic>: questions for <owner>` (`for <owner> and <owner>` when there are several).

<questionnaire-template>

**Purpose:** the decision riding on these answers, in one sentence.

**How your answers will be used:** they resume the design interview for <topic>; the spec follows.

## Context

One paragraph orienting a reader who was not in the interview. Enough to answer well, not a page.

## Settled so far

One line per decision the user made in the interview, in the order made. A decision already written to `ARCHITECTURE.md` gets a pointer to it, not a restatement.

## How to answer

Deadline and rough effort. Partial answers and "I don't know" are useful: flag anything you are unsure of rather than skipping it. Reply in this issue, or send the answers back and we will paste them in.

## For <owner>

One `##` section per owner. Under each, its questions.

<question-example>
### What load is the system expected to handle at launch?

_Why this matters: it decides whether we provision for burst traffic now or defer it._

Our default if you have no preference: provision for current traffic and revisit after launch.

>
</question-example>

## Anything else?

Anything we did not ask that we should know?

</questionnaire-template>
