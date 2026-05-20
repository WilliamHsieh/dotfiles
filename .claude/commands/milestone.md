---
name: milestone
description: Use when a project milestone is finished, before checking its box in PLAN.md.
---

# Milestone Complete

The milestone-completion ritual from the collaboration protocol. Enforces that a milestone isn't "done" until Withers can explain what he learned — then syncs all the trackers.

**The explainback is a GATE, not a step in a checklist.** The sync steps (PLAN.md, journal, tag) are bookkeeping; the explainback is the entire point. Violating the letter of the gate is violating the spirit of it — a checked box without real understanding is worse than no box, because it manufactures false confidence.

## Input

$ARGUMENTS

Arguments should identify the milestone (e.g. "vigil M1", "bloop publish-prep"). If absent, infer from the active project's PLAN.md (the first unchecked milestone that looks complete) and confirm with Withers.

## Steps

### 1. Feynman explainback (the gate)

Ask Withers to answer, in his own words (3-5 sentences):

1. **What was the actual mechanism / invariant / data flow I learned?**
2. **What was I wrong about before I started this milestone?**
3. **What edge case would break my current implementation?**

**This is a gate, not a formality.** Read the answer critically:
- If it's shallow or hand-wavy, push back: name the specific thing that's still fuzzy and ask Withers to go one layer deeper BEFORE marking the milestone done.
- If it's solid, affirm specifically what showed real understanding.

Do NOT proceed to the sync steps until the explainback passes.

### 2. Update PLAN.md

In `~/weithers/projects/<name>/PLAN.md`:
- Check the milestone's box in the milestone checklist (`- [ ]` → `- [x]`).
- Add a one-line entry under "Status updates" with today's date and what was completed.

### 3. Write a Heptabase journal entry

```
heptabase journal append $(date +%Y-%m-%d) --content "<markdown>"
```
Content should capture the learning from the explainback — the mechanism learned + the misconception corrected. This is the durable knowledge record. Keep it substantive (the explainback is the raw material). Skip silently if the Heptabase app isn't running, and note to Withers that the journal entry is pending.

### 4. Set tag status (if the project has a Heptabase tag + status property)

If a card for this milestone exists under the project's tag and the tag has a status property, set it to Done. Read `references/property-values.md` of the heptabase skill first if unsure of the format. Skip if no such card/property exists.

### 5. Point to the next milestone

State the next unchecked milestone and ask whether to set up for it now or stop here.

## Principles

- The explainback gate is the whole point. A checked box without understanding is worse than no box — it creates false confidence. Be willing to say "not done yet."
- Don't write the explainback FOR Withers. If he's stuck articulating it, that's a signal the learning is incomplete — ask probing questions instead of supplying the answer.
- Keep the sync steps fast and silent; the explainback is where the time goes.

## Red Flags — STOP, the gate is being bypassed

If you catch yourself (or Withers) reaching for any of these, the gate is failing. Stop and run the explainback for real.

- About to update PLAN.md / journal / tag before the explainback has actually happened.
- Accepting "yeah I basically get it" or a one-line answer as the explainback.
- Filling in the explainback yourself because Withers is vague or tired.
- "The milestone code obviously works, so the understanding must be there." (Working code ≠ understanding. The gate tests understanding, not output.)
- "It's late / he's done a lot today, close enough." (Exhaustion is exactly when shortcuts feel justified and learning is lost.)

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "The milestone is obviously done, explainback is a formality" | The gate exists precisely for milestones that *feel* done. Feeling done and understanding why it works are different. |
| "I'll write the explainback for him to save time" | Then it tests *your* understanding, not his. The whole point is Withers articulating it. Ask questions instead. |
| "His answer is roughly right, good enough" | "Roughly right" means a fuzzy layer remains. Name the fuzzy part and go one level deeper before checking the box. |
| "He's tired, accept it and move on" | Tired is when false confidence gets manufactured. A checked box now becomes a bug he can't explain in 3 months. |
| "Working code proves he understands" | Code can work for reasons the author doesn't grasp (lucky defaults, copied patterns). The edge-case question (#3) is what separates the two. |

**Violating the letter of the gate is violating the spirit of the gate.** Don't proceed to the sync steps until the explainback genuinely passes.
