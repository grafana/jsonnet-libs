# Grafana Labs' Jsonnet libraries

This repository contains various Jsonnet libraries we use at Grafana Labs:

* [`consul-mixin`](consul-mixin/): A set of reuseable and extensible dashboards
  and alerts for running Hashicorp's Consul.

* [`grafana-builder`](grafana-builder/): A library for building Grafana dashboards
  with jsonnet, following the builder pattern.

* [`ksonnet-util`](ksonnet-util/): An overlay and set of utilities for [ksonnet](https://ksonnet.io/)
  that makes working with the library easier.

* [`memcached-mixin`](memcached-mixin/): A set of reuseable and extensible dashboards
  for Memcached.

* [`oauth2-proxy`](oauth2-proxy/): A ksonnet configuration for deploying bitly's
  OAuth proxy to Kubernetes.

* [`prometheus-ksonnet`](prometheus-ksonnet/): A set of extensible configurations
  for running Prometheus on Kubernetes.

## Jsonnet-bundler

`jsonnetfile.json` are formatted with jb v0.3.1, this is not backwards compatible with jb v0.2.0. We strongly
adivse to upgrade jb. If that is not possible right now, tag `pre-0.3` that marks the last version supporting jb v0.2.0.

## LICENSE

[Apache-2.0](LICENSE)
