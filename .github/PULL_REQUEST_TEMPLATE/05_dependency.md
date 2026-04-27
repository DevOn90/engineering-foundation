# Dependency Pull Request

## Designated for:

**Build / dependency changes:**
- Dockerfile / docker-compose changes
- package manager changes (npm, pip, etc.)
- lockfile updates
- dependency structure changes

---

> ⚠️ Please ensure this PR is complete before requesting review:
> - Fill out all relevant sections
> - Ensure checkboxes reflect reality
> - Add required explanations where applicable

---

## 🧾 Summary

What dependency or build change is introduced?

---

## 📊 Change Scope

- [ ] Small (single dependency, no breaking changes)
- [ ] Medium (multiple updates or minor risk)
- [ ] Large (frameworks, major versions, build/runtime impact)

---

## 📦 Dependency Changes

List all dependency-related changes:

- Added:
- Updated:
- Removed:

---

## 🧠 Reason for Change

Why is this dependency change needed?

- Security:
- Feature requirement:
- Maintenance:
- Other:

---

## 🤖 Dependabot Coverage Check

### IMPORTANT

Confirm how this change affects `.github/dependabot.yml`:

- [ ] No changes required to dependabot.yml
- [ ] dependabot.yml updated
- [ ] New ecosystem or path added and verified

Explain reasoning:

---

## 🔍 Impact Analysis

- Affected services/modules:
- Build process impact:
- Runtime impact:

---

## 🧪 Testing

- [ ] Build succeeds locally
- [ ] Dependency installation tested
- [ ] Tests pass
- [ ] CI pipeline passes

---

## ⚠️ Risk Assessment

- [ ] Low
- [ ] Medium
- [ ] High

Describe risks (if any):

---

## 📏 Governance

- [ ] PR title follows convention
- [ ] Linked issue (e.g. `Closes #123`)
- [ ] Self-review completed

---

## ✅ Ready for Review

- [ ] Dependency impact is fully understood
- [ ] Dependabot configuration is correct
- [ ] This PR is safe to merge