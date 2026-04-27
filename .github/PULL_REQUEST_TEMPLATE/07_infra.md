# Infra` Pull Request

## Designated for:

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

> ⚠️ Please ensure this PR is complete before requesting review:
> - Fill out all relevant sections
> - Ensure checkboxes reflect reality
> - Add required explanations where applicable

---

## 🧾 Summary

What infrastructure or tooling is being changed?

---

## 🔧 What is changing

- CI workflow changes
- pipeline steps added/removed
- automation behavior changes
- build/release modifications

---

## 🚨 Risk Assessment

- [ ] Low risk (workflow formatting, minor config)
- [ ] Medium risk (pipeline step changes, dependency in CI)
- [ ] High risk (release/deploy changes, CI logic changes)

Explain risk:

---

## 🧪 Testing

- [ ] CI tested in PR
- [ ] Workflow runs successfully
- [ ] No broken pipeline steps
- [ ] Manual verification performed (if needed)

---

## 📏 Governance
- [ ] PR title follows convention
- [ ] Linked issue (e.g. `Closes #123`)
- [ ] Self-review completed