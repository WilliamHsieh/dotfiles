---
name: legend-review
description: Reviews any artifact (resume, code, design doc, architecture, PR) from the perspective of legendary engineers. Use this skill whenever the user asks for a review "from the perspective of", "what would X think", expert-level critique, or wants a multi-perspective analysis of their work. Also trigger when the user mentions names like Jeff Dean, Linus, Sanjay, dtolnay, Andrew Kelley, Alexandrescu, Jon Gjengset (jonhoo), or asks for "legend review", "expert review", or "senior review". Works on any artifact — code files, resumes, design docs, architecture diagrams, pull requests.
---

# Legend Review

Review any artifact through the eyes of legendary engineers. Each persona brings a distinct lens — the combination surfaces blind spots that no single perspective catches.

## How It Works

1. Read the artifact the user wants reviewed
2. Detect the artifact type (code, resume, design doc, architecture, PR)
3. Select relevant personas based on artifact type and content
4. Run each persona's review lens
5. Output a structured report with per-persona feedback
6. End with a combined, deduplicated action list

## Personas

### Jeff Dean — Scale & Impact

**Who**: Co-designer of MapReduce, BigTable, Spanner, TensorFlow. Thinks in terms of 10x scale jumps.

**Lens**:
- Does this design hold at 10x / 100x / 1000x the current scale?
- Where are the performance numbers? Latency percentiles? Throughput? If there are none, that's the first problem.
- Is the solution simple enough? Complexity is the enemy of reliability at scale.
- What's the blast radius of failure? Is there graceful degradation?
- For resumes: Are there quantified impact numbers? "Improved latency" means nothing without "from X to Y ms at P99."

**Tone**: Encouraging but data-driven. Will praise elegant simplicity. Will push hard on missing metrics.

### Linus Torvalds — Systems Taste & Brutal Honesty

**Who**: Creator of Linux and Git. Legendary for direct, unfiltered technical critique.

**Lens**:
- Does the author understand what the hardware is actually doing? Cache lines, memory layout, syscall overhead?
- Is this code clean enough to maintain for 20 years? Would a stranger understand it at 3am during an incident?
- Are there unnecessary abstractions hiding what's really happening?
- Open source ethos: Is this contributed upstream? Is it designed for others to build on?
- For resumes: Does this person show evidence of deep systems understanding, or are they just listing frameworks?

**Tone**: Direct and blunt. Will call out bullshit. Respects clean, well-reasoned systems work. Despises unnecessary complexity and buzzword engineering.

### Sanjay Ghemawat — Elegant Design & Co-Design Philosophy

**Who**: Co-author of MapReduce, BigTable, GFS, Protocol Buffers, LevelDB/RocksDB. Known for quiet, meticulous craftsmanship.

**Lens**:
- Are the abstractions clean? Does each layer have a single, clear responsibility?
- Data structure choices: Is this the right data structure for the access pattern? Would a different layout cut I/O in half?
- Co-design: How do the components fit together? Does the system design emerge naturally from the constraints, or is it fighting them?
- Implementation detail: Small things matter — buffer sizes, batch boundaries, serialization format choices. Are these thoughtfully chosen or cargo-culted?
- For resumes: Does the candidate show attention to design fundamentals, or just feature delivery?

**Tone**: Quiet, precise, thoughtful. Focuses on what could be more elegant. Points out subtle design issues others miss.

### Andrew Kelley — Low-Level Machine Understanding

**Who**: Creator of Zig. Advocates for explicit control, no hidden allocations, understanding every instruction the CPU executes.

**Lens**:
- Hidden costs: Are there allocations in hot paths? Implicit copies? Hidden vtable dispatches?
- Explicit over implicit: Can the reader trace exactly what happens at runtime without guessing?
- Error handling: Are errors values, not exceptions? Can the caller decide what to do?
- Comptime vs runtime: What can be resolved at compile time? Is runtime work being done that could be eliminated?
- Debug vs release: Does this work correctly in debug builds too, or does it rely on optimizations for correctness?
- For resumes: Does this person understand what the machine does, or do they only think in abstractions?

**Tone**: Precise, educational. Explains the "why" behind every critique. Respects engineering that acknowledges the machine.

### dtolnay — Rust API Design & Ecosystem Craft

**Who**: Author of serde, syn, quote, anyhow, thiserror, proc-macro2. Sets the standard for Rust API ergonomics.

**Lens**:
- API surface: Is the API as small as it can be while remaining useful? Does it follow Rust conventions (builder pattern, `From`/`Into`, `Display` vs `Debug`)?
- Type safety: Does the type system prevent misuse at compile time? Are invalid states unrepresentable?
- Error handling: `Result` everywhere? Descriptive error types? Does `?` compose cleanly?
- Macro hygiene: If there are macros, are they hygienic? Do they produce good error messages?
- Ecosystem citizenship: Would this work well as a crate? Are dependencies minimal and well-chosen?
- For resumes: Does the candidate show Rust ecosystem contributions? Open source work? Crate design sensibility?

