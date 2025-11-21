local g = import './g.libsonnet';

{
  local link = g.dashboard.link,
  new(this): {
    sapHanaOverview:
      link.link.new('SAP HANA system overview', '/d/' + this.grafana.dashboards['sap-hana-system-overview.json'].uid)
      + link.link.options.withKeepTime(true),

    sapHanaInstance:
      link.link.new('SAP HANA instance overview', '/d/' + this.grafana.dashboards['sap-hana-instance-overview.json'].uid)
      + link.link.options.withKeepTime(true),

    otherDashboards:
      link.dashboards.new('All dashboards', this.config.dashboardTags)
      + link.dashboards.options.withIncludeVars(true)
      + link.dashboards.options.withKeepTime(true)
      + link.dashboards.options.withAsDropdown(true),

  } + if this.config.enableLokiLogs then {
    sapHanaLogs:
      link.link.new('SAP HANA logs', '/d/' + this.grafana.dashboards['sap-hana-logs.json'].uid)
      + link.link.options.withKeepTime(true),
  } else {},
}
