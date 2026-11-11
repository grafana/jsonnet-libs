local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config):: {
    // Legend sorted by last value descending with stats
    local legendSortedByValue =
      g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withCalcs(['lastNotNull', 'min', 'max', 'mean'])
      + g.panel.timeSeries.options.legend.withSortBy('Last *')
      + g.panel.timeSeries.options.legend.withSortDesc(true),

    topQueriesByTotalTime:
      signals.queries.topQueriesByTotalTime.withUnit('s').withTopK('$topk').asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + legendSortedByValue
      + g.panel.timeSeries.panelOptions.withTitle('Query time consumption rate')
      + g.panel.timeSeries.panelOptions.withDescription(
        "Execution time consumption rate per query. Higher values = more resource usage. Run `SELECT query FROM pg_stat_statements WHERE queryid = <query-id>` to see a query's SQL."
      ),

    slowestQueriesByMeanTime:
      signals.queries.slowestQueriesByMeanTime.withTopK('$topk').asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + legendSortedByValue
      + g.panel.timeSeries.panelOptions.withDescription(
        "Average execution time per call. Higher values = slower queries. Run `SELECT query FROM pg_stat_statements WHERE queryid = <query-id>` to see a query's SQL."
      ),

    mostFrequentQueries:
      signals.queries.mostFrequentQueries.withTopK('$topk').asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + legendSortedByValue
      + g.panel.timeSeries.panelOptions.withDescription(
        "Query execution rate. High-frequency queries may benefit from caching. Run `SELECT query FROM pg_stat_statements WHERE queryid = <query-id>` to see a query's SQL."
      ),

    topQueriesByRows:
      signals.queries.topQueriesByRows.withTopK('$topk').asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('rows/s')
      + legendSortedByValue
      + g.panel.timeSeries.panelOptions.withDescription(
        "Rows returned per query. High values may indicate missing WHERE/LIMIT clauses. Run `SELECT query FROM pg_stat_statements WHERE queryid = <query-id>` to see a query's SQL."
      ),

    // Combined table view - shows all queries, independent of topk variable
    // Users can sort by any column to find queries of interest
    queryStatsTable:
      signals.queries.topQueriesByTotalTime.withUnit('s').asTable(name='Query statistics')
      + signals.queries.mostFrequentQueries.asTableColumn()
      + signals.queries.topQueriesByRows.asTableColumn()
      + signals.queries.slowestQueriesByMeanTime.asTableColumn()
      + signals.queries.queryTotalTime.asTableColumn()
      + g.panel.table.panelOptions.withDescription(
        "Query statistics from pg_stat_statements. Shows all queries - sort by any column to analyze. Run `SELECT query FROM pg_stat_statements WHERE queryid = <query-id>` to see a query's SQL."
      )
      + g.panel.table.options.withSortBy([
        { desc: true, displayName: 'Time/s' },
      ])
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
          excludeByName: { [label]: true for label in config.groupLabels + config.instanceLabels },
          renameByName: {
            queryid: 'Query ID',
            datname: 'Database',
            user: 'User',
            ['Value #' + signals.queries.topQueriesByTotalTime.signalName]: 'Time/s',
            ['Value #' + signals.queries.mostFrequentQueries.signalName]: 'Calls/s',
            ['Value #' + signals.queries.topQueriesByRows.signalName]: 'Rows/s',
            ['Value #' + signals.queries.slowestQueriesByMeanTime.signalName]: 'Avg time',
            ['Value #' + signals.queries.queryTotalTime.signalName]: 'Total time',
          },
          indexByName: {
            queryid: 0,
            datname: 1,
            user: 2,
            ['Value #' + signals.queries.topQueriesByTotalTime.signalName]: 3,
            ['Value #' + signals.queries.mostFrequentQueries.signalName]: 4,
            ['Value #' + signals.queries.topQueriesByRows.signalName]: 5,
            ['Value #' + signals.queries.slowestQueriesByMeanTime.signalName]: 6,
            ['Value #' + signals.queries.queryTotalTime.signalName]: 7,
          },
        }),
        g.panel.table.queryOptions.transformation.withId('sortBy')
        + g.panel.table.queryOptions.transformation.withOptions({
          fields: {},
          sort: [{ field: 'Time/s', desc: true }],
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: { id: 'byName', options: 'Time/s' },
          properties: [
            { id: 'unit', value: 's' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Calls/s' },
          properties: [
            { id: 'unit', value: 'ops' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Rows/s' },
          properties: [
            { id: 'unit', value: 'rows/s' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Avg time' },
          properties: [
            { id: 'unit', value: 's' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Total time' },
          properties: [
            { id: 'unit', value: 's' },
          ],
        },
      ]),
  },
}
