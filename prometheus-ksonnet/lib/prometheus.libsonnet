local prometheus = import 'prometheus/prometheus.libsonnet';

{
  /*
   * All Prometheus resources are contained within a `prometheus` node. This allows
     multiple Prometheus instances to be created by simply cloning this node, like
     so:
     `other_prometheus: $.prometheus {name: "other-prometheus"},`

     To remove the default Prometheus, use this code:
     `main_prometheus: {},`
  */

  prometheus:: prometheus {
    name:: error 'must specify name',
    local name = self.name,

    _config+:: $._config { name: name },
    mixins+:: $.mixins,
    prometheus_config+:: $.prometheus_config,

  },

  main_prometheus: $.prometheus { name: 'prometheus' },
}
