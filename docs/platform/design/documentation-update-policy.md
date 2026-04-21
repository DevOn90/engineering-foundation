# Platform Design: Documentation Update Policy

## Introduction

This `Problem Statement document` serves as guide for developers and architects to discover the system design problem, describe the current state, and propose a solution for future state. The document is intentionally high-level and focuses on design intent rather than implementation details.

---

## ToC
1. [Problem Statement](#problem-statement)
2. [Current State](#current-state)
3. [Design Goal](#design-goal)
4. [Proposed Solution](#proposed-solution)
5. [Scope](#scope)
6. [Future State](#future-state)
7. [Boundaries](#boundaries)
8. [Related Files](#related-files)  
9. [Next Steps](#next-steps)



<h2 id="problem-statement">1. Problem Statement</h2>

When the codebase changes, related documentation often becomes outdated.

Documentation in this repository includes:

- Code comments
- Product Architectural documentation (`docs/product/architecture`)
- Product Features documentation (`docs/product/features`)
- Platform Architecture documentation (`docs/platform/architecture`)
- Platform modules documentation (`docs/platform/modules`)
- Platform libraries documentation (`docs/platform/libraries`)
- Engineering guidelines (`docs/guidelines`)
- Operational documentation (`docs/platform/operations`)
- Tooling documentation (`docs/platform/tooling`)
- Product feature documentation (`docs/product/features`)
- Markdown documentation located within code modules

If documentation is not updated together with the code, it gradually loses accuracy and reliability.

---

<h2 id="current-state">2. Current State</h2>

Currently documentation updates rely entirely on developer discipline.

Problems with the current approach:

- Documentation updates are often forgotten during implementation
- There is no automated validation in CI
- Guidelines describing when documentation must be are missing

As a result, documentation may diverge from the actual system behavior.

---

<h2 id="design-goal">3. Design Goal</h2>

The goal is **not strict enforcement of documentation updates**.

Instead, the goal is:

> Make forgetting documentation harder than writing it.

This is achieved by combining lightweight process rules with automated repository checks.

---

<h2 id="proposed-solution">4. Proposed Solution</h2>

A **layered enforcement approach** is introduced.

### Layer 1 – PR Checklist (Developer Responsibility)

Pull requests include a checklist where developers explicitly confirm whether documentation changes are required.

This encourages conscious evaluation of documentation impact during development.

### Layer 2 – CI Heuristic Validation

CI pipelines perform lightweight checks that detect potentially undocumented changes.

Examples:

- API contract changes without documentation updates
- infrastructure changes without operational documentation updates
- script changes without module documentation updates

These checks initially run in **warning mode**.

### Layer 3 – ADR Documentation

Architectural changes must be documented using **Architecture Decision Records (ADR)**.

ADRs capture:

- context
- decision
- consequences

Location: `docs/decisions/ADR-<NUM>-<Short-Description>.md`


### Layer 4 – CODEOWNERS Review

Critical documentation areas require approval from designated reviewers.

Examples:

- platform architecture
- infrastructure
- operational documentation

This ensures documentation quality and architectural alignment.

---

<h2 id="scope">5. Scope</h2>

This design affects the following repository areas:
- `docs`
- `.github`
- `scripts/ci`
- `.githooks`

The implementation includes:

- PR templates
- CI validation scripts
- documentation guidelines
- CODEOWNERS rules

---

<h2 id="future-state">6. Future State</h2>

After implementation:

- Developers are prompted to consider documentation updates during PR creation
- CI provides early warnings about missing documentation
- Architecture decisions are consistently captured
- Documentation remains aligned with the evolving codebase
- Guidelines for documentation updates are clear and accessible

--- 

<h2 id="boundaries">7. Boundaries</h2>

This system intentionally avoids:

- strict blocking rules for all documentation changes
- complex static analysis attempting to infer documentation requirements
- heavy developer workflow overhead

The system prioritizes **developer awareness and lightweight automation**.

---

<h2 id="related-files">8. Related Files</h2>

- .github/pull_request_template.md
- .github/CODEOWNERS
- scripts/ci/docs-check.sh
- docs/guidelines/documentation-update-policy.md
- docs/decisions/ 

---

<h2 id="next-steps">9. Next Steps</h2>

- 9.1 Validate the design 
- 9.2 Record the architectural decision (ADR)
- 9.3 Define implementation tasks
- 9.4 Implement governance artifacts
- 9.5 Introduce CI checks in warn mode
- 9.6 Observe and tune