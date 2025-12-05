local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals):: {
    // Top queries by time consumption rate
    topQueriesByTotalTime:
      signals.queries.topQueriesByTotalTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + g.panel.timeSeries.panelOptions.withTitle('Query time consumption rate')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Execution time consumption rate per query. Higher values = more resource usage.'
      ),

    // Slowest queries by mean time
    slowestQueriesByMeanTime:
      signals.queries.slowestQueriesByMeanTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Average execution time per call. Higher values = slower queries.'
      ),

    // Most frequent queries
    mostFrequentQueries:
      signals.queries.mostFrequentQueries.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Query execution rate. High-frequency queries may benefit from caching.'
      ),

    // Top queries by rows
    topQueriesByRows:
      signals.queries.topQueriesByRows.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('rows/s')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Rows returned per query. High values may indicate missing WHERE/LIMIT clauses.'
      ),

    // Combined table view
    queryStatsTable:
      g.panel.table.new('Query Statistics')
      + g.panel.table.panelOptions.withDescription(
        'Query statistics from pg_stat_statements. Sort by Time/s for current impact, Avg Time for slow queries.'
      )
      + g.panel.table.options.withSortBy([
        { desc: true, displayName: 'Time/s' },
      ])
      + g.panel.table.queryOptions.withTargets([
        // Use seconds_total as the base - all queries derive from it
        // This ensures consistent row matching in merge
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: 'rate(pg_stat_statements_seconds_total{job=~"$job",cluster=~"$cluster",instance=~"$instance"}[$__rate_interval])',
          format: 'table',
          instant: true,
          refId: 'TimeRate',
        },
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: 'rate(pg_stat_statements_calls_total{job=~"$job",cluster=~"$cluster",instance=~"$instance"}[$__rate_interval])',
          format: 'table',
          instant: true,
          refId: 'CallsRate',
        },
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: 'pg_stat_statements_seconds_total{job=~"$job",cluster=~"$cluster",instance=~"$instance"} / (pg_stat_statements_calls_total{job=~"$job",cluster=~"$cluster",instance=~"$instance"} + 1)',
          format: 'table',
          instant: true,
          refId: 'MeanTime',
        },
        {
          datasource: { type: 'prometheus', uid: '${datasource}' },
          expr: 'pg_stat_statements_seconds_total{job=~"$job",cluster=~"$cluster",instance=~"$instance"}',
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
            'Value #MeanTime': 'Avg Time',
            'Value #TotalTime': 'Total Time',
          },
          indexByName: {
            queryid: 0,
            datname: 1,
            user: 2,
            'Value #TimeRate': 3,
            'Value #CallsRate': 4,
            'Value #MeanTime': 5,
            'Value #TotalTime': 6,
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
