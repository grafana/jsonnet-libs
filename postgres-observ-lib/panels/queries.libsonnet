local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals):: {
    local queriesSelector = signals.queries.templatingVariables.queriesSelector,

    // Legend sorted by last value descending
    local legendSortedByValue =
      g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('bottom')
      + g.panel.timeSeries.options.legend.withCalcs(['lastNotNull'])
      + g.panel.timeSeries.options.legend.withSortBy('Last *')
      + g.panel.timeSeries.options.legend.withSortDesc(true),

    topQueriesByTotalTime:
      signals.queries.topQueriesByTotalTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + legendSortedByValue
      + g.panel.timeSeries.panelOptions.withTitle('Query time consumption rate')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Execution time consumption rate per query. Higher values = more resource usage.'
      ),

    slowestQueriesByMeanTime:
      signals.queries.slowestQueriesByMeanTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + legendSortedByValue
      + g.panel.timeSeries.panelOptions.withDescription(
        'Average execution time per call. Higher values = slower queries.'
      ),

    mostFrequentQueries:
      signals.queries.mostFrequentQueries.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + legendSortedByValue
      + g.panel.timeSeries.panelOptions.withDescription(
        'Query execution rate. High-frequency queries may benefit from caching.'
      ),

    topQueriesByRows:
      signals.queries.topQueriesByRows.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('rows/s')
      + legendSortedByValue
      + g.panel.timeSeries.panelOptions.withDescription(
        'Rows returned per query. High values may indicate missing WHERE/LIMIT clauses.'
      ),

    // Combined table view - shows all queries, independent of topk variable
    // Users can sort by any column to find queries of interest
    queryStatsTable:
      g.panel.table.new('Query Statistics')
      + g.panel.table.panelOptions.withDescription(
        'Query statistics from pg_stat_statements. Shows all queries - sort by any column to analyze.'
      )
      + g.panel.table.options.withSortBy([
        { desc: true, displayName: 'Time/s' },
      ])
      + g.panel.table.queryOptions.withTargets([
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: std.format('rate(pg_stat_statements_seconds_total{%(queriesSelector)s}[$__rate_interval])', { queriesSelector: queriesSelector }),
          format: 'table',
          instant: true,
          refId: 'TimeRate',
        },
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: std.format('rate(pg_stat_statements_calls_total{%(queriesSelector)s}[$__rate_interval])', { queriesSelector: queriesSelector }),
          format: 'table',
          instant: true,
          refId: 'CallsRate',
        },
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: std.format('rate(pg_stat_statements_rows_total{%(queriesSelector)s}[$__rate_interval])', { queriesSelector: queriesSelector }),
          format: 'table',
          instant: true,
          refId: 'RowsRate',
        },
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: std.format('pg_stat_statements_seconds_total{%(queriesSelector)s} / (pg_stat_statements_calls_total{%(queriesSelector)s} + 1)', { queriesSelector: queriesSelector }),
          format: 'table',
          instant: true,
          refId: 'MeanTime',
        },
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: std.format('pg_stat_statements_seconds_total{%(queriesSelector)s}', { queriesSelector: queriesSelector }),
          format: 'table',
          instant: true,
          refId: 'TotalTime',
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('merge'),
        g.panel.table.queryOptions.transformation.withId('organize')
        + g.panel.table.queryOptions.transformation.withOptions({
          excludeByName: {
            Time: true,
            'Time 1': true,
            'Time 2': true,
            'Time 3': true,
            'Time 4': true,
            'Time 5': true,
            'Time 6': true,
            job: true,
            instance: true,
            cluster: true,
            __name__: true,
            server_id: true,
            environment: true,
          },
          renameByName: {
            queryid: 'Query ID',
            datname: 'Database',
            user: 'User',
            'Value #TimeRate': 'Time/s',
            'Value #CallsRate': 'Calls/s',
            'Value #RowsRate': 'Rows/s',
            'Value #MeanTime': 'Avg Time',
            'Value #TotalTime': 'Total Time',
          },
          indexByName: {
            queryid: 0,
            datname: 1,
            user: 2,
            'Value #TimeRate': 3,
            'Value #CallsRate': 4,
            'Value #RowsRate': 5,
            'Value #MeanTime': 6,
            'Value #TotalTime': 7,
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
          matcher: { id: 'byName', options: 'Avg Time' },
          properties: [
            { id: 'unit', value: 's' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Total Time' },
          properties: [
            { id: 'unit', value: 's' },
          ],
        },
      ]),
  },
}
