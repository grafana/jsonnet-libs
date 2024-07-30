local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local zookeeperlib = import 'zookeeper-observ-lib/main.libsonnet';
{
  new(): {
    local this = self,
    config: import './config.libsonnet',
    //include jvm lib
    zookeeper::
      zookeeperlib.new()
      + zookeeperlib.withConfigMixin(
        {
          filteringSelector: this.config.filteringSelector,
          groupLabels: this.config.groupLabels,
          instanceLabels: this.config.instanceLabels,
          uid: this.config.uid,
          dashboardNamePrefix: this.config.dashboardNamePrefix,
          dashboardTags: this.config.dashboardTags,
          metricsSource: this.config.metricsSource,
        }
      ),
    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(this.config.signals[sig], type=this.config.metricsSource)
        for sig in std.objectFields(this.config.signals)
      },
    grafana: {
      panels: (import './panels/main.libsonnet').new(this.signals)
              + if this.config.zookeeperEnabled then { zookeeper: this.zookeeper.grafana.panels } else {},
      rows: (import './rows.libsonnet').new(this.grafana.panels, type=this.config.metricsSource)
            + if this.config.zookeeperEnabled then { zookeeper: this.zookeeper.grafana.rows } else {},
      dashboards: (import './dashboards.libsonnet').new(this)
                  + if this.config.zookeeperEnabled then this.zookeeper.grafana.dashboards else {},
    },
    prometheus: {
      alerts: (import './alerts.libsonnet').new(this)
              + if this.config.zookeeperEnabled then { groups+: this.zookeeper.prometheus.alerts.groups } else {},
      recordingRules: {},
    },
    asMonitoringMixin(): {
      // _config+:: this.config,
      grafanaDashboards+:: this.grafana.dashboards,
      prometheusAlerts+:: this.prometheus.alerts,
      prometheusRuless+:: this.prometheus.recordingRules,
    },
  },

  withConfigMixin(config): {
    config+: config,
  },
}
