// Cluster-level Signals
// DBA Question: "How is my cluster as a whole?"
// Aggregated signals across all instances in a cluster

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],  // Empty - cluster dashboard doesn't filter by instance
    aggLevel: 'group',  // Aggregate at cluster level, not instance
    aggFunction: 'sum',
    discoveryMetric: {
      postgres_exporter: 'pg_up',
    },
    signals: {
      // ============================================
      // Cluster Health Signals
      // ============================================

      // Cluster status - minimum of all instances (0 if any is down)
      clusterStatus: {
        name: 'Cluster status',
        description: 'Whether all PostgreSQL instances in the cluster are up. 0 if any instance is down.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'min',
        sources: {
          postgres_exporter: {
            expr: 'pg_up{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: Cluster status',
          },
        },
      },

      // Total instances in cluster
      totalInstances: {
        name: 'Total instances',
        description: 'Total number of PostgreSQL instances in the cluster.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'count',
        sources: {
          postgres_exporter: {
            expr: 'pg_up{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: Total instances',
          },
        },
      },

      // Up instances count
      upInstances: {
        name: 'Up instances',
        description: 'Number of PostgreSQL instances currently up.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_up{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: Up instances',
          },
        },
      },

      // Primary count in cluster
      primaryCount: {
        name: 'Primary count',
        description: 'Number of primary instances. Should be exactly 1 for a healthy cluster.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'count',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_is_replica{%(queriesSelector)s} == 0',
            legendCustomTemplate: '{{cluster}}: Primary count',
          },
        },
      },

      // Replica count in cluster
      replicaCount: {
        name: 'Replica count',
        description: 'Number of replica instances in the cluster.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'count',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_is_replica{%(queriesSelector)s} == 1',
            legendCustomTemplate: '{{cluster}}: Replica count',
          },
        },
      },

      // Maximum replication lag across all replicas
      maxReplicationLag: {
        name: 'Max replication lag',
        description: 'Maximum replication lag in seconds across all replicas.',
        type: 'gauge',
        unit: 's',
        aggFunction: 'max',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_lag_seconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: Max replication lag',
          },
        },
      },

      // Worst (minimum) cache hit ratio across cluster - keeps instance label for drill-down
      worstCacheHitRatio: {
        name: 'Worst cache hit ratio',
        description: 'Lowest cache hit ratio across all instances. Shows worst-performing instance.',
        type: 'raw',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              label_replace(
                bottomk(1,
                  sum by (instance) (pg_stat_database_blks_hit{%(queriesSelector)s})
                  /
                  (
                    sum by (instance) (pg_stat_database_blks_hit{%(queriesSelector)s})
                    +
                    sum by (instance) (pg_stat_database_blks_read{%(queriesSelector)s})
                    + 1
                  )
                ),
                "worst_instance", "$1", "instance", "(.*)"
              )
            |||,
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Worst (maximum) connection utilization across cluster - keeps instance label for drill-down
      worstConnectionUtilization: {
        name: 'Worst connection utilization',
        description: 'Highest connection utilization across all instances.',
        type: 'raw',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              label_replace(
                topk(1,
                  sum by (instance) (pg_stat_activity_count{%(queriesSelector)s})
                  /
                  max by (instance) (pg_settings_max_connections{%(queriesSelector)s})
                ),
                "worst_instance", "$1", "instance", "(.*)"
              )
            |||,
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Total deadlocks across cluster
      totalDeadlocks: {
        name: 'Total deadlocks',
        description: 'Total deadlocks detected across all instances in the cluster.',
        type: 'counter',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_database_deadlocks{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: Total deadlocks',
          },
        },
      },

      // ============================================
      // Master History / Failover Signals
      // ============================================

      // Current primary instance (for display)
      currentPrimary: {
        name: 'Current primary',
        description: 'The instance currently acting as primary.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_is_replica{%(queriesSelector)s} == 0',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Role per instance (for state timeline)
      instanceRole: {
        name: 'Instance role',
        description: 'Role of each instance. 0 = Primary, 1 = Replica.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_is_replica{%(queriesSelector)s}',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Role changes (failover detection) - for time series
      roleChanges: {
        name: 'Role changes',
        description: 'Detects when instance roles change (failover events).',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'changes(pg_replication_is_replica{%(queriesSelector)s}[5m])',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}: Role changes',
          },
        },
      },

      // Role changes for table - count over dashboard time range
      instanceRoleChanges: {
        name: 'Instance role changes',
        description: 'Number of role changes (failovers) per instance in the selected time range.',
        type: 'raw',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'changes(pg_replication_is_replica{%(queriesSelector)s}[$__range])',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // ============================================
      // Replication Topology Signals
      // ============================================

      // Replication lag per replica (for time series)
      replicationLagByInstance: {
        name: 'Replication lag by instance',
        description: 'Replication lag in seconds per replica instance.',
        type: 'gauge',
        unit: 's',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_lag_seconds{%(queriesSelector)s}',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}: Replication lag',
          },
        },
      },

      // Replication slot lag in bytes
      replicationSlotLagByInstance: {
        name: 'Replication slot lag by instance',
        description: 'WAL bytes pending per replication slot.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_replication_pg_wal_lsn_diff{%(queriesSelector)s}',
            aggKeepLabels: ['instance', 'client_addr', 'application_name', 'state'],
            legendCustomTemplate: '{{client_addr}} ({{state}})',
          },
        },
      },

      // WAL position on primary
      walPosition: {
        name: 'WAL position',
        description: 'Current WAL LSN position in bytes on the primary.',
        type: 'gauge',
        unit: 'bytes',
        aggFunction: 'max',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_replication_pg_current_wal_lsn_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: WAL position',
          },
        },
      },

      // ============================================
      // Cluster Problems (Aggregated)
      // ============================================

      // Total long-running queries across cluster
      totalLongRunningQueries: {
        name: 'Total long-running queries',
        description: 'Total queries running longer than 5 minutes across all instances.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_long_running_transactions{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: Long-running queries',
          },
        },
      },

      // Total blocked queries across cluster
      totalBlockedQueries: {
        name: 'Total blocked queries',
        description: 'Total queries waiting for locks across all instances.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_locks_count{%(queriesSelector)s, mode="exclusivelock"}',
            legendCustomTemplate: '{{cluster}}: Blocked queries',
          },
        },
      },

      // Total idle in transaction across cluster
      totalIdleInTransaction: {
        name: 'Total idle in transaction',
        description: 'Total connections idle in transaction across all instances.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_activity_count{%(queriesSelector)s, state="idle in transaction"}',
            legendCustomTemplate: '{{cluster}}: Idle in transaction',
          },
        },
      },

      // Total WAL archive failures across cluster
      totalWalArchiveFailures: {
        name: 'Total WAL archive failures',
        description: 'Total WAL archive failures across all instances.',
        type: 'counter',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_archiver_failed_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: WAL archive failures',
          },
        },
      },

      // Worst lock utilization across cluster
      worstLockUtilization: {
        name: 'Worst lock utilization',
        description: 'Highest lock utilization across all instances.',
        type: 'gauge',
        unit: 'percentunit',
        aggFunction: 'max',
        sources: {
          postgres_exporter: {
            expr: |||
              (
                sum by (%(agg)s, instance) (pg_locks_count{%(queriesSelector)s})
                /
                (
                  max by (%(agg)s, instance) (pg_settings_max_locks_per_transaction{%(queriesSelector)s})
                  *
                  max by (%(agg)s, instance) (pg_settings_max_connections{%(queriesSelector)s})
                )
              )
            |||,
            legendCustomTemplate: '{{cluster}}: Worst lock utilization',
          },
        },
      },

      // Total exporter errors across cluster
      totalExporterErrors: {
        name: 'Total exporter errors',
        description: 'Total exporter scrape errors across all instances.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_exporter_last_scrape_error{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: Exporter errors',
          },
        },
      },

      // ============================================
      // Read/Write Split Signals
      // ============================================

      // Write operations from primary only (inserts)
      primaryInserts: {
        name: 'Primary inserts',
        description: 'Rows inserted per second on the primary.',
        type: 'raw',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (
                rate(pg_stat_database_tup_inserted{%(queriesSelector)s}[$__rate_interval])
                and on(instance)
                (pg_replication_is_replica{%(queriesSelector)s} == 0)
              )
            |||,
            legendCustomTemplate: '{{cluster}}: Inserts',
          },
        },
      },

      // Write operations from primary only (updates)
      primaryUpdates: {
        name: 'Primary updates',
        description: 'Rows updated per second on the primary.',
        type: 'raw',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (
                rate(pg_stat_database_tup_updated{%(queriesSelector)s}[$__rate_interval])
                and on(instance)
                (pg_replication_is_replica{%(queriesSelector)s} == 0)
              )
            |||,
            legendCustomTemplate: '{{cluster}}: Updates',
          },
        },
      },

      // Write operations from primary only (deletes)
      primaryDeletes: {
        name: 'Primary deletes',
        description: 'Rows deleted per second on the primary.',
        type: 'raw',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (
                rate(pg_stat_database_tup_deleted{%(queriesSelector)s}[$__rate_interval])
                and on(instance)
                (pg_replication_is_replica{%(queriesSelector)s} == 0)
              )
            |||,
            legendCustomTemplate: '{{cluster}}: Deletes',
          },
        },
      },

      // Read operations per instance (fetched)
      readsByInstance: {
        name: 'Reads by instance',
        description: 'Rows fetched per second per instance.',
        type: 'gauge',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_database_tup_fetched{%(queriesSelector)s}[$__rate_interval])',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}: Fetched',
          },
        },
      },

      // TPS per instance
      tpsByInstance: {
        name: 'TPS by instance',
        description: 'Transactions per second per instance.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: |||
              rate(pg_stat_database_xact_commit{%(queriesSelector)s}[$__rate_interval])
              +
              rate(pg_stat_database_xact_rollback{%(queriesSelector)s}[$__rate_interval])
            |||,
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}: TPS',
          },
        },
      },

      // QPS by instance (requires pg_stat_statements)
      qpsByInstance: {
        name: 'QPS by instance',
        description: 'Queries per second per instance. Requires pg_stat_statements extension.',
        type: 'raw',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (instance) (
                rate(pg_stat_statements_calls_total{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}: QPS',
          },
        },
      },

      // Total writes (for ratio calculation)
      totalWrites: {
        name: 'Total writes',
        description: 'Total write operations (insert + update + delete) per second.',
        type: 'raw',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (
                (
                  rate(pg_stat_database_tup_inserted{%(queriesSelector)s}[$__rate_interval])
                  +
                  rate(pg_stat_database_tup_updated{%(queriesSelector)s}[$__rate_interval])
                  +
                  rate(pg_stat_database_tup_deleted{%(queriesSelector)s}[$__rate_interval])
                )
                and on(instance)
                (pg_replication_is_replica{%(queriesSelector)s} == 0)
              )
            |||,
            legendCustomTemplate: '{{cluster}}: Total writes',
          },
        },
      },

      // Total reads (for ratio calculation)
      totalReads: {
        name: 'Total reads',
        description: 'Total read operations (fetched) per second across all instances.',
        type: 'gauge',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_database_tup_fetched{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}}: Total reads',
          },
        },
      },

      // ============================================
      // Cluster Resources Signals
      // ============================================

      // Total connections across cluster
      totalConnections: {
        name: 'Total connections',
        description: 'Total active connections across all instances.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_activity_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: Total connections',
          },
        },
      },

      // Total max connections across cluster
      totalMaxConnections: {
        name: 'Total max connections',
        description: 'Sum of max_connections across all instances.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_settings_max_connections{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}}: Total max connections',
          },
        },
      },

      // Connections by instance
      connectionsByInstance: {
        name: 'Connections by instance',
        description: 'Active connections per instance.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_activity_count{%(queriesSelector)s}',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}: Connections',
          },
        },
      },

      // Cache hit ratio by instance
      cacheHitRatioByInstance: {
        name: 'Cache hit ratio by instance',
        description: 'Cache hit ratio per instance.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              (
                sum by (%(agg)s, instance) (pg_stat_database_blks_hit{%(queriesSelector)s})
                /
                (
                  sum by (%(agg)s, instance) (pg_stat_database_blks_hit{%(queriesSelector)s})
                  +
                  sum by (%(agg)s, instance) (pg_stat_database_blks_read{%(queriesSelector)s})
                )
              )
            |||,
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}: Cache hit ratio',
          },
        },
      },

      // Total database size (from primary only to avoid double counting)
      totalDatabaseSize: {
        name: 'Total database size',
        description: 'Total size of all databases on the primary.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (
                pg_database_size_bytes{%(queriesSelector)s}
                and on(instance)
                (pg_replication_is_replica{%(queriesSelector)s} == 0)
              )
            |||,
            legendCustomTemplate: '{{cluster}}: Total database size',
          },
        },
      },

      // ============================================
      // Instance Table Signals (for table panel)
      // ============================================

      // Instance status for table
      instanceStatus: {
        name: 'Instance status',
        description: 'Status of each instance.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_up{%(queriesSelector)s}',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Instance uptime for table
      instanceUptime: {
        name: 'Instance uptime',
        description: 'Uptime of each instance.',
        type: 'gauge',
        unit: 's',
        sources: {
          postgres_exporter: {
            expr: 'time() - pg_postmaster_start_time_seconds{%(queriesSelector)s}',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Instance connection utilization for table
      instanceConnectionUtilization: {
        name: 'Instance connection utilization',
        description: 'Connection utilization per instance.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              (
                sum by (%(agg)s, instance) (pg_stat_activity_count{%(queriesSelector)s})
                /
                max by (%(agg)s, instance) (pg_settings_max_connections{%(queriesSelector)s})
              )
            |||,
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Instance cache hit ratio for table
      instanceCacheHitRatio: {
        name: 'Instance cache hit ratio',
        description: 'Cache hit ratio per instance.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              (
                sum by (%(agg)s, instance) (pg_stat_database_blks_hit{%(queriesSelector)s})
                /
                (
                  sum by (%(agg)s, instance) (pg_stat_database_blks_hit{%(queriesSelector)s})
                  +
                  sum by (%(agg)s, instance) (pg_stat_database_blks_read{%(queriesSelector)s})
                )
              )
            |||,
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Instance replication lag for table
      instanceReplicationLag: {
        name: 'Instance replication lag',
        description: 'Replication lag per instance (replicas only).',
        type: 'gauge',
        unit: 's',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_lag_seconds{%(queriesSelector)s}',
            aggKeepLabels: ['instance'],
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }

