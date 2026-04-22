## First-Time Setup

After cloning the repository, run the setup script to configure your environment and Git hooks:

```bash
git clone <repo-url>
cd <repo-root>
bash ./scripts/setup.sh
```
What this script does:
- Makes all scripts and git hooks executable
- Configures .githooks path in Git
- Performs any future onboarding tasks (dependencies, migrations, etc.)

Note: On Windows, always run with bash ./scripts/setup.sh.

empty commit to main