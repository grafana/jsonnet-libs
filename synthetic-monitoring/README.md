# Synthetic Monitoring Jsonnet Library

This library simplifies interaction with the Grafana Synthetic Monitoring API.

Grafana Labs' Synthetic Monitoring is a blackbox monitoring solution provided
as a part of Grafana Cloud. It provides users with insights into how their
applications and services are behaving from an external point of view.

It can be configured via an HTTP API. This library allows interaction with
this API using Jsonnet, making the creation of 'checks' simple.

## Usage

This library is designed to be used with [Grizzly](https://github.com/grafana/grizzly),
which supports the Synthetic Monitoring API.

Here is an example usage:
**`main.jsonnet:`**
```
local sm = import 'synthetic-monitoring/sm.libsonnet';
{
  syntheticMonitoring+:: {
    grafanaHttpCheck: sm.new('grafana', 'https://grafana.com/')
                      + sm.withHttp()
                      + sm.withProbes('all'),  // enable all probes
    grafanaPingCheck: sm.new('grafana', 'grafana.com')
                      + sm.withPing()
                      + sm.withProbes('continents'),  // one check per continent
    grafanaDnsCheck: sm.new('grafana', 'grafana.com')
                     + sm.withDns()
                     + sm.withProbes('europe'),  // just check from Europe
    grafanaTcpCheck: sm.new('grafana', 'grafana.com:443')
                     + sm.withTcp()
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

