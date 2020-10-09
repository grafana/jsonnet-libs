
# Kubernetes Operator for Percona Server MongoDB

https://www.percona.com/doc/kubernetes-operator-for-psmongodb/kubernetes.html

To use:

```bash
$ jb install github.com/grafana/jsonnet-libs/psmdbs-operator
```

```jsonnet
local percona = (import 'psmdbs-operator/psmdbs-operator.libsonnet');
{
  percona: percona {
    _config+:: {
      /* Defaults
      custom_crds: true,
      percona_enable_default_cluster: true,
      percona_namespace: 'psmdb',
      percona_mongodb_backup_user: 'backup',
      percona_mongodb_backup_password: 'backup123456',
      percona_mongodb_cluster_admin_user: 'clusterAdmin',
      percona_mongodb_cluster_admin_password: 'clusterAdmin123456',
      percona_mongodb_cluster_monitor_user: 'clusterMonitor',
      percona_mongodb_cluster_monitor_password: 'clusterMonitor123456',
      percona_mongodb_user_admin_user: 'userAdmin',
      percona_mongodb_user_admin_password: 'userAdmin123456',
      percona_mongodb_pmm_server_user: 'pmm',
      percona_mongodb_pmm_server_password: 'supa|^|pazz',
      */
    },
  },
}
```

By default this will install the default cluster as outlined in percona
docs.
To disable creating crds, set `custom_crds: false` in the `_config` object.

To create a new custom operator, functions are provided:

```jsonnet
local percona = (import 'psmdbs-operator/psmdbs-operator.libsonnet');
{
  operator: percona {
    _config+:: {
      percona_enable_default_cluster: false,
      // ...
    },
    yet_another_example: percona.percona.cluster.new('yet-another', {
      MONGODB_BACKUP_USER: 'exbackup00',
      MONGODB_BACKUP_PASSWORD: 'exbackup0012346',
      MONGODB_USER_ADMIN_USER: 'exuseradmin00',
      MONGODB_USER_ADMIN_PASSWORD: 'exuseradmin0012346',
      MONGODB_CLUSTER_ADMIN_USER: 'exclusteradmin00',
      MONGODB_CLUSTER_ADMIN_PASSWORD: 'exclusteradmin0012346',
      MONGODB_CLUSTER_MONITOR_USER: 'exmonitor00',
      MONGODB_CLUSTER_MONITOR_PASSWORD: 'exmonitor0012346',
      PMM_SERVER_USER: 'pmmuser00',
      PMM_SERVER_PASSWORD: 'pmuser00',
    }),
  },
}
```
