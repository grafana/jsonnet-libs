local k = import 'ksonnet-util/kausal.libsonnet';
k {
  _config+:: {
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
  },

  local secret = $.core.v1.secret,

  percona: {
    percona_namespace: {
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: $._config.percona_namespace,
      },
    },
    cluster:: {
      new(name, config)::
        {
          local secret_name = '%s-secrets' % name,
          secret: $.percona.cluster.percona_cluster_secrets.new(secret_name, $.percona.cluster.utils.withCreds(config)),
          server: $.percona.cluster.percona_server.new(name, secret_name),
        },

      utils: {
        withCreds(creds):: {
          MONGODB_BACKUP_USER: std.base64(creds.MONGODB_BACKUP_USER),
          MONGODB_BACKUP_PASSWORD: std.base64(creds.MONGODB_BACKUP_PASSWORD),
          MONGODB_CLUSTER_ADMIN_USER: std.base64(creds.MONGODB_CLUSTER_ADMIN_USER),
          MONGODB_CLUSTER_ADMIN_PASSWORD: std.base64(creds.MONGODB_CLUSTER_ADMIN_PASSWORD),
          MONGODB_CLUSTER_MONITOR_USER: std.base64(creds.MONGODB_CLUSTER_MONITOR_USER),
          MONGODB_CLUSTER_MONITOR_PASSWORD: std.base64(creds.MONGODB_CLUSTER_MONITOR_PASSWORD),
          MONGODB_USER_ADMIN_USER: std.base64(creds.MONGODB_USER_ADMIN_USER),
          MONGODB_USER_ADMIN_PASSWORD: std.base64(creds.MONGODB_USER_ADMIN_PASSWORD),
          PMM_SERVER_USER: std.base64(creds.PMM_SERVER_USER),
          PMM_SERVER_PASSWORD: std.base64(creds.PMM_SERVER_PASSWORD),
        },
      },
      percona_cluster_secrets::
        secret.new('my-cluster-name-secrets',
                   {
                     MONGODB_BACKUP_USER: std.base64($._config.percona_mongodb_backup_user),
                     MONGODB_BACKUP_PASSWORD: std.base64($._config.percona_mongodb_backup_password),
                     MONGODB_CLUSTER_ADMIN_USER: std.base64($._config.percona_mongodb_cluster_admin_user),
                     MONGODB_CLUSTER_ADMIN_PASSWORD: std.base64($._config.percona_mongodb_cluster_admin_password),
                     MONGODB_CLUSTER_MONITOR_USER: std.base64($._config.percona_mongodb_cluster_monitor_user),
                     MONGODB_CLUSTER_MONITOR_PASSWORD: std.base64($._config.percona_mongodb_cluster_monitor_password),
                     MONGODB_USER_ADMIN_USER: std.base64($._config.percona_mongodb_user_admin_user),
                     MONGODB_USER_ADMIN_PASSWORD: std.base64($._config.percona_mongodb_user_admin_password),
                     PMM_SERVER_USER: std.base64($._config.percona_mongodb_pmm_server_user),
                     PMM_SERVER_PASSWORD: std.base64($._config.percona_mongodb_pmm_server_password),
                   }) +
        {
          metadata+: { namespace: $._config.percona_namespace },
          new(name, data)::
            super.new(name, data) +
            { metadata+: { namespace: $._config.percona_namespace } },
        },
      percona_server:: {
        new(name, secret_name)::
          local security_key_name = '%s-mongodb-encryption-key' % name;
          self + { metadata+: { name: name } } +
          $.percona.cluster.percona_server.withSecret(secret_name) +
          $.percona.cluster.percona_server.withSecurityPolicy(security_key_name),
        withSecurityPolicy(name)::
          { spec+: { mongod+: { security+: { encryptionKeySecret: name } } } },
        withSecret(name)::
          { spec+: { secrets+: { users: name } } },
        apiVersion: 'psmdb.percona.com/v1-5-0',
        kind: 'PerconaServerMongoDB',
        metadata: {
          name: 'my-cluster-name',
          namespace: $._config.percona_namespace,
        },
        spec: {
          allowUnsafeConfigurations: false,
          backup: {
            enabled: true,
            image: 'percona/percona-server-mongodb-operator:1.5.0-backup',
            restartOnFailure: true,
            serviceAccountName: 'percona-server-mongodb-operator',
            storages: null,
            tasks: null,
          },
          image: 'percona/percona-server-mongodb:4.2.8-8',
          imagePullPolicy: 'Always',
          mongod: {
            net: {
              hostPort: 0,
              port: 27017,
            },
            operationProfiling: {
              mode: 'slowOp',
              rateLimit: 100,
              slowOpThresholdMs: 100,
            },
            security: {
              enableEncryption: true,
              encryptionCipherMode: 'AES256-CBC',
              encryptionKeySecret: 'my-cluster-name-mongodb-encryption-key',
              redactClientLogData: false,
            },
            setParameter: {
              ttlMonitorSleepSecs: 60,
              wiredTigerConcurrentReadTransactions: 128,
              wiredTigerConcurrentWriteTransactions: 128,
            },
            storage: {
              engine: 'wiredTiger',
              inMemory: {
                engineConfig: {
                  inMemorySizeRatio: 0.9,
                },
              },
              mmapv1: {
                nsSize: 16,
                smallfiles: false,
              },
              wiredTiger: {
                collectionConfig: {
                  blockCompressor: 'snappy',
                },
                engineConfig: {
                  cacheSizeRatio: 0.5,
                  directoryForIndexes: false,
                  journalCompressor: 'snappy',
                },
                indexConfig: {
                  prefixCompression: true,
                },
              },
            },
          },
          pmm: {
            enabled: false,
            image: 'percona/percona-server-mongodb-operator:1.5.0-pmm',
            serverHost: 'monitoring-service',
          },
          replsets: [
            {
              affinity: {
                antiAffinityTopologyKey: 'kubernetes.io/hostname',
              },
              arbiter: {
                affinity: {
                  antiAffinityTopologyKey: 'kubernetes.io/hostname',
                },
                enabled: false,
                size: 1,
              },
              expose: {
                enabled: false,
                exposeType: 'LoadBalancer',
              },
              name: 'rs0',
              podDisruptionBudget: {
                maxUnavailable: 1,
              },
              resources: {
                limits: {
                  cpu: '300m',
                  memory: '0.5G',
                },
                requests: {
                  cpu: '300m',
                  memory: '0.5G',
                },
              },
              size: 3,
              volumeSpec: {
                persistentVolumeClaim: {
                  resources: {
                    requests: {
                      storage: '3Gi',
                    },
                  },
                },
              },
            },
          ],
          secrets: {
            users: $.percona.cluster.percona_cluster_secrets.metadata.name,
          },
          updateStrategy: 'SmartUpdate',
          upgradeOptions: {
            apply: 'recommended',
            schedule: '0 2 * * *',
            versionServiceEndpoint: 'https://check.percona.com/versions/',
          },
        },
      },
    },
  },

  crds:
    if $._config.custom_crds
    then std.native('parseYaml')(importstr 'files/00-crd.yaml')
    else {},


  rbacs: {
    role: {
      apiVersion: 'rbac.authorization.k8s.io/v1beta1',
      kind: 'Role',
      metadata: {
        namespace: $._config.percona_namespace,
        name: 'percona-server-mongodb-operator',
      },
      rules: [
        {
          apiGroups: [
            'psmdb.percona.com',
          ],
          resources: [
            'perconaservermongodbs',
            'perconaservermongodbs/status',
            'perconaservermongodbbackups',
            'perconaservermongodbbackups/status',
            'perconaservermongodbrestores',
            'perconaservermongodbrestores/status',
          ],
          verbs: [
            'get',
            'list',
            'update',
            'watch',
            'create',
          ],
        },
        {
          apiGroups: [
            '',
          ],
          resources: [
            'pods',
            'pods/exec',
            'services',
            'persistentvolumeclaims',
            'secrets',
            'configmaps',
          ],
          verbs: [
            'get',
            'list',
            'watch',
            'create',
            'update',
            'patch',
            'delete',
          ],
        },
        {
          apiGroups: [
            'apps',
          ],
          resources: [
            'deployments',
            'replicasets',
            'statefulsets',
          ],
          verbs: [
            'get',
            'list',
            'watch',
            'create',
            'update',
            'patch',
            'delete',
          ],
        },
        {
          apiGroups: [
            'batch',
          ],
          resources: [
            'cronjobs',
          ],
          verbs: [
            'get',
            'list',
            'watch',
            'create',
            'update',
            'patch',
            'delete',
          ],
        },
        {
          apiGroups: [
            'policy',
          ],
          resources: [
            'poddisruptionbudgets',
          ],
          verbs: [
            'get',
            'list',
            'watch',
            'create',
            'update',
            'patch',
            'delete',
          ],
        },
        {
          apiGroups: [
            'certmanager.k8s.io',
          ],
          resources: [
            'issuers',
            'certificates',
          ],
          verbs: [
            'get',
            'list',
            'watch',
            'create',
            'update',
            'patch',
            'delete',
            'deletecollection',
          ],
        },
      ],
    },
    serviceaccount: {
      apiVersion: 'v1',
      kind: 'ServiceAccount',
      metadata: {
        namespace: $._config.percona_namespace,
        name: 'percona-server-mongodb-operator',
      },
    },
    role_binding: {
      apiVersion: 'rbac.authorization.k8s.io/v1beta1',
      kind: 'RoleBinding',
      metadata: {
        namespace: $._config.percona_namespace,
        name: 'service-account-percona-server-mongodb-operator',
      },
      roleRef: {
        apiGroup: 'rbac.authorization.k8s.io',
        kind: 'Role',
        name: 'percona-server-mongodb-operator',
      },
      subjects: [
        {
          kind: 'ServiceAccount',
          name: 'percona-server-mongodb-operator',
        },
      ],
    },
  },

  operator: {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      namespace: $._config.percona_namespace,
      name: 'percona-server-mongodb-operator',
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          name: 'percona-server-mongodb-operator',
        },
      },
      template: {
        metadata: {
          labels: {
            name: 'percona-server-mongodb-operator',
          },
        },
        spec: {
          containers: [
            {
              command: [
                'percona-server-mongodb-operator',
              ],
              env: [
                {
                  name: 'WATCH_NAMESPACE',
                  valueFrom: {
                    fieldRef: {
                      fieldPath: 'metadata.namespace',
                    },
                  },
                },
                {
                  name: 'POD_NAME',
                  valueFrom: {
                    fieldRef: {
                      fieldPath: 'metadata.name',
                    },
                  },
                },
                {
                  name: 'OPERATOR_NAME',
                  value: 'percona-server-mongodb-operator',
                },
                {
                  name: 'RESYNC_PERIOD',
                  value: '5s',
                },
                {
                  name: 'LOG_VERBOSE',
                  value: 'false',
                },
              ],
              image: 'percona/percona-server-mongodb-operator:1.5.0',
              imagePullPolicy: 'Always',
              name: 'percona-server-mongodb-operator',
              ports: [
                {
                  containerPort: 60000,
                  name: 'metrics',
                },
              ],
            },
          ],
          serviceAccountName: 'percona-server-mongodb-operator',
        },
      },
    },
  },

  default_cluster: if $._config.percona_enable_default_cluster then {
    secret: $.percona.cluster.percona_cluster_secrets,
    server: $.percona.cluster.percona_server,
  } else {},


  /*
  yet_another_example: $.percona.cluster.new('yet-another', {
    MONGODB_BACKUP_USER: 'exbackup00',
    MONGODB_BACKUP_PASSWORD: 'exbackup00',
    MONGODB_USER_ADMIN_USER: 'exuseradmin00',
    MONGODB_USER_ADMIN_PASSWORD: 'exuseradmin00',
    MONGODB_CLUSTER_ADMIN_USER: 'exclusteradmin00',
    MONGODB_CLUSTER_ADMIN_PASSWORD: 'exclusteradmin00',
    MONGODB_CLUSTER_MONITOR_USER: 'exmonitor00',
    MONGODB_CLUSTER_MONITOR_PASSWORD: 'exmonitor00',
    PMM_SERVER_USER: 'pmmuser00',
    PMM_SERVER_PASSWORD: 'pmuser00',
  }),
  */
}
