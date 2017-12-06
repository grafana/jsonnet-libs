# Promtail

**What?** A logging agent that uses Prometheus' service discovery.

**Why?** Using Prometheus' service discovery allows us to attach the same
labels metadata to your log streams as you metric timeseries.  This improves
consistency when switching between metrics and logs and allows you to combine
both sources in the same query.

**How?** Promtail use Prometheus' service discovery and relabelling to emit a list
of targets; Promtail uses the `__path__` label value to search for matching files,
tails them and sends them to remote server.

## Example Kubernetes Setup

Promtail is designed to be run as a DaemonSet:

```
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: promtail
  namespace: default
spec:
  template:
    metadata:
      labels:
        name: promtail
    spec:
      containers:
      - args:
        - -config.file=/etc/promtail/promtail.yml
        - -client.url=https://...
        image: kausal/promtail:master-503b52a
        name: promtail
        ports:
        - containerPort: 80
          name: http
        volumeMounts:
...
```

With this example configuration:

```
scrape_config:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod

    relabel_configs:
    # Only scrape local pods; Promtail will drop targets with a __host__ label
    # that does not match the current host name.
    - source_labels: [__meta_kubernetes_pod_node_name]
      target_label: __host__

    # Drop pods without a name label
    - source_labels: [__meta_kubernetes_pod_label_name]
      action: drop
      regex: ^$

    # Rename jobs to be <namespace>/<name>, from pod name label
    - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_pod_label_name]
      action: replace
      separator: /
      target_label: job
      replacement: $1

    # Rename instances to be the pod name
    - source_labels: [__meta_kubernetes_pod_name]
      action: replace
      target_label: instance

    # Kubernetes puts logs under subdirectories keyed pod UID.
    - source_labels: [__meta_kubernetes_pod_uid]
      target_label: "__path__"
      replacement: "/var/log/pods/$1/"
```

A set of example YAML files can be found in [jobs/kubernetes](jobs/kubernetes).

## Future work

We have big plan for Promtail:
- [ ] Support alternative log sources.
- [ ] Support sending logs to elasticsearch.
- [ ] Export more Prometheus metrics.
- [ ] Example of how to run locally.
