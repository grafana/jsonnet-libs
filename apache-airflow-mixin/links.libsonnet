local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this): {
               apacheAirflowOverview:
                 link.link.new(this.config.dashboardNamePrefix + ' overview', '/d/' + this.grafana.dashboards['apache-airflow-overview.json'].uid)
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
                   link.link.new(this.config.dashboardNamePrefix + ' logs', '/d/' + this.grafana.dashboards['apache-airflow-logs.json'].uid)
                   + link.link.options.withKeepTime(true),
               } else {},
}
