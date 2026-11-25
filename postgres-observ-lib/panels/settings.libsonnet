local g = import '../g.libsonnet';

{
  new(signals, config):: {
    // Settings table - shows all pg_settings_* metrics in a searchable table
    settingsTable:
      signals.settings.allSettings.asTable()
      + g.panel.table.panelOptions.withDescription(
        'PostgreSQL configuration settings. Use the Settings filter variable above to search by setting name (regex). Default .* shows all settings.'
      )
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              __name__: false,
              // postgres_exporter adds a server label to pg_settings_* and the other built-in metrics.
              server: true,
            } + { [label]: true for label in config.groupLabels + config.instanceLabels },
            indexByName: {
              __name__: 0,
              Value: 1,
            },
            renameByName: {
              __name__: 'Setting',
              Value: 'Value',
            },
          },
        },
        {
          id: 'sortBy',
          options: {
            fields: {},
            sort: [
              {
                field: 'Setting',
                desc: false,
              },
            ],
          },
        },
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Setting',
          },
          properties: [
            {
              id: 'custom.filterable',
              value: true,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value',
          },
          properties: [
            {
              id: 'custom.width',
              value: 200,
            },
          ],
        },
      ])
      + g.panel.table.options.withShowHeader(true)
      + g.panel.table.options.withSortBy([
        {
          displayName: 'Setting',
          desc: false,
        },
      ])
      + g.panel.table.options.footer.withEnablePagination(true),
  },
}
