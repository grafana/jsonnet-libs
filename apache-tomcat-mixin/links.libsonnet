local g = import './g.libsonnet';

{
  local link = g.dashboard.link,

  new(this):
    {
      apacheTomcatOverview: link.link.new(this.config.dashboardNamePrefix + ' overview', '/d/' + this.grafana.dashboards['apache-tomcat-overview.json'].uid)
                            + link.link.options.withKeepTime(true),

      apacheTomcatHosts: link.link.new(this.config.dashboardNamePrefix + ' hosts', '/d/' + this.grafana.dashboards['apache-tomcat-hosts.json'].uid)
                         + link.link.options.withKeepTime(true),

      otherDashboards: link.dashboards.new('All dashboards', this.config.dashboardTags)
                       + link.dashboards.options.withIncludeVars(true)
                       + link.dashboards.options.withKeepTime(true)
                       + link.dashboards.options.withAsDropdown(true),


    } + if this.config.enableLokiLogs then {
      apacheTomcatLogs: link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['apache-tomcat-logs.json'].uid)
                        + link.link.options.withKeepTime(true),
    },
}
