#!/bin/bash

# Self-labeling reconciler. Runs as a sidecar in every redis pod and is the
# single source of truth for the `redis-role` pod label that the `redis-master`
# and `redis-slave` Services select on.
#
# Every pod continuously labels *itself* based on the ground-truth role reported
# by its own local redis-server (`redis-cli role`). This replaces the previous
# mechanism (label set once at init + mutated cross-pod by the sentinel
# `client-reconfig-script`), which could strand the Service with zero endpoints
# if a reconfig event resolved to a stale/ghost IP (it demoted the old master
# before failing to promote the new one). Because each pod only ever writes its
# own label from its own actual role, the Service endpoint always converges on
# the true master within RECONCILE_INTERVAL, regardless of Sentinel state.

set -eu

REDIS_PORT="%(redis_port)d"
RECONCILE_INTERVAL="${RECONCILE_INTERVAL:-5}"
# kubectl is installed into a shared volume by the init container.
KUBECTL="/k8s/kubectl --cache-dir=/tmp/.kube/cache"

while true; do
  # `role` returns "master" or "slave" as its first line. Authenticated because
  # the server sets `requirepass`. Tolerate transient errors (server starting,
  # failover in progress) by simply retrying on the next tick.
  role="$(redis-cli -a "${REDIS_PASSWORD}" -p "${REDIS_PORT}" role 2>/dev/null | head -1 || true)"

  if [ "${role}" = "master" ] || [ "${role}" = "slave" ]; then
    current="$($KUBECTL get pod "${POD_NAME}" -o jsonpath='{.metadata.labels.redis-role}' 2>/dev/null || true)"
    if [ "${current}" != "${role}" ]; then
      echo "$(date -Iseconds) redis-role for ${POD_NAME}: '${current}' -> '${role}'"
      $KUBECTL label --overwrite pod "${POD_NAME}" redis-role="${role}" || true
    fi
  fi

  sleep "${RECONCILE_INTERVAL}"
done
