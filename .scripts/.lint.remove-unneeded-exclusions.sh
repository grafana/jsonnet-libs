#!/bin/bash

set -e

# This script iterates over all .lint files and remove all no-op exclusions (that don't affect the linting result)

# Find all directories containing .lint files
lint_dirs=$(find . -type f -name '.lint' -exec dirname {} \;)

for dir in $lint_dirs; do
  lint_file="$dir/.lint"
  lint_backup="$dir/.lint.bak"

  # Get the keys of the "exclusions" map using yq
  exclusions_keys=$(yq eval '.exclusions | keys | .[]' "$lint_file")

  for key in $exclusions_keys; do
    # Create a backup of the .lint file
    cp "$lint_file" "$lint_backup"

    # Remove the current key from the "exclusions" map using yq
    yq eval "del(.exclusions.$key)" "$lint_file" -i

    # Check if the mixtool lint command still works
    if mixtool lint -J "$dir/vendor" "$dir/mixin.libsonnet" &> /dev/null; then
      echo "Key '$key' removed successfully from $lint_file"
    else
      # Revert the .lint file to its original state
      cp "$lint_backup" "$lint_file"
      echo "Reverted $lint_file to its original state due to removal of key '$key'"
    fi

    # Remove the backup file
    rm "$lint_backup"
  done
done
