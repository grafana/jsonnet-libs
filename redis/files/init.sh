#!/bin/bash

set -eu
set -o pipefail

# Stable StatefulSet identity. hostname -f gives the per-pod FQDN
# (e.g. redis-0.redis.<ns>.svc.cluster.local) which is stable across restarts,
# unlike the pod IP. We configure redis replication and Sentinel entirely in
# terms of these FQDNs so that a rolling restart (every pod gets a new IP) does
# not create stale "ghost" addresses in Sentinel.
HOSTNAME="$(hostname)"
FQDN="$(hostname -f)"
# Note: we really want a single percent sign here but we double it so that it is
# properly escaped for the jsonnet std.format function.
POD_BASE_NAME="${HOSTNAME%%-*}"
INDEX="${HOSTNAME##*-}"
# The domain shared by all pods in the StatefulSet: strip the leading pod name
# from the FQDN, leaving <service>.<namespace>.svc.cluster.local.
POD_DOMAIN="${FQDN#*.}"
# By convention StatefulSet index 0 is the master at cold start.
DEFAULT_MASTER_FQDN="${POD_BASE_NAME}-0.${POD_DOMAIN}"

SENTINEL_PORT="%(sentinel_port)d"
MASTER_GROUP="%(master_group)s"
QUORUM="%(quorum)d"
DOWN_AFTER_MS="%(down_after_milliseconds)d"
PARALLEL_SYNCS="%(parallel_syncs)d"
REDIS_CONF=/etc/redis/redis.conf
REDIS_PORT="%(redis_port)d"
SENTINEL_CONF=/etc/redis/sentinel.conf
SENTINEL_SERVICE="redis-sentinel"
# We don't have permissions to write to the default cache dir, which causes our
# requests to be throttled. Use a custom cache directory, which kubectl creates.
KUBECTL_VERSION=1.21.3
MASTER=""

# Copy base config files and make sure they are writable by redis.
copy_config() {
  echo "Copying default redis config to ${REDIS_CONF}"
  cp /config-init/redis.conf "${REDIS_CONF}"
  echo "Copying default sentinel config to ${SENTINEL_CONF}"
  cp /config-init/sentinel.conf "${SENTINEL_CONF}"
  sleep 1
  chown "${UID}" "${REDIS_CONF}"
  chmod 644 "${REDIS_CONF}"
  chown "${UID}" "${SENTINEL_CONF}"
  chmod 644 "${SENTINEL_CONF}"
}

# Determine the FQDN of the current master. Defaults to index 0 (cold start),
# but prefers Sentinel's view if Sentinel is reachable. With
# `sentinel announce-hostnames yes`, get-master-addr returns an FQDN.
identify_master() {
  MASTER="${DEFAULT_MASTER_FQDN}"
  if [[ "$(redis-cli -h "${SENTINEL_SERVICE}" -p "${SENTINEL_PORT}" ping 2>/dev/null || true)" == "PONG" ]]; then
    echo "Sentinel reachable; querying it for the current master"
    local found
    found="$(redis-cli -h "${SENTINEL_SERVICE}" -p "${SENTINEL_PORT}" \
      sentinel get-master-addr-by-name "${MASTER_GROUP}" 2>/dev/null | head -1 || true)"
    if [[ -n "${found}" ]]; then
      MASTER="${found}"
      echo "Sentinel reports master: ${MASTER}"
    else
      echo "Sentinel did not report a master; defaulting to ${MASTER}"
    fi
  else
    echo "Sentinel not reachable; defaulting to ${MASTER}"
  fi
}

# Configure redis-server. A pod is a replica of the discovered master UNLESS it
# *is* that master. We never force-promote a restarting pod: if it used to be a
# replica it rejoins as one, and if it used to be the master it stays the master
# only when discovery agrees. This avoids the "restarting replica self-promotes
# from stale data -> two live masters" split-brain.
configure_redis() {
  echo "Configuring redis-server (master=${MASTER}, me=${FQDN})"
  {
    echo "requirepass ${REDIS_PASSWORD}"
    echo "masterauth ${REDIS_PASSWORD}"
    # Announce ourselves by FQDN so the master tracks us by a stable name.
    echo "replica-announce-ip ${FQDN}"
  } >> "${REDIS_CONF}"

  if [[ "${FQDN}" != "${MASTER}" ]]; then
    echo "Configuring as replica of ${MASTER}:${REDIS_PORT}"
    echo "replicaof ${MASTER} ${REDIS_PORT}" >> "${REDIS_CONF}"
  else
    echo "This pod is the master; not setting replicaof"
  fi
}

# Configure Sentinel. The monitor line must precede the per-master options, so
# we append everything here in order rather than templating it into
# sentinel.conf (which only carries the global settings).
configure_sentinel() {
  echo "Configuring sentinel (monitoring ${MASTER_GROUP} -> ${MASTER}:${REDIS_PORT})"
  eval MY_SENTINEL_ID="\$SENTINEL_ID_${INDEX}"
  {
    echo "sentinel myid ${MY_SENTINEL_ID}"
    # Announce ourselves by FQDN so peer sentinels rediscover us after a restart.
    echo "sentinel announce-ip ${FQDN}"
    echo "sentinel monitor ${MASTER_GROUP} ${MASTER} ${REDIS_PORT} ${QUORUM}"
    echo "sentinel down-after-milliseconds ${MASTER_GROUP} ${DOWN_AFTER_MS}"
    echo "sentinel failover-timeout ${MASTER_GROUP} 30000"
    echo "sentinel parallel-syncs ${MASTER_GROUP} ${PARALLEL_SYNCS}"
    echo "sentinel auth-pass ${MASTER_GROUP} ${REDIS_PASSWORD}"
  } >> "${SENTINEL_CONF}"
}

# kubectl is installed into the shared /k8s volume for the label-reconciler
# sidecar (which patches this pod's redis-role label). init.sh itself no longer
# touches labels.
install_kubectl() {
  echo "Installing curl"
  apt update && apt install -y curl
  echo "Installing kubectl for the label-reconciler sidecar"
  curl -L https://storage.googleapis.com/kubernetes-release/release/v"$KUBECTL_VERSION"/bin/linux/amd64/kubectl -o /k8s/kubectl
  chmod +x /k8s/kubectl
}

echo "Starting initialization"
install_kubectl
copy_config
identify_master
configure_redis
configure_sentinel
echo "Done"
