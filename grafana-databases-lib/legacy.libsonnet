// legacy: a migration step for dashboards still built with grafana-builder.
//
// The library's panels and rows are dashboard v2 elements and rows (see
// dashboard.libsonnet). These helpers convert them to the classic panels that
// grafana-builder rows hold, laid out by `span`. Once a dashboard is built as a
// v2 dashboard, it uses the library's panels and rows as they are, and these
// helpers go.
{
  // panel returns a library panel element as a classic panel, ready for a
  // grafana-builder row's addPanel().
  panel(panel)::
    local spec = panel.spec;
    local viz = spec.vizConfig;
    local datasource(q) = { type: q.spec.query.group, uid: q.spec.query.datasource.name };
    local queries = spec.data.spec.queries;
    local fieldConfig = viz.spec.fieldConfig;
    {
      type: viz.group,
      title: spec.title,
      description: spec.description,
      [if std.length(queries) > 0 then 'datasource']: datasource(queries[0]),
      // Classic panels leave refIds to Grafana, so they are dropped here.
      targets: [{ datasource: datasource(q) } + q.spec.query.spec for q in queries],
      fieldConfig: { defaults: fieldConfig.defaults }
                   + (if std.length(fieldConfig.overrides) > 0 then { overrides: fieldConfig.overrides } else {}),
      options: viz.spec.options,
      [if viz.version != '' then 'pluginVersion']: viz.version,
    },

  // rowPanels returns the panels of a library row as classic panels, ready for
  // a grafana-builder row's addPanel().
  rowPanels(row):: [self.panel(p) for p in row.panels],
}
