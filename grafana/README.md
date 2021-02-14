# Jsonnet Library for Deploying Grafana

This library aims to simplify the deployment of Grafana into Kubernetes
via Jsonnet.

As well as deploying Grafana itself, it also supports the deployment of
dashboards, datasources, notification channels and plugins, all from
within your Jsonnet code.

```
local grafana = import '../grafana.libsonnet';
local k = import 'k.libsonnet';
{
  config+:: {
    prometheus_url: 'http://prometheus',
  },

  namespace: k.core.v1.namespace.new('grafana'),

  prometheus_datasource:: grafana.datasource.new('prometheus', $.config.prometheus_url, type='prometheus', default=true),

  grafana: grafana
           + grafana.withAnonymous()
           + grafana.addFolder('Example')
           + grafana.addDashboard('simple', (import 'dashboard-simple.libsonnet'), folder='Example')
           + grafana.addDatasource('prometheus', $.prometheus_datasource),
}
```
