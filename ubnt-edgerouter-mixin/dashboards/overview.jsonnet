local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;

{
  grafanaDashboards+:: {
    'dashboard.json':
      dashboard.new(
        'New Dashboard',
        time_from='now-1h',
      ).addTemplate(
        {
          current: {
            text: 'Prometheus',
            value: 'Prometheus',
          },
          hide: 0,
          label: null,
          name: 'datasource',
          options: [],
          query: 'prometheus',
          refresh: 1,
          regex: '',
          type: 'datasource',
        },
      )
      .addRow(
        row.new()
        .addPanel(
          graphPanel.new(
            'Graph',
            datasource='$datasource',
            span=6,
            format='short',
          )
          .addTarget(prometheus.target(
            'node_cpu{%(nodeExporterSelector)s, mode!="idle"})' % $._config,
            legendFormat='{{cpu}}'
          ))
        )
      ),
  },
}
