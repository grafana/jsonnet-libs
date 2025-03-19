#!/bin/bash

# This script is called by sentinels when they failover to a new master. It
# updates the redis-role label on each redis pod so that the redis-master
# Kubernetes service will route traffic to the newly elected master.

# The following arguments are passed to the script:
# <master-name> <role> <state> <from-ip> <from-port> <to-ip> <to-port>
# e.g. 'redis-sentinel-master.redis-sentinel.svc.cluster.local leader failover 10.132.9.66 6379 10.132.5.32 6379'

set -eu
set -o pipefail

NEW_MASTER_IP=$6
# We don't have permissions to write to the default cache dir,
# which causes our requests to be throttled. Use a custom
# cache directory, which kubectl will create.
KUBECTL="/k8s/kubectl --cache-dir=/tmp/.kube/cache"

echo "Relabeling new master (${NEW_MASTER_IP})"

# Find all pods labeled with redis-role=master and demote them if necessary
OLD_MASTER_PODS=$($KUBECTL get pod \
  -l redis-role=master \
  -o jsonpath="{range .items[*]}{.metadata.name},{.status.podIP}{'\n'}{end}" \
  --field-selector="status.phase=Running,status.podIP!=${NEW_MASTER_IP}" \
)

for OLD_MASTER_POD in $OLD_MASTER_PODS; do
  POD_NAME=$(echo "$OLD_MASTER_POD" | cut -f1 -d,)
  POD_IP=$(echo "$OLD_MASTER_POD" | cut -f2 -d,)

  echo "Found pod with redis-role=master label: ${POD_NAME} (${POD_IP})"

  echo "Setting redis-role=slave on ${POD_NAME}"
  $KUBECTL label --overwrite pod "$POD_NAME" redis-role="slave"
done

# Promote new master
NEW_MASTER_POD=$($KUBECTL get pod \
  -o jsonpath="{.items[*].metadata.name}" \
  --field-selector="status.phase=Running,status.podIP=${NEW_MASTER_IP}"
)

echo "Setting redis-role=master on ${NEW_MASTER_POD}"
$KUBECTL label --overwrite pod "$NEW_MASTER_POD" redis-role="master"
