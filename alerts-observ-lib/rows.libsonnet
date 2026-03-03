local g = import './g.libsonnet';

{
  new(panels): {
    alertsOverview:
      g.panel.row.new('Alerts overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          panels.alertsOverview { gridPos: { h: 8, w: 8, x: 0, y: 0 } },
        ]
      ),
  },
}
