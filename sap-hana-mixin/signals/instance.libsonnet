function(this) {
  local aggregationLabels = std.join(', ', this.groupLabels + this.instanceLabels),
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'instance',
  aggFunction: 'sum',
  signals: {
    cpuUsageByCore: {
      name: 'CPU usage',
      nameShort: 'CPU',
      type: 'raw',
      description: 'CPU usage percentage of the SAP HANA instance',
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
      description: 'Disk utilization percentage of the SAP HANA instance',
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
      description: 'Physical memory utilization percentage (resident) of the SAP HANA instance',
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
      description: 'Physical memory utilization percentage (swap) of the SAP HANA instance',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum by (' + aggregationLabels + ') (hanadb_host_memory_swap_used_mb{%(queriesSelector)s}) / clamp_min(sum by (' + aggregationLabels + ') (hanadb_host_memory_swap_used_mb{%(queriesSelector)s} + hanadb_host_memory_swap_free_mb{%(queriesSelector)s}), 1)',
          legendCustomTemplate: '{{host}} - swap',
        },
      },
    },

    schemaMemoryUsage: {
      name: 'Schema memory usage',
      nameShort: 'Schema memory',
      type: 'gauge',
      description: 'Total used memory by schema in the SAP HANA instance',
      unit: 'decmbytes',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', database_name, schema_name) (hanadb_schema_used_memory_mb{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - {{database_name}} - {{schema_name}}',
        },
      },
    },

    networkReceiveByInterface: {
      name: 'Network receive rate',
      nameShort: 'Receive',
      type: 'raw',
      description: 'Network I/O throughput for the SAP HANA instance',
      unit: 'KBs',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', interface) (hanadb_network_receive_rate_kb_per_seconds{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - {{interface}} - receive',
        },
      },
    },

    networkTransmitByInterface: {
      name: 'Network transmit rate',
      nameShort: 'Transmit',
      type: 'raw',
      description: 'Network I/O throughput for the SAP HANA instance',
      unit: 'KBs',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', interface) (hanadb_network_transmission_rate_kb_per_seconds{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - {{interface}} - transmit',
        },
      },
    },

    diskIOByDisk: {
      name: 'Disk I/O throughput',
      nameShort: 'Disk I/O',
      type: 'raw',
      description: 'Disk throughput for the SAP HANA instance',
      unit: 'KBs',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', disk) (hanadb_disk_io_throughput_kb_second{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - {{disk}}',
        },
      },
    },

    connectionsByStatus: {
      name: 'Connections',
      nameShort: 'Connections',
      type: 'raw',
      description: 'Number of connections grouped by type and status in the SAP HANA instance',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', connection_type, connection_status) (hanadb_connections_total_count{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - {{connection_type}} - {{connection_status}}',
        },
      },
    },

    alertsCount: {
      name: 'Alerts',
      nameShort: 'Alerts',
      type: 'raw',
      description: "Count of the SAP HANA instance's current alerts",
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
      description: 'SAP HANA current alerts in the SAP HANA instance',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'hanadb_alerts_current_rating{%(queriesSelector)s}',
          legendCustomTemplate: '{{host}}',
        },
      },
    },
  },
}
