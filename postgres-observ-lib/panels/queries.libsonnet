// Tier 5: Query Analysis Panels
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
        |||
          Rate of execution time consumption per second for each query.
          
          Shows how much CPU/execution time each query is currently consuming.
          Higher values indicate queries that are actively using more resources.
          
          Formula: rate(pg_stat_statements_seconds_total[$__rate_interval])
          
          Use this to identify queries that are currently impacting performance.
        |||
      ),

    // Slowest queries by mean time
    slowestQueriesByMeanTime:
      signals.queries.slowestQueriesByMeanTime.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('s')
      + g.panel.timeSeries.panelOptions.withDescription(
        |||
          Average execution time per call for each query.
          
          Shows how long each query takes on average when executed.
          Higher values indicate slow individual query executions.
          
          Formula: total_time / calls
          
          Use this to find queries that need optimization (slow but maybe not called often).
        |||
      ),

    // Most frequent queries
    mostFrequentQueries:
      signals.queries.mostFrequentQueries.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withDescription(
        |||
          Rate of query executions per second.
          
          Shows how often each query is being called.
          High-frequency queries are candidates for caching or connection pooling.
          
          Formula: rate(pg_stat_statements_calls_total[$__rate_interval])
        |||
      ),

    // Top queries by rows
    topQueriesByRows:
      signals.queries.topQueriesByRows.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('rows/s')
      + g.panel.timeSeries.panelOptions.withDescription(
        |||
          Rate of rows returned/affected per second for each query.
          
          High values may indicate:
          - Missing WHERE clauses (full table scans)
          - Missing LIMIT clauses
          - Inefficient joins returning too many rows
          
          Formula: rate(pg_stat_statements_rows_total[$__rate_interval])
        |||
      ),

    // Combined table view
    queryStatsTable:
      g.panel.table.new('Query Statistics')
      + g.panel.table.panelOptions.withDescription(
        |||
          Comprehensive query performance statistics from pg_stat_statements.
          
          Columns explained:
          • Time/s: Execution time rate (seconds of query time per second) - matches "Query time consumption rate" graph
          • Calls/s: Call rate (queries per second) - matches "Most frequent queries" graph
          • Avg Time: Average time per call (total_time / calls) - matches "Slowest queries" graph
          • Total Time: Cumulative execution time since stats reset
          
          Sort by Time/s to find currently impactful queries.
          Sort by Avg Time to find slow individual queries.
        |||
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
            { id: 'description', value: 'Execution time rate (seconds consumed per second). Higher = more current load. Matches "Query time consumption rate" graph.' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Calls/s' },
          properties: [
            { id: 'unit', value: 'ops' },
            { id: 'description', value: 'Call rate (executions per second). Higher = more frequently called. Matches "Most frequent queries" graph.' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Avg Time' },
          properties: [
            { id: 'unit', value: 's' },
            { id: 'description', value: 'Average execution time per call (total_time / calls). Higher = slower query. Matches "Slowest queries" graph.' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Total Time' },
          properties: [
            { id: 'unit', value: 's' },
            { id: 'description', value: 'Cumulative execution time since pg_stat_statements was reset.' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Query ID' },
          properties: [
            { id: 'description', value: 'Unique query identifier from pg_stat_statements. Use this to find the actual query text in the database.' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Database' },
          properties: [
            { id: 'description', value: 'Database where the query was executed.' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'User' },
          properties: [
            { id: 'description', value: 'PostgreSQL user who executed the query.' },
          ],
        },
      ]),
  },
}
