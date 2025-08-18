local alerts = import './alerts.libsonnet';
local config = import './config.libsonnet';
local dashboards = import './dashboards.libsonnet';
local g = import './g.libsonnet';
local links = import './links.libsonnet';
local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  withConfigMixin(config): {
    config+: config,
  },

  new(): {

    local this = self,
    config: config,

    signals:
      {
        [sig]: commonlib.signals.unmarshallJsonMulti(
          this.config.signals[sig],
          type=this.config.metricsSource
        )
        for sig in std.objectFields(this.config.signals)
      },

    grafana: {
      variables: commonlib.variables.new(
        filteringSelector=this.config.filteringSelector,
        groupLabels=this.config.groupLabels,
        instanceLabels=this.config.instanceLabels,
        varMetric='cloudflare_zone_requests_total',
        customAllValue='.+',
        enableLokiLogs=false,
      ) + {
        // Custom variable for geomap metric selection
        geoMetric: g.dashboard.variable.custom.new(
                     'geo_metric',
                     values=[
                       'cloudflare_zone_requests_country',
                       'cloudflare_zone_bandwidth_country',
                       'cloudflare_zone_threats_country',
                     ]
                   )
                   + g.dashboard.variable.custom.generalOptions.withLabel('Geomap metric')
                   + g.dashboard.variable.custom.generalOptions.withCurrent('cloudflare_zone_requests_country')
                   + g.dashboard.variable.custom.selectionOptions.withMulti(false)
                   + g.dashboard.variable.custom.selectionOptions.withIncludeAll(false),
      },
      annotations: {},
      links: links.new(this),
      panels: panels.new(this),
      dashboards: dashboards.new(this),
      rows: rows.new(this),
    },

    prometheus: {
      alerts: alerts.new(this),
      recordingRules: {},
    },
  },
}
