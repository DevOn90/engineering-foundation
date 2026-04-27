#!/usr/bin/env bash

# List of package-ecosystem files in workspace
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

declare -A dirs

for file in "${list[@]}"; do
  dir="$(dirname "$file")/"
  dirs["$dir"]=1
done

for dir in "${!dirs[@]}"; do
  echo "Workspace:$dir"
done

mapfile -t dependabot_dirs < <(
  grep -E 'directory:' .github/dependabot.yml \
  | awk '{print $2}' \
  | tr -d '"' \
  | while read -r d; do
      if [[ "$d" == "/" ]]; then
        echo "./"
      else
        echo ".${d%/}/"
      fi
    done
)

for dep_dirs in "${dependabot_dirs[@]}"; do
  echo "Dependabot: $dep_dirs"
done