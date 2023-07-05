{
  // The main patch method that takes the entire dashboard model as input and patches accordingly
  patch(dashboard):
    dashboard +
    $.prune_ds_graphite() +
    {
      panels: $.prune_graphite_panels(dashboard.panels),
      templating+: {
        list: [
          t +
          $.patch_loki_ds(t) +
          $.patch_label_value(t)
          for t in dashboard.templating.list
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

  /********** Templating overrides ***********/
  // Updates the loki datasource label to 'Data Source' for to satisfy linting and best practices.
  patch_loki_ds(t): if t.name == 'datasource' then { label: 'Data Source' } else {},

  // Updates the label_value variable to have an all value of .+, which avoids errors when
  // first loading the dashboard, or when there are not log lines matching the selected variables.
  patch_label_value(t): if t.name == 'label_value' then { allValue: '.+' } else {},
}
