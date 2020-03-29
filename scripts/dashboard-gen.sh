#!/usr/bin/env sh

set -e
set -u

dashboards=("consul" "memcached" "jaeger")
for x in "${dashboards[@]}"; do
  jsonnet -J . -m ${x}-mixin/ ${x}-mixin/dashboard.jsonnet
done
