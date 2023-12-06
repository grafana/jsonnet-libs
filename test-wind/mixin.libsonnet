local windowsobservlib = import '../windows-observ-lib/main.libsonnet';

local activedirectorymixin =
  windowsobservlib.new(
    filteringSelector='job=~"integrations/windows_exporter"',
    uid='active-directory',
    groupLabels=['job'],
    instanceLabels=['instance'],
  )
  +  
    {
			config+: {
      enableLokiLogs: false,
			enableADDashboard: true,
			}
    };

{  // TODO: Alter mixin to only pull in nessesary dashboards + alerts
  grafanaDashboards+:: activedirectorymixin.grafana.dashboards,  // add the specific dashboards here
  prometheusAlerts+:: activedirectorymixin.prometheus.alerts,  // add the specific alerts here
  prometheusRules+:: activedirectorymixin.prometheus.recordingRules,
}
