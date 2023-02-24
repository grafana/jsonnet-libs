# Wildfly Mixin

Wildfly mixin is a set of configurable Grafana dashboards and alerts based on the metrics exported by [Wildfly](https://docs.wildfly.org/22/Admin_Guide.html#MicroProfile_Metrics_SmallRye).

This Wildfly mixin contains the following dashboards:

Set of two dashboards:

- Wildfly overview
- Wildfly datasource

## Wildfly Overview

The Wildfly overview dashboard provides details on traffic, sessions, and server logs[Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance. The default Wildfly server log path is `/opt/wildfly/standalone/log/server.log.` To enable session metrics you must run the following command in the Wildfly CLI:

```
/subsystem=undertow:write-attribute(name=statistics-enabled,value=true)
```

Wildfly logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

#TODO screenshots

## Wildfly Datasource

The Wildfly datasource dashboard provides details on connections and transactions to the specified datasource. To enable transaction metrics you must run the following command in th Wildfly CLI:

```
/subsystem=transactions:write-attribute(name=statistics-enabled, value=true)
```

#TODO screenshots

## Install Tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
# or in brew: brew install go-jsonnet
```

For linting and formatting, you would also need `mixtool` and `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will be depending on your environment.

`prometheus_alerts.yaml` needs to be imported into Prometheus.

## Generate dashboards and alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
