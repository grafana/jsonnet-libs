{
  prometheus_alerts+:: {
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
            message: "Consul '{{ $labels.job }}' is not up.",
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
            message: "Consul '{{ $labels.job }}' has no master.",
          },
        },
        {
          alert: 'ConsulPeers',
          expr: |||
            consul_raft_peers != 3
          |||,
          'for': '10m',
          labels: {
            severity: 'critical',
          },
          annotations: {
            message: "Consul '{{ $labels.job }}' does not have 3 peers.",
          },
        },
      ],
    }],
  },
}
