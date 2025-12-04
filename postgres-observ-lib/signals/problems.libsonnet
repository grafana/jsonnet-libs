// Tier 2: Active Problems Signals
// DBA Question: "What needs immediate attention?"
// These signals trigger alerts and indicate current issues

local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      postgres_exporter: 'pg_stat_activity_count',
    },
    signals: {
      // Is something stuck?
      longRunningQueries: {
        name: 'Long-running queries',
        description: 'Number of queries running longer than 5 minutes.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: |||
              count(pg_stat_activity_max_tx_duration{%(queriesSelector)s, state="active"} > 300) by (%(agg)s)
              or vector(0)
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Long-running queries',
          },
        },
      },

      // Are locks causing waits?
      blockedQueries: {
        name: 'Blocked queries',
        description: 'Number of queries waiting for locks. Should be 0.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: |||
              sum(pg_locks_count{%(queriesSelector)s, mode="ExclusiveLock"}) by (%(agg)s)
              or vector(0)
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Blocked queries',
          },
        },
      },

      // Are connections holding locks without doing work?
      idleInTransaction: {
        name: 'Idle in transaction',
        description: 'Connections idle in transaction state. Can hold locks and block others.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_activity_count{%(queriesSelector)s, state="idle in transaction"}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Idle in transaction',
          },
        },
      },

      // Are backups at risk?
      walArchiveFailures: {
        name: 'WAL archive failures',
        description: 'Failed WAL archive attempts. Non-zero means backups may be incomplete.',
        type: 'counter',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_archiver_failed_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: WAL archive failures',
          },
        },
      },

      // Is checkpoint I/O overloaded?
      checkpointWarnings: {
        name: 'Checkpoint warnings',
        description: 'Requested checkpoints vs timed. High requested count indicates checkpoint_completion_target needs tuning.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: |||
              rate(pg_stat_bgwriter_checkpoints_req{%(queriesSelector)s}[$__rate_interval])
              /
              (
                rate(pg_stat_bgwriter_checkpoints_req{%(queriesSelector)s}[$__rate_interval])
                +
                rate(pg_stat_bgwriter_checkpoints_timed{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Checkpoint warnings',
          },
        },
      },

      // Backend buffer writes (should be low)
      backendWrites: {
        name: 'Backend buffer writes',
        description: 'Buffers written by backends (not bgwriter). High values indicate bgwriter cannot keep up.',
        type: 'counter',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_bgwriter_buffers_backend{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Backend buffer writes',
          },
        },
      },

      // ============================================
      // Additional signals from upstream postgres_mixin
      // ============================================

      // Database conflicts (replica only)
      conflicts: {
        name: 'Conflicts',
        description: 'Number of queries cancelled due to conflicts with recovery on standby servers.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_database_conflicts{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Conflicts',
          },
        },
      },

      // Lock utilization
      lockUtilization: {
        name: 'Lock utilization',
        description: 'Percentage of max locks in use. Above 20% is warning.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              max by (%(agg)s) (
                pg_locks_count{%(queriesSelector)s}
              )
              /
              on(%(agg)s) (
                pg_settings_max_locks_per_transaction{%(queriesSelector)s}
                *
                pg_settings_max_connections{%(queriesSelector)s}
              )
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Lock utilization',
          },
        },
      },

      // Inactive replication slots
      inactiveReplicationSlots: {
        name: 'Inactive replication slots',
        description: 'Number of inactive replication slots. Can cause WAL to accumulate.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: |||
              count by (%(agg)s) (pg_replication_slots_active{%(queriesSelector)s} == 0)
              or vector(0)
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Inactive replication slots',
          },
        },
      },

      // Exporter errors
      exporterErrors: {
        name: 'Exporter errors',
        description: 'Whether the PostgreSQL exporter had errors during last scrape.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_exporter_last_scrape_error{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Exporter errors',
          },
        },
      },
    },
  }

