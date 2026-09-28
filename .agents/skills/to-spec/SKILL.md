---
name: to-spec
description: Turn the current conversation into a spec and publish it to the project issue tracker — no interview, just synthesis of what you've already discussed.
disable-model-invocation: true
---

This skill takes the current conversation context and codebase understanding and produces a spec (you may know this document as a PRD). Do NOT interview the user — just synthesize what you already know.

The issue tracker should have been provided to you. If not, stop and tell the user to run `/setup-skills`; you cannot run it yourself.

## First, check a spec is worth it

A spec earns its cost when the work spans **multiple sessions or multiple people** — it's the shared artifact that lets others pick up the work. If it fits one session for one dev, skip this skill: go straight to `/to-tickets`, or `/implement` if it's a single slice. The conversation is the spec. Only continue below when the work is genuinely big or shared.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's domain glossary vocabulary throughout the spec, and respect the decisions already recorded in `ARCHITECTURE.md`.

   Reference those decisions; don't restate them. If `ARCHITECTURE.md` already says the identity provider sits behind a port, the spec says "via the provider port" — it does not re-explain the choice. A decision written in two places is a decision that will be updated in one.

2. Sketch out the seams at which you're going to test the feature. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better - the ideal number is one.

Check with the user that these seams match their expectations.

3. Write the spec using the template below, then publish it to the project issue tracker. Apply the `spec` and `ready-for-agent` labels. If the spec came from an issue labelled `needs-grilling`, remove that label from it.

Keep the spec lean: include a section only when it has real content — omit empty ones rather than writing "N/A". The spec fixes scope and decisions; it is not padding.

<spec-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

Cover the real capabilities the feature delivers — enough to fix scope, not padded. Drop stories that just restate each other.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature.

</spec-template>
