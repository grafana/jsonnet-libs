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
      prometheus: 'mesos_master_uptime_seconds',
    },

    signals: {
      masterUptime: {
        name: 'Master uptime',
        nameShort: 'Master uptime',
        type: 'raw',
        description: 'Master uptime in seconds',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_uptime_seconds{%(queriesSelector)s})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      cpusAvailable: {
        name: 'CPUs available',
        nameShort: 'CPUs',
        type: 'raw',
        description: 'CPUs available in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_cpus{%(queriesSelector)s, type="total"})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },
      memoryAvailable: {
        name: 'Memory available',
        nameShort: 'Memory',
        type: 'raw',
        description: 'Memory available in the cluster',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_mem{%(queriesSelector)s, type="total"})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      gpusAvailable: {
        name: 'GPUs available',
        nameShort: 'GPUs',
        type: 'raw',
        description: 'GPUs available in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_gpus{%(queriesSelector)s, type="total"})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      diskAvailable: {
        name: 'Disk available',
        nameShort: 'Disk',
        type: 'raw',
        description: 'Disk available in the cluster',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_disk{%(queriesSelector)s, type="total"})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      memoryUtilization: {
        name: 'Memory utilization',
        nameShort: 'Memory %',
        type: 'raw',
        description: 'Memory utilization in the cluster',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_mem{%(queriesSelector)s, type="percent"})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      diskUtilization: {
        name: 'Disk utilization',
        nameShort: 'Disk %',
        type: 'raw',
        description: 'Disk utilization in the cluster',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_disk{%(queriesSelector)s, type="percent"})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      eventsInQueue: {
        name: 'Events in queue',
        nameShort: 'Events',
        type: 'raw',
        description: 'Events in queue in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster, type) (mesos_master_event_queue_length{%(queriesSelector)s})',
            legendCustomTemplate: '{{mesos_cluster}} - {{type}}',
          },
        },
      },

      messages: {
        name: 'Messages',
        nameShort: 'Messages',
        type: 'raw',
        description: 'Messages in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster, type) (increase(mesos_master_messages{%(queriesSelector)s}[$__interval:] offset $__interval)) > 0',
            legendCustomTemplate: '{{mesos_cluster}} - {{type}}',
          },
        },
      },

      registrarStateStore: {
        name: 'Registrar state store',
        nameShort: 'Registrar state store',
        type: 'raw',
        description: 'Registrar state store in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_registrar_state_store_ms{%(queriesSelector)s, type="mean"})',
            legendCustomTemplate: '{{mesos_cluster}} - store',
          },
        },
      },

      registrarStateFetch: {
        name: 'Registrar state fetch',
        nameShort: 'Registrar state fetch',
        type: 'raw',
        description: 'Registrar state fetch in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_registrar_state_fetch_ms{%(queriesSelector)s})',
            legendCustomTemplate: '{{mesos_cluster}} - fetch',
          },
        },
      },

      registrarLogRecovered: {
        name: 'Registrar log recovered',
        nameShort: 'Registrar log recovered',
        type: 'raw',
        description: 'Registrar log recovered in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_registrar_log_recovered{%(queriesSelector)s})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      allocationRuns: {
        name: 'Allocation runs',
        nameShort: 'Allocation runs',
        type: 'raw',
        description: 'Allocation runs in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (increase(mesos_master_allocation_run_ms_count{%(queriesSelector)s}[$__interval] offset $__interval))',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      allocationDuration: {
        name: 'Allocation duration',
        nameShort: 'Allocation duration',
        type: 'raw',
        description: 'Allocation duration in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_allocation_run_ms{%(queriesSelector)s})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      allocationLatency: {
        name: 'Allocation latency',
        nameShort: 'Allocation latency',
        type: 'raw',
        description: 'Allocation latency in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_allocation_run_latency_ms{%(queriesSelector)s})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },

      eventQueueDispatches: {
        name: 'Event queue dispatches',
        nameShort: 'Event queue dispatches',
        type: 'raw',
        description: 'Event queue dispatches in the cluster',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_event_queue_dispatches{%(queriesSelector)s})',
            legendCustomTemplate: '{{mesos_cluster}}',
          },
        },
      },
    },
  }