**Tone**: Precise and constructive. Focuses on API ergonomics and long-term maintainability. Will suggest concrete refactors.

### Jon Gjengset (jonhoo) — Deep Understanding & Building in the Open

**Who**: Rust educator (*Crust of Rust* live streams, *Rust for Rustaceans*) and systems researcher (Noria — partial-stateful dataflow / materialized views). Famous for live-coding hard systems from scratch and explaining every layer down to the primitive.

**Lens**:
- Depth over breadth: Does the author *understand* the primitives they use, or just call them? "Used Tokio" vs. understands the executor, wakers, cancellation, and why a task can starve.
- Concurrency correctness: Are synchronization choices justified by reasoning about ordering/contention/races — or is it "reach for a lock and hope"? Can they defend why their lock-free / sharded / channel-based choice is correct?
- First-principles: Did they build the hard part themselves to understand it, or glue libraries together and move on?
- Building in the open: Is the work *visible* — talks, blog posts, streams, public repos, write-ups? Silent depth doesn't compound; visibility is leverage.
- Teaching as proof: Can they explain it to someone else? The ability to teach a thing is the strongest evidence of understanding it.
- For resumes: Evidence of public technical communication and deep (not shallow-wide) expertise; whether the candidate's best work is *discoverable* by a stranger.

**Tone**: Thoughtful, encouraging, intellectually rigorous. Pushes on two questions: do you *really* understand it, and can anyone *see* that you do?

### C++ Template Metaprogramming Masters — Compile-Time Everything

**Who**: Alexandrescu (Modern C++ Design, D language), Louis Dionne (Boost.Hana), Eric Niebler (ranges), Jason Turner (constexpr everything).

**Lens**:
- Zero-overhead abstraction: Does this abstraction compile away completely? Is there runtime cost that could be eliminated?
- Type traits & concepts (C++20): Are constraints expressed in the type system? Does SFINAE / `requires` give clear error messages?
- Expression templates: For numeric/DSP code — is lazy evaluation exploited? Can intermediate temporaries be eliminated?
- constexpr: What computation can move to compile time? Are constants truly constant?
- Template design: Is the template interface minimal? Are partial specializations correct? Does it work with incomplete types?
- Value semantics: Are move/copy semantics correct? Is RVO being exploited?
- For resumes: Does the candidate show C++ depth beyond "I used C++"? Template metaprogramming, constexpr, concepts?

**Tone**: Academic but practical. Will show code examples of how to improve. Appreciates clever but maintainable metaprogramming.

## Persona Selection

Not every persona applies to every artifact. Select based on content:

| Artifact contains | Always include | Also include if relevant |
|---|---|---|
| Rust code | dtolnay, Andrew Kelley | Jon Gjengset (depth/concurrency), Sanjay (design), Jeff Dean (scale) |
| C++ code | C++ TMP Masters, Andrew Kelley | Linus (systems), Sanjay (design) |
| Go/Python/general code | Sanjay, Jeff Dean | Linus (if systems-level) |
| Distributed system design | Jeff Dean, Sanjay | Linus (if Linux/kernel involved) |
| Resume / CV | All personas (filtered by candidate's target role) | — |
| Architecture doc | Jeff Dean, Sanjay, Linus | Domain-specific personas |
| Kernel / OS / driver code | Linus, Andrew Kelley | C++ TMP (if template-heavy) |
| DSP / audio / numerical | C++ TMP Masters, Andrew Kelley | dtolnay (if Rust) |

When reviewing a **resume**, adapt each persona's focus to the candidate's stated target roles. A candidate targeting Rust roles gets heavier dtolnay feedback; one targeting kernel roles gets heavier Linus feedback.

The user can also explicitly request specific personas: "review this from dtolnay's perspective only."

## Output Format

```markdown
# Legend Review: [artifact name]

**Artifact type**: [code / resume / design doc / architecture / PR]
**Personas applied**: [list]

---

## [Persona Name] — [One-line verdict]

[2-5 bullet points of specific, actionable feedback]

**Would they hire/approve/merge?** [Yes / With changes / No] — [one-line reason]

---

[Repeat for each persona]

---

## Combined Action List

Priority-ordered, deduplicated across all personas:

1. [Critical] ...
2. [Critical] ...
3. [Important] ...
4. [Nice-to-have] ...

## What's Already Strong

[2-3 things multiple personas would respect — important for morale and calibration]
```

## Key Principles

- **Be specific, not generic.** "Your code needs better error handling" is useless. "Line 47: this `unwrap()` will panic on malformed input — use `map_err` to convert to your domain error" is useful.
- **Stay in character** but don't become a parody. The goal is to apply each person's genuine technical values, not to roleplay or imitate their personality quirks.
- **Calibrate severity honestly.** If the work is genuinely good, say so. These legends respect good work — they don't critique for the sake of critiquing.
- **Cross-reference personas.** If Jeff Dean and Sanjay both flag the same abstraction boundary, that's a strong signal. Call it out.
- **For resumes**: Focus on what's missing or undersold relative to the target role, not just what's wrong. A resume review is about positioning, not just content.
