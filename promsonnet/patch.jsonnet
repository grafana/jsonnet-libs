local example = import 'example.jsonnet';
local prom = import 'prom.libsonnet';

example {
  prometheusAlerts+: prom.v1.patchRule('prometheus_metamon', 'PrometheusDown', { 'for': '10m' })
                     + prom.v1.patchGroup('prometheus_metamon', { annotations+: { automated: 'true' } })
                     + prom.v1.patchAll({ labels+: { severity: 'critical' } }),

}
