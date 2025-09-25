local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this): {
               influxdbClusterOverview:
                 link.link.new(this.config.dashboardNamePrefix + ' cluster overview', '/d/' + this.grafana.dashboards['influxdb-cluster-overview.json'].uid)
                 + link.link.options.withKeepTime(true),

               influxdbInstanceOverview:
                 link.link.new(this.config.dashboardNamePrefix + ' instance overview', '/d/' + this.grafana.dashboards['influxdb-instance-overview.json'].uid)
                 + link.link.options.withKeepTime(true),

               otherDashboards:
                 link.link.new('All dashboards', this.config.dashboardTags)
                 + link.dashboards.options.withIncludeVars(true)
                 + link.dashboards.options.withKeepTime(true)
                 + link.dashboards.options.withAsDropdown(true),
             }
             +
             if this.config.enableLokiLogs then
               {
                 logs:
                   link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['influxdb-logs.json'].uid)
                   + link.link.options.withKeepTime(true),
               } else {},
}
