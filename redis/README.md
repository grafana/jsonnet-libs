# Redis

A high-availabilty redis deployment inspired by https://github.com/DandyDeveloper/charts/tree/master/charts/redis-ha

> **Requires Redis >= 6.2.** Sentinel and replicas are configured by stable
> StatefulSet FQDN (via `sentinel resolve-hostnames`/`announce-hostnames` and
> `replica-announce-ip`), which require Redis 6.2+. Consumers pinning an older
> image (e.g. 6.0) must bump before adopting this version.

## Containers

This configuration deploys a stateful set where each replica pod runs 5 containers:
- Redis server
- Redis sentinel
- Redis server metrics exporter
- Redis sentinel metrics exporter
- Redis label reconciler (self-labels the pod's `redis-role`; see below)

One redis server instance is configured as the master, and any other instances are configured as replicas. The sentinels monitor the master and promote a replica if the master becomes unavailable.

## Identity by FQDN, not pod IP

Replication and Sentinel are configured entirely in terms of each pod's stable
StatefulSet FQDN (`<pod>.<service>.<namespace>.svc.cluster.local`) rather than
its pod IP. A rolling restart changes every pod IP, and the previous IP-based
config left Sentinel monitoring dead "ghost" addresses, which drove spurious
failovers and split-brain. FQDNs are stable across restarts, so this no longer
happens. This requires Redis >= 6.2 (`sentinel resolve-hostnames yes`,
`sentinel announce-hostnames yes`, `replica-announce-ip`).

## Startup Logic

On startup an init container configures the pod:

- Determine the current master's FQDN: prefer Sentinel's view if Sentinel is
  reachable (`sentinel get-master-addr-by-name`, which returns an FQDN), else
  default to StatefulSet index 0.
- Configure the pod as a `replicaof` that master unless it *is* the master.
  A restarting pod therefore rejoins as a replica instead of self-promoting,
  which prevents the "restarting pod self-promotes from stale data → two live
  masters" split-brain.

## Kubernetes Service & the `redis-role` label

A `redis-master` Kubernetes service routes requests to the current master,
selecting on the `redis-role=master` pod label (and `redis-slave` on
`redis-role=slave`).

The label is maintained by the **`redis-label-reconciler`** sidecar in each pod:
it continuously labels *its own* pod from the ground-truth role reported by its
local `redis-cli role`. Because each pod only writes its own label from its own
actual role, the Service endpoint always converges on the true master within a
few seconds, regardless of Sentinel state. This replaces the previous mechanism
(label set once at init and mutated cross-pod by a Sentinel
`client-reconfig-script`), which could strand the Service with **zero
endpoints** if a reconfig event resolved to a stale/ghost IP — it demoted the
old master before failing to promote the new one.
