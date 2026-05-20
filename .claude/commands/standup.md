---
name: standup
description: Use at the start of a work session to rebuild context on the active project before doing any work.
---

# Standup

Session-start orientation ritual for Withers. Rebuilds context so we start each session knowing exactly where we left off, without re-explaining.

## Input

$ARGUMENTS

If arguments name a project (e.g. "vigil", "bloop"), use that as the active project. Otherwise infer the active project: default to the one with the most recent PLAN.md status update, or ask if ambiguous.

## Steps

1. **Read the active project's PLAN.md** (`~/weithers/projects/<name>/PLAN.md`). Focus on: current milestone, the milestone checklist, the most recent entries in the "Status updates" section, and any open technical questions.

2. **Read recent Heptabase journal** — last 2-3 days:
   ```
   heptabase journal read $(date +%Y-%m-%d)
   heptabase journal read $(date -d "yesterday" +%Y-%m-%d)
   ```
   (Skip silently if the Heptabase desktop app isn't running.)

3. **Glance at strategic context** — `~/weithers/memory/career_roadmap.md`, but only surface it if today's work conflicts with or advances a roadmap milestone. Don't dump the whole roadmap.

4. **Summarize** in this tight format:

   ```
   ## Standup — <project> — <date>

   **Where we are**: <1-2 sentences: current milestone + last thing completed>
   **Blocked on**: <anything stuck, or "nothing">
   **Open questions in flight**: <list the unanswered technical questions, if any>

   **Today's proposed focus**: <ONE concrete, finishable-today thing>
   **Working mode**: <A / B / C — derive from project: new domain → A, familiar → B>
   ```

5. **Confirm the mode and focus** with Withers before starting work. If Mode A, remind: "you write the code, I do architecture + review."

## Principles

- Keep the summary under ~15 lines. This is orientation, not a status report.
- Propose ONE focus, not a list. If Withers wants something else, they'll say so.
- Don't start doing the work in this command — `/standup` only orients. Work begins after Withers confirms.
- Honor the collaboration protocol (`~/weithers/memory/collaboration_protocol.md`).
