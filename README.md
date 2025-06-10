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

* [`nodejs-mixin`](nodejs-mixin/): A set of reuseable and extensible dashboards
  for Node.js.

* [`caddy-mixin`](caddy-mixin/): A set of reusable and extensible dashboards
  for Caddy.

* [`jira-mixin`](jira-mixin/): A set of reusable and extensible dashboards and alerts for JIRA.

You can find more in directories with `-mixin` suffix.

### Linting

The monitoring mixins in this repository use two linting tools to ensure quality and consistency:

* [mixtool](https://github.com/monitoring-mixins/mixtool): Validates the structure and syntax of monitoring mixins, ensuring they follow the standard mixin format.
* [pint](https://github.com/cloudflare/pint): Lints Prometheus rules and alerts to catch common mistakes and enforce best practices.

## Observability libraries

Observability library is a flexible format to describe dashboards and alerts in a modular way so libraries can be imported into one another or into monitoring-mixins. Observability libraries can be found in folders with `-observ-lib` suffix. [Common library](https://github.com/grafana/jsonnet-libs/tree/master/common-lib) is also used to apply consistent style options.

Some examples:
 - [windows-observ-lib](windows-observ-lib/)

 ### Observability libraries signal extention

 [Signal](https://github.com/grafana/jsonnet-libs/tree/master/common-lib/common/signal#signal) is the experimental extension to observability libraries format to declare metrics (signals) and then render them as different grafana panel types (timeseries, stat, table, etc), or alert rules.

Examples:
 - [docker-mixin](docker-mixin/)
 - [kafka-observ-lib](kafka-observ-lib/)
 - [jvm-observ-lib](jvm-observ-lib/)
 - [snmp-observ-lib](snmp-observ-lib/)
 - [process-observ-lib](process-observ-lib/)
 - [golang-observ-lib](golang-observ-lib/)
 - [csp-mixin](csp-mixin/)

 ## Prometheus rules testing for monitoring mixins and observability libraries

It is highly recommended to test prometheus alerts with [promtool test rules](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules) command when complex PromQL queries are used or when additional queries are used in alerts' annotations.

promtool tests files should be placed in tests directory in the root of the library and should be named like `prometheus_*.yaml`. This will enable running tests ing Github Actions and with `make test` command.

A good example of promtool tests can be found in windows-observ-lib: [prometheus_alerts_test.yaml](windows-observ-lib/tests/prometheus_alerts_test.yaml)

## LICENSE

[Apache-2.0](LICENSE)
