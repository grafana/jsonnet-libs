{
  prometheusAlerts+:: {
    groups+: [{
      name: 'consul',
      rules: [
        {
          alert: 'ConsulUp',
          expr: |||
            consul_up != 1
          |||,
          'for': '1m',
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'Consul is not up.',
            description: "Consul '{{ $labels.job }}' is not up.",
          },
        },
        {
          alert: 'ConsulMaster',
          expr: |||
            consul_raft_leader != 1
          |||,
          'for': '1m',
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'Consul has no master.',
            description: "Consul '{{ $labels.job }}' has no master.",
          },
        },
        {
          alert: 'ConsulPeers',
          expr: |||
            consul_raft_peers != %(consul_replicas)s
          ||| % $._config,
          'for': '10m',
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'Consul does not have peers.' % $._config,
            description: "Consul '{{ $labels.job }}' does not have %(consul_replicas)s peers." % $._config,
          },
        },
      ],
    }],
  },
}
