# KLUMPS: Kubernetes/Linux USE Method with Prometheus

A set of [USE Method](http://www.brendangregg.com/usemethod.html) dashboards for
Grafana, using Prometheus as a backend.  Use these dashboards if you want insight
into the performance of your Kubernetes infrastructure.  For more motivation, see
"[The RED Method: How to instrument your services](https://kccncna17.sched.com/event/CU8K/the-red-method-how-to-instrument-your-services-b-tom-wilkie-kausal?iframe=no&w=100%&sidebar=yes&bg=no)" talk from CloudNativeCon Austin.

# Getting Started

First you'll need [jsonnet](http://jsonnet.org/) - on a Mac I recommend installing
it with `brew`.  Once you have `jsonnet` installed, the dashboards can
be generated with the following command:

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

Alternatively, if you use [ksonnet](https://ksonnet.io/) to generate your
Kubernetes config, the dashboards can be included in a config map directly:

```
local k = import "ksonnet.beta.2/k8s.libsonnet",
  dashboards = import "dashboards.jsonnet",
  configMap = k.core.v1.configMap;

configMap.new() +
configMap.mixin.metadata.name("dashboards") +
configMap.data({[name]: std.toString(dashboards[name])
  for name in std.objectFields(dashboards)})
```
