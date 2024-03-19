# OpenLDAP Mixin

The OpenLDAP mixin is a set of configurable Grafana dashboards and alerts.

The OpenLDAP mixin contains the following dashboards:

- OpenLDAP overview
- OpenLDAP logs overview

and the following alerts:

- OpenLDAPConnectionSpike
- OpenLDAPHighSearchOperationRateSpike
- OpenLDAPDialFailureRateIncrease
- OpenLDAPBindFailureRateIncrease

## OpenLDAP  Overview

The OpenLDAP cluster overview dashboard provides details on connections, waiters, network connectivity, PDU processes, authentication attempts, operations and threads metrics.

![OpenLDAP Overview Dashboard (operations)](https://storage.googleapis.com/grafanalabs-integration-assets/openldap/screenshots/openldap-overview-1.png)

## OpenLDAP Logs Overview

The OpenLDAP logs overview dashboard provides details on the stats olc logs level. [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance. 

OpenLDAP logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, please also include the matching `job` label onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

Additionally to get slapd logs that contain stats level logging, you may need to [configure OpenLDAP](https://tutoriels.meddeb.net/openldap-tutorial-log/) to enable stats logs and configured for rsyslog. 

```yaml
scrape_configs:
  - job_name: integrations/openldap
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/openldap
          __path__: /var/log/slapd/*.log
          instance: '<your-instance-name>'
    pipeline_stages:
      - multiline:
          firstline: '^\[\d{2}-\d{2}-\d{4} \d{2}:\d{2}:\d{2}\]'
      - regex:
          expression: '^\[\d{2}-\d{2}-\d{4} \d{2}:\d{2}:\d{2}\] (?P<component>\S+) (?P<level>\w+)'
      - labels:
          level:
          component:
```

![OpenLDAP Logs Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/openldap/screenshots/openldap-logs-overview.png)

## Alerts Overview

| Alert                                | Summary                                                                                                                                                               |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| OpenLDAPConnectionSpike              | A sudden spike in OpenLDAP connections indicates potential high usage or security issues.                                                                             |
| OpenLDAPHighSearchOperationRateSpike | A significant spike in OpenLDAP search operations indicates inefficient queries, potential abuse, or unintended heavy load.  performance.                             |
| OpenLDAPDialFailureRateIncrease      | Significant increase in LDAP dial failures indicates network issues, problems with the LDAP service, or configuration errors that may lead to service unavailability. |
| OpenLDAPBindFailureRateIncrease      | Significant increase in LDAP bind failures indicates authentication issues, potential security threats or problems with user directories.                             |

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
    alertsWarningConnectionSpike: 100,
    alertsWarningHighSearchOperationRateSpike: 100,
    alertsCriticalDialFailureRateIncrease: 50,
    alertsCriticalBindFailureRateIncrease: 50,
  },
}
```

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

## Generate Dashboards And Alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.


Documentation
port forwarding with the multipass VM
One shot prompting, can't figure out
