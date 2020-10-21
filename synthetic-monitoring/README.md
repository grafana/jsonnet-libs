# Synthetic Monitoring Jsonnet Library

This library simplifies the interaction with the Grafana Synthetic Monitoring API
by making the configuration of a check significantly more concise.

Grafana Labs' Synthetic Monitoring is a blackbox monitoring solution provided
as a part of Grafana Cloud. It provides users with insights into how their
applications and services are behaving from an external point of view.

It can be configured via an HTTP API. This library generates objects that can
be used when interacting with the API, e.g. with a tool like [Grizzly](https://github.com/grafana/grizzly).

## Usage

This library is designed to be used with [Grizzly](https://github.com/grafana/grizzly),
which supports the Synthetic Monitoring API.

Here is an example usage:
**`main.jsonnet:`**
```
local sm = import 'synthetic-monitoring/sm.libsonnet';
  
{
  syntheticMonitoring+:: {
    grafanaHttpCheck: sm.http.new('grafana', 'https://grafana.com/')
                      + sm.withProbes('all'),  // enable all probes
    grafanaPingCheck: sm.ping.new('grafana', 'grafana.com')
                      + sm.withProbes('continents'),  // one check per continent
    grafanaDnsCheck: sm.dns.new('grafana', 'grafana.com')
                     + sm.withProbes('europe'),  // just check from Europe
    grafanaTcpCheck: sm.tcp.new('grafana', 'grafana.com:443')
                     + sm.withProbes('small'),  // just use a smaller, predefined set of checks
  },
}
```

To apply this to your cluster, set the `GRAFANA_SM_TOKEN` envvar to an API key from your
Grafana.com account, then execute:

```
$ grr apply main.jsonnet
```

This should create four probes for you.

