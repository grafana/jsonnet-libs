local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals):: {
    // Tables needing vacuum (ratio)
    tablesNeedingVacuum:
      signals.maintenance.tablesNeedingVacuum.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.standardOptions.withUnit('percentunit')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.05, color: 'yellow' },   // 5% of tables
        { value: 0.1, color: 'orange' },    // 10% of tables
        { value: 0.2, color: 'red' },       // 20% of tables
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Ratio of tables with > 10% dead tuples. Run VACUUM on these tables.'
      ),

    // Oldest vacuum age
    oldestVacuum:
      signals.maintenance.oldestVacuum.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.standardOptions.withUnit('s')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 604800, color: 'yellow' },  // 7 days
        { value: 1209600, color: 'red' },  // 14 days
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Time since oldest table was vacuumed. > 7 days is warning.'
      ),

    // Dead tuple ratio by table
    deadTupleRatio:
      signals.maintenance.deadTupleRatio.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.color.withMode('thresholds')
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.05, color: 'yellow' },
        { value: 0.1, color: 'orange' },
        { value: 0.2, color: 'red' },
      ])
      + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('line')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Dead tuple ratio per table. > 10% needs VACUUM.'
      ),

    // Table vacuum status - dead tuple ratio + last vacuum time
    tableVacuumStatus:
      g.panel.table.new('Table Vacuum Status')
      + g.panel.table.panelOptions.withDescription(
        'Tables with dead tuple ratio and time since last vacuum. Sort by dead tuple ratio to find tables needing VACUUM.'
      )
      + signals.maintenance.deadTupleRatio.asTableColumn(override='byName', format='table')
      + signals.maintenance.lastVacuumAge.asTableColumn(override='byName', format='table')
      + g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('merge'),
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            pattern: '^(?!Time).*$',
          },
        }),
        g.panel.table.queryOptions.transformation.withId('organize')
        + g.panel.table.queryOptions.transformation.withOptions({
          excludeByName: {
            job: true,
            instance: true,
            cluster: true,
          },
          renameByName: {
            schemaname: 'Schema',
            relname: 'Table',
            'Value #Dead tuple ratio': 'Dead Tuple Ratio',
            'Value #Last vacuum age': 'Last Vacuum Age',
          },
        }),
        commonlib.panels.generic.table.base.transformations.sortBy('Dead Tuple Ratio', desc=true),
      ])
      + g.panel.table.standardOptions.withOverrides([
        g.panel.table.fieldOverride.byName.new('Dead Tuple Ratio')
        + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withUnit('percentunit')
          + g.panel.table.standardOptions.color.withMode('thresholds')
          + g.panel.table.standardOptions.thresholds.withSteps([
            { value: 0, color: 'green' },
            { value: 0.05, color: 'yellow' },
            { value: 0.1, color: 'orange' },
            { value: 0.2, color: 'red' },
          ])
        )
        + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' }),
        g.panel.table.fieldOverride.byName.new('Last Vacuum Age')
        + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withUnit('dtdhms')
          + g.panel.table.standardOptions.color.withMode('thresholds')
          + g.panel.table.standardOptions.thresholds.withSteps([
            { value: 0, color: 'green' },
            { value: 86400, color: 'yellow' },    // 1 day in seconds
            { value: 604800, color: 'red' },      // 7 days in seconds
          ])
          + g.panel.table.standardOptions.withMappings([
            {
              type: 'special',
              options: {
                match: 'null',
                result: { text: 'Never', color: 'red' },
              },
            },
            {
              type: 'special',
              options: {
                match: 'nan',
                result: { text: 'Never', color: 'red' },
              },
            },
          ])
        )
        + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' }),
      ]),

    // Sequential scan ratio - using stat instead of gauge
    sequentialScanRatio:
      signals.maintenance.sequentialScanRatio.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.standardOptions.withUnit('percentunit')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.2, color: 'yellow' },
        { value: 0.4, color: 'orange' },
        { value: 0.6, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Ratio of seq scans to total. High values indicate missing indexes.'
      ),

    // Unused indexes count
    unusedIndexes:
      signals.maintenance.unusedIndexes.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 5, color: 'yellow' },
        { value: 10, color: 'orange' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Indexes with zero scans. Candidates for removal.'
      ),

    // Unused indexes table
    unusedIndexesTable:
      g.panel.table.new('Unused Indexes')
      + g.panel.table.panelOptions.withDescription(
        'Indexes with zero buffer hits and disk reads since stats reset. Candidates for removal to save disk space.'
      )
      + g.panel.table.queryOptions.withTargets([
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: |||
            (
              (pg_statio_user_indexes_idx_blks_hit_total{job=~"$job",cluster=~"$cluster",instance=~"$instance"} == 0)
              and
              (pg_statio_user_indexes_idx_blks_read_total{job=~"$job",cluster=~"$cluster",instance=~"$instance"} == 0)
            )
          |||,
          format: 'table',
          instant: true,
          refId: 'UnusedIndexes',
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            names: ['schemaname', 'relname', 'indexrelname'],
          },
        }),
        g.panel.table.queryOptions.transformation.withId('organize')
        + g.panel.table.queryOptions.transformation.withOptions({
          renameByName: {
            schemaname: 'Schema',
            relname: 'Table',
            indexrelname: 'Index',
          },
          indexByName: {
            schemaname: 0,
            relname: 1,
            indexrelname: 2,
          },
        }),
        commonlib.panels.generic.table.base.transformations.sortBy('Index', desc=false),
      ]),

    // Database size
    databaseSize:
      signals.maintenance.databaseSize.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.withUnit('bytes'),

    // Database size over time
    databaseSizeTimeSeries:
      signals.maintenance.databaseSize.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('bytes'),

    // WAL size
    walSize:
      signals.maintenance.walSize.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.withUnit('bytes'),

    // Oldest analyze age
    oldestAnalyze:
      signals.maintenance.oldestAnalyze.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.withUnit('dtdhms')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 86400, color: 'yellow' },    // 1 day in seconds
        { value: 604800, color: 'orange' },   // 7 days in seconds
        { value: 1209600, color: 'red' },     // 14 days in seconds
      ])
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.panelOptions.withDescription(
        'Time since oldest table was last analyzed. Stale stats can lead to poor query plans.'
      ),

    // Table analyze status
    tableAnalyzeStatus:
      g.panel.table.new('Table Analyze Status')
      + g.panel.table.panelOptions.withDescription(
        'Tables with time since last analyze. Stale statistics can cause poor query plans.'
      )
      + signals.maintenance.lastAnalyzeAge.asTableColumn(override='byName', format='table')
      + g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            pattern: '^(?!Time).*$',
          },
        }),
        g.panel.table.queryOptions.transformation.withId('organize')
        + g.panel.table.queryOptions.transformation.withOptions({
          excludeByName: {
            job: true,
            instance: true,
            cluster: true,
          },
          renameByName: {
            schemaname: 'Schema',
            relname: 'Table',
            Value: 'Last Analyze Age',
          },
          indexByName: {
            schemaname: 0,
            relname: 1,
            Value: 2,
          },
        }),
        commonlib.panels.generic.table.base.transformations.sortBy('Last Analyze Age', desc=true),
      ])
      + g.panel.table.standardOptions.withOverrides([
        g.panel.table.fieldOverride.byName.new('Last Analyze Age')
        + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withUnit('dtdhms')
          + g.panel.table.standardOptions.color.withMode('thresholds')
          + g.panel.table.standardOptions.thresholds.withSteps([
            { value: 0, color: 'green' },
            { value: 86400, color: 'yellow' },    // 1 day in seconds
            { value: 604800, color: 'orange' },   // 7 days in seconds
            { value: 1209600, color: 'red' },     // 14 days in seconds
          ])
          + g.panel.table.standardOptions.withMappings([
            {
              type: 'special',
              options: {
                match: 'null',
                result: { text: 'Never', color: 'red' },
              },
            },
            {
              type: 'special',
              options: {
                match: 'nan',
                result: { text: 'Never', color: 'red' },
              },
            },
          ])
        )
        + g.panel.table.fieldOverride.byName.withProperty('custom.cellOptions', { type: 'color-text' }),
      ]),
  },
}
