# Pull Request Template Guide

## Complete Following steps:
- [ ] PR title follows conventional naming rules
- [ ] PR template selected 

## 📌 Choose a PR template guide

Select the template based on the **primary goal** of your change.

---

## How to use:
Templates location: `.github/PULL_REQUEST_TEMPLATE/`
Use the selected template as the PR description.
⚠️ Do not use this guide file as a PR template.

## 🟢 02_default.md
**Small, low-risk changes:**
- typos, minor docs updates, small refactors (no behavior change)

---

## 🚀 03_feature.md
**New functionality:**
- new features or behavior
- new modules/services
- user-facing changes

---

## 🐛 04_bugfix.md
**Fixes incorrect behavior:**
- logic bugs
- broken features
- regressions

---

## 📦 05_dependency.md
**Build / dependency changes:**
- Dockerfile / docker-compose changes
- package manager changes (npm, pip, etc.)
- lockfile updates
- dependency structure changes

---

## 📚 06_documentation.md
**Docs only:**
- README updates
- guides
- internal docs

---

## ⚙️ 07_infra.md
**CI/CD and tooling:**
- GitHub Actions workflows
- CI/CD pipelines
- build scripts
- deployment scripts
- repo automation (Dependabot config, labels, bots)
- lint/test pipeline configuration
- Docker build pipelines (if part of infra, not dependency update)
- tooling upgrades affecting workflow behavior

---

## 📌 Rule

If multiple apply → choose the **main intent** of the PR (not files changed).