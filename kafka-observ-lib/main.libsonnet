local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local jvmlib = import 'jvm-observ-lib/main.libsonnet';
local zookeeperlib = import 'zookeeper-observ-lib/main.libsonnet';
{
  new(): {
    local this = self,
    config: import './config.libsonnet',
    //include jvm lib
    jvm::
      jvmlib.new()
      + jvmlib.withConfigMixin(
        {
          filteringSelector: this.config.filteringSelector,
          groupLabels: this.config.groupLabels,
          instanceLabels: this.config.instanceLabels,
          uid: this.config.uid,
          dashboardNamePrefix: this.config.dashboardNamePrefix,
          dashboardTags: this.config.dashboardTags,
          metricsSource: this.config.jvmMetricsSource,
        }
      ),
    zookeeper::
      zookeeperlib.new()
      + zookeeperlib.withConfigMixin(
        {
          filteringSelector: this.config.zookeeperfilteringSelector,
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
      }
      + if this.config.zookeeperEnabled then { zookeeper: this.zookeeper.signals } else {},
    grafana: {
      panels: (import './panels/main.libsonnet').new(this.signals, this.config)
              + { jvm: this.jvm.grafana.panels }
              + if this.config.zookeeperEnabled then { zookeeper: this.zookeeper.grafana.panels } else {},
      rows: (import './rows.libsonnet').new(this.grafana.panels, type=this.config.metricsSource)
            + { jvm: this.jvm.grafana.rows }
            + if this.config.zookeeperEnabled then { zookeeper: this.zookeeper.grafana.rows } else {},

      // common links here
      links: {
        local link = g.dashboard.link,
        otherDashboards:
          link.dashboards.new('All Kafka dashboards', this.config.dashboardTags)
          + link.dashboards.options.withIncludeVars(true)
          + link.dashboards.options.withKeepTime(true)
          + link.dashboards.options.withAsDropdown(false),
      },

      dashboards: (import './dashboards.libsonnet').new(this)
                  + if this.config.zookeeperEnabled then
                    {
                      'zookeeper-overview.json':
                        this.zookeeper.grafana.dashboards['zookeeper-overview.json']
                        + g.dashboard.withLinks(this.grafana.links.otherDashboards),
                    }

                  else {},
    },
    prometheus: {
      alerts: (import './alerts.libsonnet').new(this)
              + { groups+: this.jvm.prometheus.alerts.groups }
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
