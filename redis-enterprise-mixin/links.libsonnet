local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this): {
               redisEnterpriseOverview:
                 link.link.new('Redis Enterprise overview', '/d/' + this.grafana.dashboards['redis-enterprise-overview.json'].uid),
               redisEnterpriseNodes:
                 link.link.new('Redis Enterprise nodes', '/d/' + this.grafana.dashboards['redis-enterprise-node-overview.json'].uid),
               redisEnterpriseDatabases:
                 link.link.new('Redis Enterprise databases', '/d/' + this.grafana.dashboards['redis-enterprise-database-overview.json'].uid),
               dashboards:
                 link.dashboards.new('All Redis Enterprise dashboards', this.config.dashboardTags)
                 + link.dashboards.options.withKeepTime(true)
                 + link.dashboards.options.withIncludeVars(true)
                 + link.dashboards.options.withAsDropdown(true),
             }

             + if this.config.enableLokiLogs then {
               redisEnterpriseLogs:
                 link.link.new('Redis Enterprise logs', '/d/' + this.grafana.dashboards['redis-enterprise-logs.json'].uid)
                 + link.link.options.withKeepTime(true),
             }
             else {},
}
