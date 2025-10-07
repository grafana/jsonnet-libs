function(this)
  {

    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)) + ' - {{mesos_cluster}}',
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'mesos_slave_mem_used_bytes',
    },
    signals: {
      memoryUtilization: {
        name: 'Memory utilization',
        nameShort: 'Memory %',
        type: 'raw',
        description: 'Memory utilization in the cluster',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (100 * mesos_slave_mem_used_bytes{%(queriesSelector)s} / clamp_min(mesos_slave_mem_bytes{%(queriesSelector)s},1))',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      diskUtilization: {
        name: 'Disk utilization',
        nameShort: 'Disk %',
        type: 'raw',
        description: 'The percentage of allocated disk storage in use by the agent.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (100 * mesos_slave_disk_used_bytes{%(queriesSelector)s} / clamp_min(mesos_slave_disk_bytes{%(queriesSelector)s},1))',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },
    },
  }
