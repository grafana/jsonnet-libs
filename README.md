# Grafana Labs' Jsonnet libraries

This repository contains various Jsonnet libraries we use at Grafana Labs:

* [`prometheus-ksonnet`](prometheus-ksonnet/): A set of extensible configurations
  for running Prometheus on Kubernetes.
* [`grafana-builder`](grafana-builder/): A library for building Grafana dashboards
  with jsonnet, following the builder pattern.
* [`ksonnet-util`](ksonnet-util/): An overlay and set of utilities aiming at making working with Kubernetes easier.
* [`oauth2-proxy`](oauth2-proxy/): A jsonnet configuration for deploying bitly's
  OAuth proxy to Kubernetes.

## Monitoring mixins

Based on format described [here](https://monitoring.mixins.dev/):

* [`consul-mixin`](consul-mixin/): A set of reuseable and extensible dashboards
  and alerts for running Hashicorp's Consul.

* [`memcached-mixin`](memcached-mixin/): A set of reuseable and extensible dashboards
  for Memcached.

* [`nodejs-mixin`](nodejs-mixin/): A set of reusable and extensible dashboards
  for Node.js.

* [`caddy-mixin`](caddy-mixin/): A set of reusable and extensible dashboards
  for Caddy.



* [`jira-mixin`](jira-mixin/): A set of reusable and extensible dashboards and alerts for JIRA.

You can find more in directories with `-mixin` suffix.

## Observability libraries

Observability library is a flexible format to describe dashboards and alerts in a modular way so libraries can be imported into one another or into monitoring-mixins. Observability libraries can be found in folders with `-observ-lib` suffix. [Common library](https://github.com/grafana/jsonnet-libs/tree/master/common-lib) is also used to apply consistent style options.

See [helloworld-observ-lib](helloworld-observ-lib/) for starter template and format description.

More examples:
 - [windows-observ-lib](windows-observ-lib/)

 ### Observability libraries signal extention

 [Signal](https://github.com/grafana/jsonnet-libs/tree/master/common-lib/common/signal#signal) is the experimental extenstion to observability libraries format to declatively define metrics (signals) and then render them as different grafana panel types (timeseries, stat, table, etc), or alert rules.

Examples:
 - [kafka-observ-lib](kafka-observ-lib/)
 - [jvm-observ-lib](jvm-observ-lib/)
 - [process-observ-lib](process-observ-lib/)
 - [golang-observ-lib](golang-observ-lib/)
 - [csp-mixin][(csp-mixin/)



## LICENSE

[Apache-2.0](LICENSE)
