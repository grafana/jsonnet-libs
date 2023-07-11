local config = (import './config.libsonnet');

{
  // The main patch method that takes the entire dashboard model as input and patches accordingly
  patch(dashboard):
    dashboard +
    $.prune_ds_graphite() +
    {
      panels: $.add_cluster_matcher($.prune_graphite_panels(dashboard.panels)),
      templating+: {
        list: [
          if i == 1 then
            {
              allValue: null,
              datasource: '$datasource',
              includeAll: false,
              label: 'Cluster name',
              multi: false,
              name: 'cluster',
              options: [],
              query: 'label_values(%s)' % config.cluster_labelname,
              refresh: 2,
              regex: '',
              sort: 1,
              tagValuesQuery: '',
              tags: [],
              tagsQuery: '',
              type: 'query',
              useTags: false,
            }
          else if i < 1 then
            local t = dashboard.templating.list[i];
            t +
            $.patch_loki_ds(t) +
            $.patch_label_value(t) +
            $.patch_label_name(t) +
            $.add_template_cluster_matcher(t)
          else
            local t = dashboard.templating.list[i - 1];
            t +
            $.patch_loki_ds(t) +
            $.patch_label_value(t) +
            $.patch_label_name(t) +
            $.add_template_cluster_matcher(t)
          for i in std.range(0, std.length(dashboard.templating.list))
        ],
      },
    },

  /******** Dashboard level overrides ********/
  // Removes the graphite datasource input
  prune_ds_graphite(): {
    __inputs: [],
  },

  /********** Panel level overrides **********/
  // Removes any panel which uses the graphite datasource which was removed.
  prune_graphite_panels(panels): [
    if p.datasource.uid == '${DS_GRAPHITE}' then {} else p
    for p in panels
  ],

  // Hamfisted function to append `cluster="$cluster"` to each query. This works because the loki queries used in the dashboard
  // only have one matcher and aggregation function. If that changes, so too does this assertion, and things will get ugly.
  // A better way to do this would be to post-process with a golang binary which *actually* parses the logql and modifies each
  // matcher. But... This works for now, assuming the dashboard queries don't change dramatically.
  add_cluster_matcher(panels): [
    // For collapsed panels (rows) where the child panels are nested to "hide" them from being rendered in Grafana.
    // Nasty recursion, which is possibly difficult to grok, but makes the code compact. ¯\_(ツ)_/¯
    if std.objectHas(p, 'panels') then p { panels: $.add_cluster_matcher(p.panels) }
    else if std.objectHas(p, 'targets') then p {
      // For non collapsed panels which are at the root level
      targets: [
        if std.objectHas(t, 'expr') then t { expr: std.strReplace(t.expr, 'instance=~"$instance"}', 'instance=~"$instance", %s="$cluster"}' % config.cluster_labelname) } else t { matched: true }
        for t in p.targets
      ],
    }
    else p

    for p in panels
  ],

  /********** Templating overrides ***********/
  // Updates the loki datasource label to 'Data Source' for to satisfy linting and best practices.
  // Also removes the current selected data source to prevent errors on initial load.
  patch_loki_ds(t): if t.name == 'datasource' then { label: 'Data Source', current: {} } else {},

  // Updates the label_value variable to have an all value of .+, which avoids errors when
  // first loading the dashboard, or when there are not log lines matching the selected variables.
  patch_label_value(t): if t.name == 'label_value' then { allValue: '.+' } else {},

  // Updates the label_name variable to sort alphabetically descending. This prevents the label name
  // `__name__` being the first selected value, which causes an "query must contain metric name" error on initial load.
  patch_label_name(t): if t.name == 'label_name' then { sort: 2 } else {},

  add_template_cluster_matcher(t):
    if std.objectHas(t, 'definition') then
      {
        definition: std.strReplace(t.definition, '{$label_name=~"$label_value"}', '{$label_name=~"$label_value", %s="$cluster"}' % config.cluster_labelname),
        query: std.strReplace(t.query, '{$label_name=~"$label_value"}', '{$label_name=~"$label_value", %s="$cluster"}' % config.cluster_labelname),
      } else {},
}
