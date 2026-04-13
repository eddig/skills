---
name: research
description: Conduct structured research on a technical topic through iterative discussion, web validation, and produce an implementation-focused research document. Use when user wants to research approaches, compare solutions, investigate technologies, or explore implementation options.
---

This skill guides a structured research process. If information needed for a step is already available in the conversation context, skip that step and move on.

1. Ask the user to describe the research topic: what they want to build or solve, who it's for, and any constraints or preferences they already have. If this was already provided, move on.

2. Identify 2-4 distinct approaches or solutions worth investigating. Present them briefly and ask the user which directions interest them most. Ask clarifying questions one at a time to narrow scope — focus on:
   - Scale and performance requirements
   - Existing tech stack and integration points
   - Build vs buy preferences
   - Must-haves vs nice-to-haves

3. If the project has a codebase, explore it to understand relevant existing patterns, dependencies, and constraints that would affect implementation.

4. Search the web to validate the shortlisted approaches. Look for:
   - Official docs and real-world usage of candidate technologies
   - Known trade-offs, gotchas, and failure modes
   - Community adoption and maintenance status
   - Benchmarks or performance data when relevant

   Share key findings with the user as you go. Flag anything that contradicts earlier assumptions.

5. For each viable approach, discuss with the user:
   - How it fits their specific context
   - What the implementation would look like at a high level
   - What risks or unknowns remain

   Converge on a recommended approach (or a clear top-2 with criteria for choosing between them).

6. Ask the user whether they want the research document saved as `plans/research-<topic>.md` or under a custom path. Then write the document using the template below.

<research-document-template>

# Research: <Topic>

## Context

What we're building, who it's for, and the key constraints.

## Approaches Considered

For each approach:

### <Approach Name>

- **How it works**: Brief explanation
- **Pros**: What makes it attractive
- **Cons**: Drawbacks and risks
- **Evidence**: Links or references from web research that support the analysis

## Recommendation

The chosen approach and why it wins given our constraints.

If the decision is conditional, state the criteria clearly:
- Choose A if ...
- Choose B if ...

## Implementation Outline

How we intend to use the chosen approach:

- Key components or services involved
- Integration points with existing system
- Data flow or architecture sketch (in text)
- Dependencies to add
- Rough implementation sequence

## Open Questions

Anything unresolved that needs further investigation or will be decided during implementation.

## References

Numbered list of links and sources consulted.

</research-document-template>
