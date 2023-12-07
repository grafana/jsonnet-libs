#!/bin/bash

set -e

# This script merges the content of .lint.base.yaml file into all mixin dirs (as a .lint) file.

# Search for directories containing mixin.libsonnet files
directories=$(find . -type f -name 'mixin.libsonnet' -exec dirname {} \;)

# Iterate through the found directories
for dir in $directories; do
  lint_file="$dir/.lint"
  lint_base_file=".lint.base.yaml"

  # Check if a .lint file exists in the directory
  if [ -f "$lint_file" ]; then
    # Merge .lint and .lint.base.yaml using yq
    yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$lint_base_file" "$lint_file" > "$lint_file.tmp"
    
    # Replace the original .lint file with the merged content
    mv "$lint_file.tmp" "$lint_file"
    echo "Merged $lint_file with $lint_base_file"
  else
    # If .lint file doesn't exist, create it with the content of .lint.base.yaml
    cp "$lint_base_file" "$lint_file"
    echo "Created $lint_file from $lint_base_file"
  fi
done
