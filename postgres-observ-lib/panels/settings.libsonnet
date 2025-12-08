local g = import '../g.libsonnet';

{
  new(signals):: {
    // Get queriesSelector from signals layer (built by common-lib from config)
    local queriesSelector = signals.health.templatingVariables.queriesSelector,

    // Settings table - shows all pg_settings_* metrics in a searchable table
    settingsTable:
      g.panel.table.new('PostgreSQL Settings')
      + g.panel.table.panelOptions.withDescription(
        'PostgreSQL configuration settings. Use the Settings Filter variable above to search by setting name (regex). Default .* shows all settings.'
      )
      + g.panel.table.queryOptions.withTargets([
        {
          datasource: {
            type: 'prometheus',
            uid: '${datasource}',
          },
          expr: std.format('{__name__=~"pg_settings_.*${settingsFilter}.*",%(queriesSelector)s}', { queriesSelector: queriesSelector }),
          format: 'table',
          instant: true,
          refId: 'Settings',
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              __name__: false,
              job: true,
              cluster: true,
              instance: true,
              server: true,
              server_id: true,
              environment: true,
            },
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
            options: 'Job',
          },
          properties: [
            {
              id: 'custom.width',
              value: 150,
            },
            {
              id: 'custom.filterable',
              value: true,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Cluster',
          },
          properties: [
            {
              id: 'custom.width',
              value: 150,
            },
            {
              id: 'custom.filterable',
              value: true,
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Instance',
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
