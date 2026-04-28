#!/usr/bin/env bash

set -euo pipefail

# ----------------------------------------
# 1. Scan workspace for dependency files
# ----------------------------------------
mapfile -d '' list < <(find . \
  -type d \( \
    -name node_modules -o \
    -name .git -o \
    -name dist -o \
    -name build -o \
    -name target -o \
    -name .angular -o \
    -name .cache -o \
    -name .vite -o \
    -name .nx -o \
    -name .turbo \
  \) -prune -false \
  -o -type f \( \
    -name "package.json" -o \
    -name "pom.xml" -o \
    -name "Dockerfile*" -o \
    -name "docker-compose*" -o \
    -name "pre-commit*" \
  \) -print0)

# ----------------------------------------
# 2. Extract unique workspace entries
# ----------------------------------------

declare -A workspace_entry_map

trim_value() {
  local value="$1"
  value="${value//\"/}"
  value="$(printf '%s' "$value" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
  printf '%s' "$value"
}

for file in "${list[@]}"; do
  dir="$(dirname "$file")/"
  base="$(basename "$file")"

  # Exclude .githooks (handled via root pre-commit)
  [[ "$dir" == "./.githooks/" ]] && continue

  case "$base" in
    package.json)
      ecosystem="npm"
      ;;
    pom.xml)
      ecosystem="maven"
      ;;
    Dockerfile*)
      ecosystem="docker"
      ;;
    docker-compose*)
      ecosystem="docker-compose"
      ;;
    pre-commit*)
      ecosystem="pre-commit"
      ;;
    *)
      continue
      ;;
  esac

  workspace_entry_map["$ecosystem|$dir"]=1
done

if find ./.github/workflows -maxdepth 1 -type f \( -name '*.yml' -o -name '*.yaml' \) | grep -q .; then
  workspace_entry_map["github-actions|./"]=1
fi

if [[ -f ./.githooks/pre-commit ]] || find . -maxdepth 1 -type f -name '.pre-commit-config*' | grep -q .; then
  workspace_entry_map["pre-commit|./"]=1
fi

workspace_entries=()

for entry in "${!workspace_entry_map[@]}"; do
  workspace_entries+=("$entry")
done

# ----------------------------------------
# 3. Extract dependabot entries
# ----------------------------------------

dependabot_entries=()
current_ecosystem=""

