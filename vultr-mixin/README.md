# Vultr Mixin

The Vultr mixin is a set of configurable Grafana dashboards and alerts based on the Prometheus-format instance metrics exposed by the [Vultr API](https://docs.vultr.com/).

## Dashboards

- **Vultr instances** - Provides details on instance count, CPU usage, disk operations, network traffic, bandwidth used against the billing period allowance and, for GPU plans, GPU utilization, memory, temperature and power.

## Alerts

| Alert | Summary |
| ----- | ------- |
| VultrMetricsDown | Grafana is no longer receiving Vultr metrics. |
| VultrInstanceHighCPUUsage | CPU usage on an instance is above the configured threshold. |
| VultrBandwidthAllowanceWarning | Pooled outbound bandwidth used this billing period is close to the allowance. |
| VultrBandwidthAllowanceCritical | Pooled outbound bandwidth used this billing period has nearly reached the allowance. |
| VultrInstanceGPUHighTemperature | GPU temperature on an instance is above the configured threshold. |

Alert thresholds can be configured in `config.libsonnet`. See the generated `prometheus_alerts.yaml` for default values.

## Configuration

Vultr attaches `uuid`, `label`, `hostname`, `region`, `plan` and `os` labels to every instance series. Dashboards are filtered by `job`, `region` and `label`, where `label` is the instance name shown in the Vultr console.

Set `filteringSelector` in `config.libsonnet` to scope all dashboards and alerts to the job that collects the Vultr metrics, for example `job="integrations/vultr"`.

## Install Tools

To use this mixin, a working Golang toolchain is required, alongside having `mixtool` and `jsonnetfmt` installed. 
To do so, run the following:

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

## Generate Dashboards and Alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

The files in `dashboards_out` need to be imported into your Grafana server. The `prometheus_alerts.yaml` file needs to be imported into Prometheus.

For more advanced uses of mixins, see [Prometheus Monitoring Mixins docs](https://github.com/monitoring-mixins/docs).
