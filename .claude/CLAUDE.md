# Global user instructions (cross-machine, dotfiles-managed)

This is the user-level CLAUDE.md for Withers (Hsuan-Yu Lin), symlinked from `~/dotfiles/.claude/CLAUDE.md` and loaded into every session on every machine. Keep it lean — it loads everywhere. Machine-specific or project-specific guidance belongs in a project CLAUDE.md, not here.

## Authoring skills and agents

**When turning anything from a session into a reusable skill, you MUST go through `superpowers:writing-skills`. Do not hand-roll a SKILL.md.**

That skill encodes the required discipline:
- **Baseline test first (the Iron Law)**: no skill — and no *edit* to a skill — without first watching an agent fail without it. "It's obviously clear" / "just a small addition" do not exempt you.
- **Description = triggering conditions only, never a workflow summary.** A description that summarizes steps causes Claude to follow the summary and skip the skill body.
- **Discipline/gate skills get a rationalization table + red-flags list** so the rule survives under pressure.

**For agents (subagents / `~/.claude/agents/`), apply the same discipline.** There is no dedicated "writing-agents" skill, so use `superpowers:writing-skills` principles plus `skill-creator` where useful: define the failure you're solving before writing, keep the agent's trigger description to *when to invoke* (not what it does), and verify it behaves before relying on it.

**Why this rule exists**: Withers explicitly wants session learnings captured at the quality bar of well-known projects (e.g. superpowers), not as quick untested notes. A skill written without the RED phase is untested code — it will have gaps that only surface when another agent can't use it.
