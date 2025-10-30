local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this): {
               clusterOverview:
                 link.link.new(this.config.dashboardNamePrefix + ' cluster overview', '/d/' + this.grafana.dashboards['f5-bigip-cluster-overview.json'].uid)
                 + link.link.options.withKeepTime(true),

               nodeOverview:
                 link.link.new(this.config.dashboardNamePrefix + ' node overview', '/d/' + this.grafana.dashboards['f5-bigip-node-overview.json'].uid)
                 + link.link.options.withKeepTime(true),

               poolOverview:
                 link.link.new(this.config.dashboardNamePrefix + ' pool overview', '/d/' + this.grafana.dashboards['f5-bigip-pool-overview.json'].uid)
                 + link.link.options.withKeepTime(true),

               virtualServerOverview:
                 link.link.new(this.config.dashboardNamePrefix + ' virtual server overview', '/d/' + this.grafana.dashboards['f5-bigip-virtual-server-overview.json'].uid)
                 + link.link.options.withKeepTime(true),

               otherDashboards:
                 link.dashboards.new('All dashboards', this.config.dashboardTags)
                 + link.dashboards.options.withIncludeVars(true)
                 + link.dashboards.options.withKeepTime(true)
                 + link.dashboards.options.withAsDropdown(true),
             }
             +
             if this.config.enableLokiLogs then
               {
                 logs:
                   link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['f5-bigip-logs.json'].uid)
                   + link.link.options.withKeepTime(true),
               } else {},
}
