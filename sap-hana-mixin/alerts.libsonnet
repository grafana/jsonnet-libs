{
  new(this): {
    groups: [
      {
        name: this.config.uid + '-alerts',
        rules: [
          {
            alert: 'SapHanaHighCpuUtilization',
            expr: |||
              sum without (database_name) (hanadb_cpu_busy_percent) > %(alertsCriticalHighCpuUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'CPU utilization is high.',
              description:
                (
                  'The CPU usage is at {{$value}}%% on {{$labels.core}} on {{$labels.host}} which is above the threshold of %(alertsCriticalHighCpuUsage)s%%.'
                ) % this.config,
            },
          },
          {
            alert: 'SapHanaHighPhysicalMemory',
            expr: |||
              100 * sum without (database_name)(hanadb_host_memory_resident_mb) / sum without (database_name) (hanadb_host_memory_physical_total_mb) > %(alertsCriticalHighPhysicalMemoryUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Current physical memory usage of the host is approaching capacity.',
              description:
                (
                  'The physical memory usage is at {{$value}}%% on {{$labels.host}} which is above the threshold of %(alertsCriticalHighPhysicalMemoryUsage)s%%.'
                ) % this.config,
            },
          },
          {
            alert: 'SapHanaMemAllocBelowLimit',
            expr: |||
              100 * sum without (database_name) (hanadb_host_memory_alloc_limit_mb) / sum without (database_name) (hanadb_host_memory_physical_total_mb) < %(alertsWarningLowMemAllocLimit)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Memory allocation limit set below recommended limit.',
              description:
                (
                  'The memory allocation limit is set at {{$value}}%% on {{$labels.host}} which is below the recommended value of %(alertsWarningLowMemAllocLimit)s%%.'
                ) % this.config,
            },
          },
          {
            alert: 'SapHanaHighMemoryUsage',
            expr: |||
              100 * sum without (database_name) (hanadb_host_memory_used_total_mb) / sum without (database_name) (hanadb_host_memory_alloc_limit_mb) > %(alertsCriticalHighMemoryUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Current SAP HANA memory usage is approaching capacity.',
              description:
                (
                  'The memory usage is at {{$value}}%% on {{$labels.host}} which is above the threshold of %(alertsCriticalHighMemoryUsage)s%%.'
                ) % this.config,
            },
          },
          {
            alert: 'SapHanaHighDiskUtilization',
            expr: |||
              100 * sum without (database_name, filesystem_type, path, usage_type) (hanadb_disk_total_used_size_mb) / sum without (database_name, filesystem_type, path, usage_type) (hanadb_disk_total_size_mb) > %(alertsCriticalHighDiskUtilization)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'SAP HANA disk is approaching capacity.',
              description:
                (
                  'The disk usage is at {{$value}}%% on {{$labels.host}} which is above the threshold of %(alertsCriticalHighDiskUtilization)s%%.'
                ) % this.config,
            },
          },
          {
            alert: 'SapHanaHighSqlExecutionTime',
            expr: |||
              avg without (database_name, port, service, sql_type) (hanadb_sql_service_elap_per_exec_avg_ms) / 1000 > %(alertsCriticalHighSqlExecutionTime)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'SAP HANA SQL average execution time is high.',
              description:
                (
                  'The average SQL execution time is at {{$value}}s on {{$labels.host}} which is above the threshold of %(alertsCriticalHighSqlExecutionTime)ss.'
                ) % this.config,
            },
          },
          {
            alert: 'SapHanaHighReplicationDelay',
            expr: |||
              avg without (database_name, port, secondary_port, replication_mode) (hanadb_sr_ship_delay) > %(alertsCriticalHighReplicationShippingTime)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'SAP HANA system replication log shipping delay is high.',
              description:
                (
                  'The average system replication log shipping delay is at {{$value}}s from primary site {{$labels.site_name}} to replica site {{$labels.secondary_site_name}} which is above the threshold of %(alertsCriticalHighReplicationShippingTime)ss.'
                ) % this.config,
            },
          },
          {
            alert: 'SapHanaReplicationError',
            expr: |||
              hanadb_sr_replication == 4
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'SAP HANA system replication status signifies an error.',
              description:
                (
                  'The replication status of replica {{$labels.secondary_site_name}} is ERROR'
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