while IFS= read -r line; do
  case "$line" in
    *package-ecosystem:*)
      current_ecosystem="$(trim_value "${line#*:}")"
      ;;
    *directory:*)
      directory="$(trim_value "${line#*:}")"

      if [[ "$directory" == "/" ]]; then
        directory="./"
      else
        directory=".${directory%/}/"
      fi

      dependabot_entries+=("$current_ecosystem|$directory")
      ;;
  esac
done < .github/dependabot.yml

declare -A dependabot_entry_map
clean_dependabot_entries=()

for entry in "${dependabot_entries[@]}"; do
  if [[ -z "${dependabot_entry_map[$entry]:-}" ]]; then
    dependabot_entry_map["$entry"]=1
    clean_dependabot_entries+=("$entry")
  fi
done

dependabot_entries=("${clean_dependabot_entries[@]}")

# ----------------------------------------
# 4. Compute coverage (PREFIX MATCHING WITHIN ECOSYSTEM)
# ----------------------------------------

missing=()

for ws_entry in "${workspace_entries[@]}"; do
  ws_ecosystem="${ws_entry%%|*}"
  ws_dir="${ws_entry#*|}"
  covered=false

  for dep_entry in "${dependabot_entries[@]}"; do
    dep_ecosystem="${dep_entry%%|*}"
    dep_dir="${dep_entry#*|}"

    if [[ "$ws_ecosystem" == "$dep_ecosystem" && "$ws_dir" == "$dep_dir"* ]]; then
      covered=true
      break
    fi
  done

  if [[ "$covered" == false ]]; then
    missing+=("$ws_entry")
  fi
done

orphan=()

for dep_entry in "${dependabot_entries[@]}"; do
  dep_ecosystem="${dep_entry%%|*}"
  dep_dir="${dep_entry#*|}"
  covered=false

  for ws_entry in "${workspace_entries[@]}"; do
    ws_ecosystem="${ws_entry%%|*}"
    ws_dir="${ws_entry#*|}"

    if [[ "$dep_ecosystem" == "$ws_ecosystem" && "$ws_dir" == "$dep_dir"* ]]; then
      covered=true
      break
    fi
  done

  if [[ "$covered" == false ]]; then
    orphan+=("$dep_entry")
  fi
done

# ----------------------------------------
# 5. Output report
# ----------------------------------------

echo ""
echo "🔍 Dependabot Drift Detection Report"
echo "-----------------------------------"

if [[ ${#missing[@]} -eq 0 && ${#orphan[@]} -eq 0 ]]; then
  echo "✅ No drift detected. Configuration is in sync."
  exit 0
fi

if [[ ${#missing[@]} -gt 0 ]]; then
  echo ""
  echo "❌ Missing Dependabot coverage for:"
  for m in "${missing[@]}"; do
    ecosystem="${m%%|*}"
    directory="${m#*|}"
    echo "  - [$ecosystem] $directory"
  done
fi

if [[ ${#orphan[@]} -gt 0 ]]; then
  echo ""
  echo "⚠️ Orphan entries in dependabot.yml (not used):"
  for o in "${orphan[@]}"; do
    ecosystem="${o%%|*}"
    directory="${o#*|}"
    echo "  - [$ecosystem] $directory"
  done
fi

echo ""
echo "👉 Action required: update .github/dependabot.yml"

# ----------------------------------------
# 6. Debug output (optional but useful)
# ----------------------------------------

echo ""
echo "[DEBUG] - Workspace entries:"
for entry in "${workspace_entries[@]}"; do
  ecosystem="${entry%%|*}"
  directory="${entry#*|}"
  echo "[$ecosystem] $directory"
done

echo ""
echo "[DEBUG] - Dependabot entries:"
for entry in "${dependabot_entries[@]}"; do
  ecosystem="${entry%%|*}"
  directory="${entry#*|}"
  echo "[$ecosystem] $directory"
done

exit 1
Appendix E: Dependabot drift check CI template
Copy-paste the following workflow into .github/workflows/dependabot-drift-check.yml file.

name: Dependabot Drift Check

permissions:
  contents: read
  issues: write

on:
    schedule:
        - cron: '0 20 * * 0' 
    workflow_dispatch:

jobs:
    dependabot-drift-check:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@34e114876b0b11c390a56381ad16ebd13914f8d5 # v4

            - name: Check for Dependabot Drift
              id: drift
              continue-on-error: true
              run: |
                set +e
                
                # Run the drift check script and capture its output
                OUTPUT=$(bash .github/scripts/dependabot-drift-check.sh 2>&1)
                EXIT_CODE=$?
                set -e 
                {
                  echo "output<<EOF"
                  echo "$OUTPUT"
                  echo "EOF"
                } >> $GITHUB_OUTPUT
                exit $EXIT_CODE

            - name: Open or Update Issue on Failure
              if: steps.drift.outcome == 'failure'
              env:
                GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
                DRIFT_OUTPUT: ${{ steps.drift.outputs.output }}
              run: |

                # Create a label for dependabot drift if it doesn't exist
                gh label create "dependabot-drift" \
                --description "Dependabot configuration drift detected" \
                --color "e4e669" \
                --force
                
                # Check if an open issue with the label already exists 
                # and either comment on it or create a new one with the drift output as the body 
                EXISTING=$(gh issue list \
                  --label "dependabot-drift" \
                  --state open \
                  --json number \
                  --jq '.[0].number')
  
                if [ -n "$EXISTING" ]; then
                   gh issue edit "$EXISTING" --body "$DRIFT_OUTPUT"
                else
                   gh issue create \
                     --title "bug: Dependabot Drift Detected" \
                     --body "$DRIFT_OUTPUT" \
                     --label "dependabot-drift"
                fi

            - name: Close Issue on Success
              if: steps.drift.outcome == 'success'
              env:
                GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
              run: |
                EXISTING=$(gh issue list \
                  --label "dependabot-drift" \
                  --state open \
                  --json number \
                  --jq '.[0].number')

                if [ -n "$EXISTING" ]; then
                  gh issue close "$EXISTING" \
                    --comment "✅ Drift resolved. Closing automatically."
                fi