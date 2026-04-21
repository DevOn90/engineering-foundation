# Platform Guidelines: Change Policy

This is a placeholder with one example. The example format is not leading.

## Suggested Policy Levels

1. **L0 Quick fix**
   - Tracking: optional GitHub Issue.
   - Docs: none.
   - ADR: no.
2. **L1 Normal change**
   - Tracking: GitHub Issue required.
   - Docs: update affected docs only if behavior/devx/tests/tooling changed.
   - ADR: no.
3. **L2 Significant change**
   - Tracking: GitHub Issue + checklist.
   - Docs: short Problem Statement or design note.
   - ADR: maybe.
4. **L3 Architectural/platform change**
   - Tracking: GitHub Issue + explicit review.
   - Docs: design note required.
   - ADR: required


## ADR REQUIRED if change affects:
- architecture
- infrastructure
- CI/CD pipelines
- API contracts
- secrets management
- data models
- major dependencies (e.g. Spring Boot version, Angular version)
- runtime topology (e.g. adding new service, changing service boundaries)
- operational workflows (e.g. local development, deployment, monitoring)    

## DOC UPDATE REQUIRED if change affects:

- **developer experience**<br>
(e.g. new scripts, changed commands, new environment variables)
- **runtime behavior**<br>
(e.g. new configuration options, changed logging, new environment variables)
- **testing**<br>
(e.g. new tests, changed test behavior, new test dependencies)
- **tooling**<br>
(e.g. new VS Code settings, new GitHub Actions workflows, new Copilot instruction files)       

