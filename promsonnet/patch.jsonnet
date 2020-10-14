local example = import 'example.jsonnet';

example {
  prometheusAlerts+: {
    groups_map+:: {
      prometheus_down+:: {
        rules_map+:: {
          PrometheusDown+:: {
            'for': '10m',
          },
        },
      },
    },
  },
}
