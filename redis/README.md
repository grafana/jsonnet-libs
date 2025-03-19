# Redis

A high-availabilty redis deployment inspired by https://github.com/DandyDeveloper/charts/tree/master/charts/redis-ha

## Containers

This configuration deploys a stateful set where each replica pod runs 4 containers:
- Redis server
- Redis sentinel
- Redis server metrics exporter
- Redis sentinel metrics exporter

One redis server instance is configured as as the master, and any other instances are configured as slaves. The sentinels will monitor a given master and will promote one of the slaves if the existing master becomes unavailable.

## Startup Logic

When a pod first starts up the following logic is performed in an init container in order to determine whether the pod should be configured as a master or slave:

- Query the existing sentinels for the current redis master
- If no sentinels are found, the pod is setup in its default role (pod0 is master, everyone else is slave).
- If the sentinels return a master IP address:
  - Ping the master to verify that it is on-line
  - If master is reachable update pod's sentinel and server config to point to master and launch.
  - If master is not reachable, manually trigger a sentinel failover and wait for the new master to become available.

## Kubernetes Service

A `redis-master` Kubernetes service is created that routes requests to the current Redis master. The `redis-role` label is used as a selector for this service, and is automatically updated on each of the stateful set's pods when the sentinels performs a failover.
