{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'apache-hadoop',
        rules: [
          {
            alert: 'ApacheHadoopLowHDFSCapacity',
            expr: |||
              min without(job, name) (100 * hadoop_namenode_capacityremaining / clamp_min(hadoop_namenode_capacitytotal, 1)) < %(alertsWarningHDFSCapacity)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Remaining HDFS cluster capacity is low which may result in DataNode failures or prevent DataNodes from writing data.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent remaining HDFS usage on {{$labels.hadoop_cluster}} - {{$labels.instance}}, ' +
                  'which is below the threshold of %(alertsWarningHDFSCapacity)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheHadoopHDFSMissingBlocks',
            expr: |||
              max without(job, name) (hadoop_namenode_missingblocks) > %(alertsCriticalHDFSMissingBlocks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are missing blocks in the HDFS cluster which may indicate potential data loss.',
              description:
                (
                  '{{ printf "%%.0f" $value }} HDFS missing blocks on {{$labels.hadoop_cluster}} - {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalHDFSMissingBlocks)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheHadoopHDFSHighVolumeFailures',
            expr: |||
              max without(job, name) (hadoop_namenode_volumefailurestotal) > %(alertsCriticalHDFSVolumeFailures)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A volume failure in HDFS cluster may indicate hardware failures.',
              description:
                (
                  '{{ printf "%%.0f" $value }} HDFS volume failures on {{$labels.hadoop_cluster}} - {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalHDFSVolumeFailures)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheHadoopHighDeadDataNodes',
            expr: |||
              max without(job, name) (hadoop_namenode_numdeaddatanodes) > %(alertsCriticalDeadDataNodes)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Number of dead DataNodes has increased, which could result in data loss and increased network activity.',
              description:
                (
                  '{{ printf "%%.0f" $value }} dead HDFS volume failures on {{$labels.hadoop_cluster}} - {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalDeadDataNodes)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheHadoopHighNodeManagerCPUUsage',
            expr: |||
              max without(job, name) (100 * hadoop_nodemanager_nodecpuutilization) > %(alertsCriticalNodeManagerCPUUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A NodeManager has a CPU usage higher than the configured threshold.',
              description:
                (
                  '{{ printf "%%.0f" $value }} CPU usage on {{$labels.hadoop_cluster}} - {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalNodeManagerCPUUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheHadoopHighNodeManagerMemoryUsage',
            expr: |||
              max without(job, name) (100 * hadoop_nodemanager_allocatedgb / clamp_min(hadoop_nodemanager_availablegb + hadoop_nodemanager_allocatedgb,1)) > %(alertsCriticalNodeManagerMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A NodeManager has a higher memory utilization than the configured threshold.',
              description:
                (
                  '{{ printf "%%.0f" $value}} percent NodeManager memory usage on {{$labels.hadoop_cluster}} - {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalNodeManagerMemoryUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheHadoopHighResourceManagerVirtualCoreCPUUsage',
            expr: |||
              max without(job, name) (100 * hadoop_resourcemanager_allocatedvcores / clamp_min(hadoop_resourcemanager_availablevcores + hadoop_resourcemanager_allocatedvcores,1)) > %(alertsCriticalResourceManagerVCoreCPUUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A ResourceManager has a virtual core CPU usage higher than the configured threshold.',
              description:
                (
                  '{{ printf "%%.0f" $value }} virtual core CPU usage on {{$labels.hadoop_cluster}} - {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalResourceManagerVCoreCPUUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheHadoopHighResourceManagerMemoryUsage',
            expr: |||
              max without(job, name) (100 * hadoop_resourcemanager_allocatedmb / clamp_min(hadoop_resourcemanager_availablemb + hadoop_resourcemanager_allocatedmb,1)) > %(alertsCriticalResourceManagerMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A ResourceManager has a higher memory utilization than the configured threshold.',
              description:
                (
                  '{{ printf "%%.0f" $value}} percent ResourceManager memory usage on {{$labels.hadoop_cluster}} - {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalResourceManagerMemoryUsage)s.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
