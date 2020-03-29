#!/usr/bin/env bash

set -e
set -u

dashboards=("consul" "memcached" "jaeger")
for x in "${dashboards[@]}"; do
  jsonnet -J . -m ${x}-mixin/ ${x}-mixin/dashboard.jsonnet
done
