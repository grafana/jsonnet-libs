function(this)
  local legendCustomTemplate = '{{mesos_cluster}}';
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
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
          },
        },
      },

      memoryUtilization: {
        name: 'Memory utilization',
        nameShort: 'Memory utilization',
        type: 'raw',
        description: 'Memory utilization in the cluster',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_mem{%(queriesSelector)s, type="percent"})',
          },
        },
      },

      diskUtilization: {
        name: 'Disk utilization',
        nameShort: 'Disk utilization',
        type: 'raw',
        description: 'Disk utilization in the cluster',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'max by(mesos_cluster) (mesos_master_disk{%(queriesSelector)s, type="percent"})',
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
            legendCustomTemplate: legendCustomTemplate + ' - {{type}}',
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
            legendCustomTemplate: legendCustomTemplate + ' - {{type}}',
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
            legendCustomTemplate: legendCustomTemplate + ' - store',
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
            legendCustomTemplate: legendCustomTemplate + ' - fetch',
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
          },
        },
      },
    },
  }
