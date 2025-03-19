{
  multipleMastersAlert(namespace)::
    self.genericAlert(
      'RedisMultipleMasters',
      |||
        sum by (cluster, job, namespace) (redis_instance_info{namespace="%s", role="master"}) > 1
      ||| % [namespace],
      'There are {{ $value }} Redis pods with the "master" role in the {{ $labels.job }} job.',
    )
    .withSeverity('critical')
    .withEvaluationWindow('5m'),

  noMasterAlert(namespace)::
    self.genericAlert(
      'RedisNoMaster',
      |||
        sum by (cluster, namespace, job) (redis_instance_info{namespace="%s", role="master"}) < 1
      ||| % [namespace],
      'There are no Redis pods with the "master" role in the {{ $labels.job }} job.',
    )
    .withSeverity('critical')
    .withEvaluationWindow('5m'),

  slaveMasterLinkAlert(namespace, threshold=0)::
    self.genericAlert(
      'RedisMasterLinkDown',
      |||
        sum by (cluster, namespace, job) (redis_master_link_up{namespace="%s"}) <= %s
      ||| % [namespace, threshold],
      '{{ $value }} Redis pods have a successful connection with the master.',
    )
    .withSeverity('critical')
    .withEvaluationWindow('15m'),

  memoryUtilisationAlert(namespace, threshold=80)::
    self.genericAlert(
      'RedisHighMemoryUtilisation',
      |||
        100 * sum by (cluster, namespace, pod) (container_memory_working_set_bytes{namespace="%s", container="redis-server", image != ""})
        /
        sum by (cluster, namespace, pod) (kube_pod_container_resource_limits{namespace="%s", container="redis-server", resource="memory"}) > %s
      ||| % [namespace, namespace, threshold],
      'Redis pod "{{ $labels.pod }}" is using more than {{ printf "%.2f" $value }}% of its memory.',
    )
    .withSeverity('warning')
    .withEvaluationWindow('10m'),

  genericAlert(name, expr, message):: {
    withSeverity(severity):: self {
      labels+: {
        severity: severity,
      },
    },

    withEvaluationWindow(window):: self {
      'for': window,
    },

    alert: name,
    expr: expr,
    'for': '5m',
    labels: {
      severity: 'warning',
    },
    annotations: {
      message: message,
    },
  },
}
