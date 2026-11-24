// dashboard: the building blocks the library's panels and rows are made of,
// and the helpers to assemble rows into a dashboard. The library builds
// dashboard v2 (dashboard.grafana.app/v2) dashboards.
//
// A dashboard keeps panels in `spec.elements`, keyed by name, and their
// placement in `spec.layout`, which refers to them by name. So every library
// panel carries its element name in the hidden `name` field, and every row
// carries its panels in the hidden `panels` field: `elements(rows)` and
// `layout(rows)` turn a list of rows into the two halves of the spec.
//
// grafonnet has no typed builder for these panels, so the structure follows
// Grafana's types (apps/dashboard/pkg/apis/dashboard/v2). Visualization
// options and field config are the same objects as in a classic panel, so they
// are still built with grafonnet's typed panel helpers.
{
  // panel returns a Panel element. `viz` holds the visualization's
  // `options` and `fieldConfig`, e.g. built from grafonnet's timeSeries option
  // helpers; `version` is the panel plugin version.
  panel(name, type, title, description='', queries=[], viz={}, version=''):: {
    name:: name,
    kind: 'Panel',
    spec: {
      id: 0,  // Set by elements(), as ids must be unique in a dashboard.
      title: title,
      description: description,
      links: [],
      data: {
        kind: 'QueryGroup',
        spec: {
          queries: [
            queries[i] { spec+: { refId: std.char(std.codepoint('A') + i) } }
            for i in std.range(0, std.length(queries) - 1)
          ],
          transformations: [],
          queryOptions: {},
        },
      },
      vizConfig: {
        kind: 'VizConfig',
        group: type,
        version: version,
        spec: { options: {}, fieldConfig: { defaults: {}, overrides: [] } } + viz,
      },
    },
  },

  // query returns a PanelQuery; its refId is set by panel().
  query(datasourceType, datasource, spec):: {
    kind: 'PanelQuery',
    spec: {
      hidden: false,
      query: {
        kind: 'DataQuery',
        group: datasourceType,
        version: 'v0',
        datasource: { name: datasource },
        spec: spec,
      },
    },
  },

  // withViz merges a visualization mixin (options, fieldConfig) into a panel,
  // e.g. `panel + dblib.withViz(g.panel.timeSeries.standardOptions.withUnit('s'))`.
  withViz(mixin):: { spec+: { vizConfig+: { spec+: mixin } } },

  // row returns a RowsLayoutRow laying out `panels` on an auto grid of up
  // to `columns` panels per line (default: all of them, up to 4).
  row(title, panels, columns=null):: {
    local row = self,
    panels:: panels,
    kind: 'RowsLayoutRow',
    spec: {
      title: title,
      collapse: false,
      layout: {
        kind: 'AutoGridLayout',
        spec: {
          maxColumnCount: if columns != null then columns else std.max(1, std.min(4, std.length(row.panels))),
          columnWidthMode: 'standard',
          rowHeightMode: 'standard',
          items: [
            { kind: 'AutoGridLayoutItem', spec: { element: { kind: 'ElementReference', name: p.name } } }
            for p in row.panels
          ],
        },
      },
    },
  },

  // elements returns the `spec.elements` of a dashboard holding `rows`: their
  // panels keyed by element name, with unique ids in the order they first
  // appear. A panel used in several rows is one element.
  elements(rows)::
    local panels = std.flattenArrays([r.panels for r in rows]);
    local unique = std.foldl(
      function(acc, p) if std.objectHas(acc.byName, p.name) then acc else acc { names+: [p.name], byName+: { [p.name]: p } },
      panels,
      { names: [], byName: {} },
    );
    {
      [unique.names[i]]: unique.byName[unique.names[i]] { spec+: { id: i + 1 } }
      for i in std.range(0, std.length(unique.names) - 1)
    },

  // layout returns the `spec.layout` of a dashboard made of `rows`.
  layout(rows):: { kind: 'RowsLayout', spec: { rows: rows } },
}
