{
  new(this): {

    groups: [
      {
        name: this.config.uid,
        rules: [
          {
            alert: 'vSphereHostInfoCPUUtilization',
            expr: |||
              vcenter_host_cpu_utilization_percent{%(filteringSelector)s}} > %(alertsHighCPUUtilization)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'info',
            },
            annotations: {
              summary: 'CPU is approaching a high threshold of utilization for an ESXi host. High CPU utilization may lead to performance degradation and potential downtime. ',
              description: |||
                The CPU utilization of the host system {{ $labels.vcenter_host_name }} is now above %(alertsHighCPUUtilization)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'vSphereHostWarningMemoryUtilization',
            expr: |||
              vcenter_host_memory_utilization_percent{%(filteringSelector)s}} > %(alertsHighMemoryUtilization)s
            ||| % this.config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Memory is approaching a high threshold of utilization for an ESXi host. High memory utilization may cause the host to become unresponsive and impact the performance of virtual machines.',
              description: |||
                The memory utilization of the host system {{ $labels.vcenter_host_name }} is now above %(alertsHighMemoryUtilization)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'vSphereDatastoreWarningDiskUtilization',
            expr: |||
              vcenter_datastore_disk_utilization_percent{%(filteringSelector)s}} > %(alertsWarningDiskUtilization)s
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
            alert: 'vSphereDatastoreCriticalDiskUtilization',
            expr: |||
              vcenter_datastore_disk_utilization_percent{%(filteringSelector)s}} > %(alertsCriticalDiskUtilization)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Disk space is approaching a critical threshold of utilization for a datastore. Critically low disk space may cause virtual machines to crash and result in significant data loss.',
              description: |||
                The disk utilization of the datastore {{ $labels.vcenter_datastore_name }} is now above %(alertsCriticalDiskUtilization)s%%. The current value is {{ $value | printf "%%.2f" }}%%.
              ||| % this.config,
            },
          },
          {
            alert: 'vSphereHostWarningHighPacketErrors',
            expr: |||
              100 * sum without (job, direction, object) (vcenter_host_network_packet_errors{%(filteringSelector)s}}) / sum without (job, direction, object) (vcenter_host_network_packet_count{%(filteringSelector)s}}) > %(alertsHighPacketErrors)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High percentage of packet errors seen for ESXi host. High packet errors may indicate network issues that can lead to poor performance and connectivity problems for virtual machines.',
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
