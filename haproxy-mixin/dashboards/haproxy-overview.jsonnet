local d = import 'dashboards.libsonnet';
local g = import 'github.com/grafana/dashboard-spec/_gen/7.0/jsonnet/grafana.libsonnet';

g.dashboard.new() + {
  title: 'HAProxy / Overview',

  panels:
    local headline = d.util.section([
      d.panels.processUptime('prometheus'),
      d.panels.processCurrentConnections('prometheus'),
      d.panels.processMemoryAllocated('prometheus'),
      d.panels.processMemoryUsed('prometheus'),
    ], g.panel.row.new(title='Headline'));
    local frontend = d.util.section([d.panels.frontendStatus('prometheus')], g.panel.row.new(title='Frontend'), prevSection=headline, panelSize={ h: 8, w: 24 });
    local backend = d.util.section([d.panels.backendStatus('prometheus')], g.panel.row.new(title='Backend'), prevSection=frontend, panelSize={ h: 8, w: 24 });
    local configuration =
      d.util.section([
        d.panels.processCount('prometheus'),
        d.panels.processThreads('prometheus'),
        d.panels.processConnectionsLimit('prometheus'),
        d.panels.processFDLimit('prometheus'),
        d.panels.processSocketLimit('prometheus'),
        d.panels.processMemoryLimit('prometheus'),
      ], g.panel.row.new(title='Configuration'), prevSection=backend);
    headline + frontend + backend + configuration,
  templating: {
    list: [
      d.templates.datasource,
      d.templates.instance,
      d.templates.job,
    ],
  },
  time: {
    from: 'now-6h',
    to: 'now',
  },
  timepicker: {
    hidden: false,
    refresh_intervals: [
      '5s',
      '10s',
      '30s',
      '1m',
      '5m',
      '15m',
      '30m',
      '1h',
      '2h',
      '1d',
    ],
  },
  uid: 'HAProxyOverview',
}
