#!/bin/bash

set -eu
set -o pipefail


HOSTNAME="$(hostname)"
# Note: we really want a single percent sign here but we double it so
# that is properly escaped for the jsonnet std.format function
POD_BASE_NAME="${HOSTNAME%%-*}"
INDEX="${HOSTNAME##*-}"
SENTINEL_PORT="%(sentinel_port)d"
MASTER=""
POD_IP=""
MASTER_GROUP="%(master_group)s"
QUORUM="%(quorum)d"
REDIS_CONF=/etc/redis/redis.conf
REDIS_PORT="%(redis_port)d"
SENTINEL_CONF=/etc/redis/sentinel.conf
SENTINEL_SERVICE="redis-sentinel"
# We don't have permissions to write to the default cache dir,
# which causes our requests to be throttled. Use a custom
# cache directory, which kubectl will create.
KUBECTL="/k8s/kubectl --cache-dir=/tmp/.kube/cache"
KUBECTL_VERSION=1.21.3

# Query the existing sentinels for an existing master IP address
sentinel_get_master() {
  redis-cli -h "${SENTINEL_SERVICE}" -p "${SENTINEL_PORT}" sentinel get-master-addr-by-name "${MASTER_GROUP}" | \
    grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' || true
}

sentinel_get_master_retry() {
  local master=""
  local retry=${1}
  local interval=3

  for i in $(seq 1 "${retry}"); do
    master=$(sentinel_get_master)
    if [[ -n "${master}" ]]; then
      break
    fi
    sleep $((interval + i))
  done

  echo "${master}"
}

identify_master() {
  echo "Attempting to query sentinels for current master"
  MASTER="$(sentinel_get_master_retry 3)"
  if [[ -n "${MASTER}" ]]; then
    echo "Found redis master (${MASTER})"
  else
    echo "Did not find redis master"
  fi
}

# Ping the identified redis master to see if it is online
ping_master() {
  local response=""

  if ! response=$(redis-cli -h "${MASTER}" -a "${REDIS_PASSWORD}" -p "${REDIS_PORT}" ping); then
    return 1
  fi

  if [[ "$response" != "PONG" ]]; then
    echo "$response"
    return 1
  fi
}

ping_master_retry() {
  local retry=${1}
  local interval=3

  for i in $(seq 1 "${retry}"); do
    if ping_master; then
      return 0
    fi
    sleep $((interval + i))
  done

  return 1
}

# Update the redis and sentinel config to point to the current redis master
# (if applicable). Add redis-role label for proper kubernetes service routing.
update_config() {
  local master_ip=$1

  echo "Updating sentinel config"
  eval MY_SENTINEL_ID="\$SENTINEL_ID_${INDEX}"
  echo "Got sentinel id (${MY_SENTINEL_ID})"
  sed -i "1s/^/sentinel myid ${MY_SENTINEL_ID}\\n/" "${SENTINEL_CONF}"

  echo "Configuring sentinel's redis master (${master_ip}:${REDIS_PORT})"
  sed -i "2s/^/sentinel monitor ${MASTER_GROUP} ${master_ip} ${REDIS_PORT} ${QUORUM} \\n/" "${SENTINEL_CONF}"

  # Update the redis password in the sentinel configuration.
  echo "sentinel auth-pass ${MASTER_GROUP} ${REDIS_PASSWORD}" >> ${SENTINEL_CONF}

  echo "Updating redis config"

  # Update the redis password in the redis configuration.
  echo "requirepass ${REDIS_PASSWORD}" >> ${REDIS_CONF}
  echo "masterauth ${REDIS_PASSWORD}" >> ${REDIS_CONF}

  if [[ "$master_ip" != "$POD_IP" ]]; then
    echo "Configuring as slave of redis master (${master_ip}:${REDIS_PORT})"
    echo "slaveof ${master_ip} ${REDIS_PORT}" >> "${REDIS_CONF}"
  fi

  if [[ "$master_ip" == "$POD_IP" ]]; then
    echo "Adding redis-role=master label to ${HOSTNAME}"
    $KUBECTL label --overwrite pod "$HOSTNAME" redis-role="master"
  else
    echo "Adding redis-role=slave label to ${HOSTNAME}"
    $KUBECTL label --overwrite pod "$HOSTNAME" redis-role="slave"
  fi
}

# Copy base config files and make sure they are writable by redis
copy_config() {
  echo "Copying default redis config to ${REDIS_CONF}"
  cp /config-init/redis.conf "${REDIS_CONF}"
  echo "Copying default sentinel config to ${SENTINEL_CONF}"
  cp /config-init/sentinel.conf "${SENTINEL_CONF}"
  sleep 1
  chown ${UID} "${REDIS_CONF}"
  chmod 755 "${REDIS_CONF}"
  chown ${UID} "${SENTINEL_CONF}"
  chmod 755 "${SENTINEL_CONF}"
}

# Sets up pod for its default role: pod 0 is master and pods 1 and 2 are
# slaves.
setup_defaults() {
  echo "Setting up defaults using statefulset index (${INDEX})"
  if [[ "${INDEX}" == "0" ]]; then
    echo "Setting this pod as master for redis and sentinel.."
    update_config "$POD_IP"
  else
    echo "Assuming statefulset index 0 is master. Getting ip address"
    DEFAULT_MASTER="$(get_pod_ip 0)"
    echo "Identified redis (may be redis master) ip (${DEFAULT_MASTER})"
    if [[ -z "${DEFAULT_MASTER}" ]]; then
      echo "Error: Unable to resolve redis master."
      exit 1
    fi
    echo "Setting default slave config for redis and sentinel"
    update_config "${DEFAULT_MASTER}"
  fi
}

# Try to figure out IP of the current redis master
find_master() {
  echo "Verifying redis master (${MASTER}:${REDIS_PORT})"

  # Verify that we can connect to the selected master
  if ! ping_master_retry 3; then
    echo "Can't ping redis master (${MASTER})"
    echo "Attempting to force sentinel failover"

    if redis-cli -h "${SENTINEL_SERVICE}" -p "${SENTINEL_PORT}" sentinel failover "${MASTER_GROUP}" | grep -q 'NOGOODSLAVE' ; then
      echo "Failover returned with 'NOGOODSLAVE'"
      echo "Setting defaults for this pod"
      setup_defaults
      return 0
    fi

    echo "Waiting 10s for failover to complete"
    sleep 10

    # Find the new master's ip address
    identify_master

    if [[ -n "${MASTER}" ]]; then
      update_config "${MASTER}"
    else
      echo "Error: Could not failover, exiting..."
      exit 1
    fi
  else
    echo "Found reachable redis master (${MASTER})"
    update_config "${MASTER}"
  fi
}

get_pod_ip() {
  local index=${1:-${INDEX}}
  $KUBECTL get pod "${POD_BASE_NAME}-${index}" --template="{{.status.podIP}}"
}

install_kubectl() {
  echo "Installing curl"
  apt update && apt install -y curl
  echo "Installing kubectl"
  curl -L https://storage.googleapis.com/kubernetes-release/release/v"$KUBECTL_VERSION"/bin/linux/amd64/kubectl -o /k8s/kubectl
  chmod +x /k8s/kubectl
}

echo "Starting initialization"

install_kubectl

POD_IP=$(get_pod_ip)

copy_config
identify_master
if [[ -n "${MASTER}" ]]; then
  find_master
else
  setup_defaults
fi

echo "Done"
