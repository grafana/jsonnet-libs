# Wildfly Mixin

Wildfly mixin is a set of configurable Grafana dashboards and alerts based on the metrics Grafana Agent Prometheus integration.

This Wildfly mixin interesting features:

Set of two dashboards:

- Wildfly Overview - view metrics and logs grouped by jobs, instances, server, and deployments.
  ![screenshot-0](tbd)
- Wildfly Datasource - view metrics grouped by jobs, instances, and datasource.
  ![screenshot-1](tbd)

## prometheus scraper/grafana agent configuration

In the Grafana agent configuration file, the agent's prometheus scraper should configured the following way:

```yaml
metrics:
  configs:
    - host_filter: false
      name: agent
      remote_write:
        - url: http://cortex.default.svc.cluster.local:9009/api/prom/push
      scrape_configs:
        - job_name: integrations/wildfly
          metrics_path: /metrics
          scrape_interval: 10s
          basic_auth:
            username: admin
            password: password
          static_configs:
            - targets: ["wildfly.sample-apps.svc.cluster.local:9990"]
              # Basic authentication may be required if enabled in Wildfly
```

## Generate config files

You can manually generate dashboards, but first you should install some tools:

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
