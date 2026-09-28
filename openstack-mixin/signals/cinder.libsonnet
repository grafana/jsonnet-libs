function(this) {
  // Left empty so panel queries are driven by the $job/$instance variables alone.
  // The static filteringSelector still constrains the dashboard variable queries.
  filteringSelector: '',
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'openstack_cinder_up',
  },
  signals: {
    cinder_up: {
      name: 'Cinder status',
      description: 'Reports the status of the Cinder block storage service.',
      type: 'gauge',
      unit: 'string',
      sources: {
        prometheus: {
          expr: 'openstack_cinder_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    cinder_volumes: {
      name: 'Volumes',
      description: 'The number of volumes managed by Cinder.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_cinder_volumes{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    cinder_snapshots: {
      name: 'Snapshots',
      description: 'The number of volume snapshots in Cinder.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_cinder_snapshots{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    cinder_volume_error_status: {
      name: 'Volume error status',
      description: 'Count of Cinder volumes in error states.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_cinder_volume_status_counter{%(queriesSelector)s, status=~"error|error_backing-up|error_deleting|error_extending|error_restoring"}',
          exprWrappers: [['', ' > 0']],
          legendCustomTemplate: '{{instance}} - {{status}}',
        },
      },
    },
    cinder_volume_top_statuses: {
      name: 'Top volume statuses',
      description: 'Top 5 non-error volume statuses in Cinder.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_cinder_volume_status_counter{%(queriesSelector)s, status!~"error|error_backing-up|error_deleting|error_extending|error_restoring"}',
          exprWrappers: [['topk(5, ', ') > 0']],
          legendCustomTemplate: '{{instance}} - {{status}}',
        },
      },
    },
    cinder_volume_usage: {
      name: 'Volume usage',
      description: 'The percent of volume storage in use for Cinder.',
      type: 'raw',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'openstack_cinder_limits_volume_used_gb{%(queriesSelector)s} / clamp_min(openstack_cinder_limits_volume_max_gb{%(queriesSelector)s}, 1)',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
    cinder_backup_usage: {
      name: 'Backup usage',
      description: 'The percent of backup storage in use for Cinder.',
      type: 'raw',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'openstack_cinder_limits_backup_used_gb{%(queriesSelector)s} / clamp_min(openstack_cinder_limits_backup_max_gb{%(queriesSelector)s}, 1)',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
    cinder_pool_usage: {
      name: 'Pool usage',
      description: 'The percent of pool capacity in use for Cinder.',
      type: 'raw',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: '(openstack_cinder_pool_capacity_total_gb{%(queriesSelector)s} - openstack_cinder_pool_capacity_free_gb{%(queriesSelector)s}) / clamp_min(openstack_cinder_pool_capacity_total_gb{%(queriesSelector)s}, 1)',
          legendCustomTemplate: '{{instance}} - {{name}}',
        },
      },
    },
    cinder_agent_state: {
      name: 'Cinder agent state',
      description: 'The state of Cinder storage agents.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_cinder_agent_state{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{service}} - {{hostname}}',
        },
      },
    },
  },
}
