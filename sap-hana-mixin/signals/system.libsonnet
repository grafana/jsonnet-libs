function(this) {
  local aggregationLabels = std.join(', ', this.groupLabels + this.instanceLabels),
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'sum',
  signals: {

    replicaStatus: {
      name: 'Replica status',
      nameShort: 'Status',
      type: 'gauge',
      description: 'State of the replicas in the SAP HANA system',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'hanadb_sr_replication{%(queriesSelector)s}',
          legendCustomTemplate: '{{secondary_site_name}}',
        },
      },
    },

    replicationShipDelay: {
      name: 'Average replication ship delay',
      nameShort: 'Ship delay',
      type: 'gauge',
      description: 'Average system replication log shipping delay in the SAP HANA system',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'avg by (' + aggregationLabels + ', secondary_site_name) (hanadb_sr_ship_delay{%(queriesSelector)s})',
          legendCustomTemplate: '{{secondary_site_name}}',
        },
      },
    },

    cpuUsage: {
      name: 'CPU usage',
      nameShort: 'CPU',
      type: 'raw',
      description: 'CPU usage percentage of the SAP HANA system',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', core) (hanadb_cpu_busy_percent{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - core {{core}}',
        },
      },
    },

    diskUsage: {
      name: 'Disk usage',
      nameShort: 'Disk',
      type: 'raw',
      description: 'Disk utilization percentage of the SAP HANA system',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum by (' + aggregationLabels + ') (hanadb_disk_total_used_size_mb{%(queriesSelector)s}) / sum by (' + aggregationLabels + ') (hanadb_disk_total_size_mb{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}}',
        },
      },
    },

    physicalMemoryUsageResident: {
      name: 'Physical memory usage - resident',
      nameShort: 'Resident',
      type: 'raw',
      description: 'Physical memory utilization percentage (resident) of the SAP HANA system',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum by (' + aggregationLabels + ') (hanadb_host_memory_resident_mb{%(queriesSelector)s}) / sum by (' + aggregationLabels + ') (hanadb_host_memory_physical_total_mb{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - resident',
        },
      },
    },

    physicalMemoryUsageSwap: {
      name: 'Physical memory usage - swap',
      nameShort: 'Swap',
      type: 'raw',
      description: 'Physical memory utilization percentage (swap) of the SAP HANA system',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum by (' + aggregationLabels + ') (hanadb_host_memory_swap_used_mb{%(queriesSelector)s}) / clamp_min(sum by (' + aggregationLabels + ') (hanadb_host_memory_swap_used_mb{%(queriesSelector)s} + hanadb_host_memory_swap_free_mb{%(queriesSelector)s}), 1)',
          legendCustomTemplate: '{{host}} - swap',
        },
      },
    },

    hanaMemoryUsage: {
      name: 'SAP HANA memory usage',
      nameShort: 'HANA memory',
      type: 'raw',
      description: 'Total amount of used memory by processes in the SAP HANA system',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum by (' + aggregationLabels + ') (hanadb_host_memory_used_total_mb{%(queriesSelector)s}) / sum by (' + aggregationLabels + ') (hanadb_host_memory_alloc_limit_mb{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}}',
        },
      },
    },

    networkReceiveRate: {
      name: 'Network receive rate',
      nameShort: 'Receive',
      type: 'raw',
      description: 'Network receive throughput in the SAP HANA system',
      unit: 'KBs',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ') (hanadb_network_receive_rate_kb_per_seconds{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - receive',
        },
      },
    },

    networkTransmitRate: {
      name: 'Network transmit rate',
      nameShort: 'Transmit',
      type: 'raw',
      description: 'Network transmit throughput in the SAP HANA system',
      unit: 'KBs',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', interface) (hanadb_network_transmission_rate_kb_per_seconds{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - transmit',
        },
      },
    },

    diskIOThroughput: {
      name: 'Disk I/O throughput',
      nameShort: 'Disk I/O',
      type: 'raw',
      description: 'Disk throughput for the SAP HANA system',
      unit: 'KBs',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ') (hanadb_disk_io_throughput_kb_second{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}}',
        },
      },
    },

    activeConnections: {
      name: 'Active connections',
      nameShort: 'Active',
      type: 'raw',
      description: 'Number of connections in active states across the SAP HANA system',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ') (hanadb_connections_total_count{%(queriesSelector)s, connection_status=~"RUNNING|QUEUING"})',
          legendCustomTemplate: '{{host}}',
        },
      },
    },

    idleConnections: {
      name: 'Idle connections',
      nameShort: 'Idle',
      type: 'raw',
      description: 'Number of connections in the idle state across the SAP HANA system',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ') (hanadb_connections_total_count{%(queriesSelector)s, connection_status=~"IDLE"})',
          legendCustomTemplate: '{{host}}',
        },
      },
    },

    alertsCount: {
      name: 'Alerts',
      nameShort: 'Alerts',
      type: 'raw',
      description: 'Count of the SAP HANA current alerts in the SAP HANA system',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ') (hanadb_alerts_current_rating{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}}',
        },
      },
    },

    recentAlerts: {
      name: 'Recent alerts',
      nameShort: 'Recent alerts',
      type: 'raw',
      description: 'SAP HANA current alerts in the SAP HANA system',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'hanadb_alerts_current_rating{%(queriesSelector)s}',
          legendCustomTemplate: '{{host}}',
        },
      },
    },

    avgQueryExecutionTime: {
      name: 'Average query execution time',
      nameShort: 'Query time',
      type: 'raw',
      description: 'Average elapsed time per execution across the SAP HANA system',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'avg by (' + aggregationLabels + ', service, sql_type) (hanadb_sql_service_elap_per_exec_avg_ms{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - service: {{service}} - type: {{sql_type}}',
        },
      },
    },
  },
}
