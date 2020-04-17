#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DIR=$(dirname $0)

cd $DIR
jb install
jsonnet -J vendor test.jsonnet
cd - > /dev/null
