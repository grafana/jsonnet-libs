local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(config): {
    local this = self,
    config: config,
    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(this.config.signals[sig], type=this.config.metricsSource)
        for sig in std.objectFields(this.config.signals)
      },
    grafana: {
      panels: (import './panels/main.libsonnet').new(this),
      rows: (import './rows.libsonnet').new(this),
      dashboards: (import './dashboards.libsonnet').new(this),
    },
    local importRules(rules) = {
      groups+: std.parseYaml(rules).groups,
    },
    asMonitoringMixin(): {
      grafanaDashboards+:: this.grafana.dashboards,
      prometheusAlerts+:
        importRules(importstr 'alerts/azure-alerts.yml') + importRules(importstr 'alerts/gcp-alerts.yml'),
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
