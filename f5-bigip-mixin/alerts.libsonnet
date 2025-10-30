{
  new(this): {
    groups: [
      {
        name: this.config.uid + '-alerts',
        rules: [
          {
            alert: 'BigIPLowNodeAvailabilityStatus',
            expr: |||
              100 * (sum(bigip_node_status_availability_state) / clamp_min(count(bigip_node_status_availability_state), 1)) < %(alertsCriticalNodeAvailability)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Detecting a significant number of unavailable nodes which can causes potential downtime or degraded performance.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of available nodes, ' +
                  'which is below the threshold of %(alertsCriticalNodeAvailability)s.'
                ) % this.config,
            },
          },
          {
            alert: 'BigIPServerSideConnectionLimit',
            expr: |||
              max without(instance, job) (100 * bigip_node_serverside_cur_conns / clamp_min(bigip_node_serverside_max_conns, 1)) > %(alertsWarningServerSideConnectionLimit)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Approaching the connection limit may lead to rejecting new connections, impacting availability.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent of the max number of connections in use on node {{$labels.node}}, ' +
                  'which is above the threshold of %(alertsWarningServerSideConnectionLimit)s percent.'
                ) % this.config,
            },
          },
          {
            alert: 'BigIPHighRequestRate',
            expr: |||
              max without(instance, job) (100 * rate(bigip_pool_tot_requests[10m]) / clamp_min(rate(bigip_pool_tot_requests[50m] offset 10m), 1)) > %(alertsCriticalHighRequestRate)s
            ||| % this.config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'An unexpected spike in requests might indicate an issue like a DDoS attack or unexpected high load.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent increase in requests on pool {{$labels.pool}}, ' +
                  'which is above the threshold of %(alertsCriticalHighRequestRate)s.'
                ) % this.config,
            },
          },
          {
            alert: 'BigIPHighConnectionQueueDepth',
            expr: |||
              max without(instance, job) (100 * rate(bigip_pool_connq_depth[5m])) / clamp_min(rate(bigip_pool_connq_depth[50m] offset 10m), 1) > %(alertsCriticalHighConnectionQueueDepth)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A sudden spike or sustained high queue depth may indicate a bottleneck in handling incoming connections.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent increase in connection queue depth on node {{$labels.pool}}, ' +
                  'which is above the threshold of %(alertsCriticalHighConnectionQueueDepth)s.'
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
