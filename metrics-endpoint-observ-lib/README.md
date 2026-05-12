# Metrics-endpoint observability lib

This lib can be used to generate dashboards, rows, or panels of metrics-endpoint scraping signals.

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/metrics-endpoint-observ-lib
```

## Usage

This library is intended to be used together with other integrations to offer
insight into the Grafana Cloud metrics endpoint scraping process.  As such, it
can be modified to show branding and documentation of another integration:

```jsonnet
local observlib = import 'main.libsonnet';
local mixin =
  (observlib.new()
   + observlib.withConfigMixin({
     filteringSelector: 'job=~"some-specific-scrape"',
     parentIntegration: {
       name: 'My application',
       id: 'my-application',
       logoURL: '<application-logo-url>',
     },
   })).asMonitoringMixin();
```
