// Tier 1: Critical Health Signals
// DBA Question: "Is there a problem RIGHT NOW?"
// These 6 signals provide at-a-glance health status

local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      postgres_exporter: 'pg_up',
    },
    signals: {
      // Is the database responding?
      up: {
        name: 'PostgreSQL status',
        description: 'Whether PostgreSQL is up and accepting connections.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_up{%(queriesSelector)s}',
          },
        },
      },

      // How long since last restart? (stability indicator)
      uptime: {
        name: 'Uptime',
        description: 'Time since PostgreSQL server started.',
        type: 'gauge',
        unit: 's',
        sources: {
          postgres_exporter: {
            expr: 'time() - pg_postmaster_start_time_seconds{%(queriesSelector)s}',
          },
        },
      },

      // Am I running out of connections?
      connectionUtilization: {
        name: 'Connection utilization',
        description: 'Percentage of max_connections in use. Above 80% is warning, above 95% is critical.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              sum(pg_stat_activity_count{%(queriesSelector)s}) by (%(agg)s)
              / on(%(agg)s)
              pg_settings_max_connections{%(queriesSelector)s}
            |||,
          },
        },
      },

      // Is memory/cache working effectively?
      cacheHitRatio: {
        name: 'Cache hit ratio',
        description: 'Percentage of reads served from shared_buffers cache. Should be >95%.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (pg_stat_database_blks_hit{%(queriesSelector)s})
              /
              (
                sum by (%(agg)s) (pg_stat_database_blks_hit{%(queriesSelector)s})
                +
                sum by (%(agg)s) (pg_stat_database_blks_read{%(queriesSelector)s})
              )
            |||,
          },
        },
      },

      // Is replication healthy? (data durability)
      replicationLag: {
        name: 'Replication lag',
        description: 'Replication lag in seconds. High values indicate replica is behind.',
        type: 'gauge',
        unit: 's',
        aggFunction: 'max',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_lag_seconds{%(queriesSelector)s}',
          },
        },
      },

      // Are transactions fighting each other?
      deadlocks: {
        name: 'Deadlocks',
        description: 'Total deadlocks detected. Any deadlocks indicate contention problems.',
        type: 'counter',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_database_deadlocks{%(queriesSelector)s}',
          },
        },
      },

      // Is this a primary or replica?
      isReplica: {
        name: 'Node role',
        description: 'Whether this node is a replica (1) or primary (0).',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_is_replica{%(queriesSelector)s}',
          },
        },
      },

      // How many replicas are connected? (primary only)
      connectedReplicas: {
        name: 'Connected replicas',
        description: 'Number of replicas connected to this primary.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'count by (%(agg)s) (pg_stat_replication_backend_xmin{%(queriesSelector)s})',
          },
        },
      },

      // Replication slot lag (WAL bytes pending)
      replicationSlotLag: {
        name: 'Replication slot lag',
        description: 'WAL bytes not yet consumed by replication slots. High values indicate slow replicas or unused slots.',
        type: 'gauge',
        unit: 'bytes',
        aggFunction: 'max',
        sources: {
          postgres_exporter: {
            expr: 'pg_replication_slots_pg_wal_lsn_diff{%(queriesSelector)s}',
          },
        },
      },
    },
  }

