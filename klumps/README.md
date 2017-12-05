# KLUMPS: Kubernetes/Linux USE Method with Prometheus

A set of [USE Method]() dashboards for Grafana, using Prometheus as a backend.

First you'll need [jsonnet]().  Once you have installed that, the dashboards can
be installed with the following command:

```
$ jsonnet -m . to_json_files.jsonnet
```

The dashboards depend on a set of Prometheus recording rules, which can be
generated with the following command:

```
$ jsonnet recording_rules.jsonnet >recording_rules.yaml
```

This generates JSON, but luckily JSON is a subset of YAML so Prometheus can use
this file.

## Ksonnet

Alternatively, if you use [ksonnet] to generate your Kubernetes config, the
dashboards can be included in a config map directly:

```
local k = import "ksonnet.beta.2/k8s.libsonnet",
  dashboards = import "dashboards.jsonnet",
  configMap = k.core.v1.configMap;

configMap.new() +
configMap.mixin.metadata.name("dashboards") +
configMap.data({[name]: std.toString(dashboards[name])
  for name in std.objectFields(dashboards)})
```
