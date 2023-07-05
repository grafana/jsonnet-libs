<!-- 
NOTE: There are several links in this file that don't have an URL associated, like [Redis Overview dashboard].
      This is made on purpose, as this way a vendored version can just append them at the end of the document 
      pointing to the correct URL.
-->
# Redis Runbooks

## Alerts

## RedisMultipleMasters

The Redis deployment has more than one pod running as master.

Go to the [Redis Overview dashboard], select the correct cluster/namespace, and review the "Instance Roles" table. Ideally only one pod should have a "Server Role" of "master", and the "Sentinel Master" for each pod should equal the IP address of that master pod.

If more than one pod has a reported role of "master", one of them should be restarted (prefer to keep the one recognized as master by any sentinels). When the pod restarts, it should query the sentinels for the correct master IP and connect to it.

Note: the Redis pods have a `redis-role` label but removing or modifying it won't affect the actual role of a Redis pod ([read more](#redis-role-label)).

## RedisNoMaster

The Redis deployment has no pod running as the master.

Try restarting the `redis-0` pod. When it comes back up it should query the sentinels for the current master, and trigger a failover if the specified master is unreachable. If the failover is unsuccessful `redis-0` will assume the master role.

Note: the Redis pods have a `redis-role` label but removing or modifying it won't affect the actual role of a Redis pod ([read more](#redis-role-label)).

## RedisMasterLinkDown

One or more Redis slave is not fully synced with the master. This could either mean the master is unavailable, or the initial master to slave replication step is failing.

### Replication Buffer

Check the master pod logs, if you see a message like this
```
default scheduled to be closed ASAP for overcoming of output buffer limits
```
it probably means replication is failing because the replication buffer memory limit is being exceeded.

To see the current buffer limits shell into the Redis master pod:

```sh
$ kubectl --context=<cluster> -n <namespace> exec --stdin --tty <master-pod> -- redis-cli
> auth <redis-password>
> config get client-output-buffer-limit
1) "client-output-buffer-limit"
2) "normal 0 0 0 slave 268435456 67108864 60 pubsub 33554432 8388608 60"
```

The "`slave x x x`" numbers are applicable for replication. They represent a hard limit/soft limit/soft limit seconds, where replication will fail if the buffer exceeds the hard limit, or the soft limit for the respective number of seconds.

You can increase the buffer limit at runtime (assuming the Kubernetes memory limit is sufficient) by running:

```sh
config set client-output-buffer-limit "slave <new_hard_limit> <new_soft_limit> <new_soft_limit_seconds>"
```

If this resolves the issue be sure to open a PR to increase the buffer limits permanently.

Further Reading:
- https://redis.com/blog/top-redis-headaches-for-devops-replication-buffer
- https://redis.com/blog/the-endless-redis-replication-loop-what-why-and-how-to-solve-it/

### Replication Timeout

If replication is failing, and the buffer limit is sufficient, the replication timeout may be being exceeded.

To get the current replication timeout in seconds, shell into the Redis master pod:

```sh
$ kubectl --context=<cluster> -n <namespace> exec --stdin --tty <master-pod> -- redis-cli
> auth <redis-password>
> config get repl-timeout
```

You can increase the timeout at runtime by running:

```sh
> config set repl-timeout <new_timeout>
```

Further Reading:
- https://redis.com/blog/top-redis-headaches-for-devops-replication-timeouts/

## RedisHighMemoryUtilisation

Instance is approaching it's memory limit. In addition to the data-set, background saves and initial slave replication can cause high memory usage.

## `redis-role` Label

Each Redis pod has a `redis-role` label that is used solely as a selector for the `redis-master` Kubernetes service. This label merely reflects the internal state of the Redis deployment — removing or modifying it won't affect the actual role of a Redis pod.

The label gets updated by [label.sh](https://github.com/grafana/jsonnet-libs/blob/master/redis/files/label.sh), which gets run by the sentinels whenever a failover occurs.

If the `redis-role` labels get out of sync with the internal Redis state, and your app connects to Redis via the `redis-master` Kubernetes service, you may be unable to connect to Redis, or see errors like "READONLY You can't write against a read only replica".

To remedy this go to the [Redis Overview dashboard], select the correct cluster/namespace, and review the "Instance Roles" table. Each pod's `redis-role` label should be updated to match the value in the "Server Role" column.
