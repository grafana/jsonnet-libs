# prom-pushgateway jsonnet library

Jsonnet library for [Prometheus Pushgateway](https://github.com/prometheus/pushgateway). 

## Usage

Install it with jsonnet-bundler:

```console
jb install github.com/grafana/jsonnet-libs/prom-pushgateway
```

Import into your jsonnet:

```jsonnet
// environments/default/main.jsonnet
local pushgateway = import 'github.com/grafana/jsonnet-libs/prom-pushgateway/main.libsonnet';

{
  pushgateway: pushgateway.new(namespace='default'),
}
```
