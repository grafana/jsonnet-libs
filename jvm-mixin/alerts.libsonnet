{
  prometheusAlerts+:: {
    groups+: [{
      name: 'jvm',
      rules: [
        {
          alert: 'JvmMemoryFillingUp',
          expr: |||
            jvm_memory_used_bytes / jvm_memory_max_bytes{area="heap"} > 0.8
          |||,
          'for': '5m',
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: 'JVM memory filling up.',
            description: 'JVM memory usage is at {{ printf "%%.0f" $value }} percent over the last 5 minutes on {{$labels.instance}}, which is above the threshold of 80%.',
          },
        },
      ],
    }],
  },
}
