{
  new(this): {

    groups: [
      {
        name: this.config.uid,
        rules: [
          {
            alert: 'VSphereHostInfoCpuUtilization',
            expr: |||
              vcenter_host_cpu_utilization_percent{%(filteringSelector)s} > %(alertsHighCPUUtilization)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'info',
            },
            annotations: {
              summary: 'CPU is approaching a high threshold of utilization for an ESXi host. High CPU utilization may lead to performance degradation and potential downtime for virtual machines running on a host.',
              description: |||
                The CPU utilization of the host system {{ $labels.vcenter_host_name }} is now above %(alertsHighCPUUtilization)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'VSphereHostWarningMemoryUtilization',
            expr: |||
              vcenter_host_memory_utilization_percent{%(filteringSelector)s} > %(alertsHighMemoryUtilization)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Memory is approaching a high threshold of utilization for an ESXi host. High memory utilization may cause the host to become unresponsive and impact the performance of virtual machines running on this host.',
              description: |||
                The memory utilization of the host system {{ $labels.vcenter_host_name }} is now above %(alertsHighMemoryUtilization)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'VSphereDatastoreWarningDiskUtilization',
            expr: |||
              vcenter_datastore_disk_utilization_percent{%(filteringSelector)s} > %(alertsWarningDiskUtilization)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Disk space is approaching a warning threshold of utilization for a datastore. Low disk space may prevent virtual machines from functioning properly and cause data loss.',
              description: |||
                The disk utilization of the datastore {{ $labels.vcenter_datastore_name }} is now above %(alertsWarningDiskUtilization)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'VSphereDatastoreCriticalDiskUtilization',
            expr: |||
              vcenter_datastore_disk_utilization_percent{%(filteringSelector)s} > %(alertsCriticalDiskUtilization)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Disk space is approaching a critical threshold of utilization for a datastore. Low disk space may prevent virtual machines from functioning properly and cause data loss.',
              description: |||
                The disk utilization of the datastore {{ $labels.vcenter_datastore_name }} is now above %(alertsCriticalDiskUtilization)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'VSphereHostWarningHighPacketErrors',
            expr: |||
              100 * sum without (direction, object) (vcenter_host_network_packet_error_rate{object="",%(filteringSelector)s}) / clamp_min(sum without (direction, object) (vcenter_host_network_packet_rate{object="",%(filteringSelector)s}), 1) > %(alertsHighPacketErrors)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High percentage of packet errors seen for ESXi host. High packet errors may indicate network issues that can lead to poor performance and connectivity problems for virtual machines running on this host.',
              description: |||
                The percentage of packet errors on the ESXi host {{ $labels.vcenter_host_name }} is now above %(alertsHighPacketErrors)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
        ],
      },
    ],
  },
}
