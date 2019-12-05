local g = (import 'grafana-builder/grafana.libsonnet');

{
  dashboards+: {
    'memcached.json':
      g.dashboard('Memcached')
      .addMultiTemplate('cluster', 'kube_pod_container_info{image=~".*memcached.*"}', 'cluster')
      .addMultiTemplate('namespace', 'kube_pod_container_info{image=~".*memcached.*"}', 'namespace')
      .addMultiTemplate('instance', 'kube_pod_container_info{image=~".*memcached.*", namespace=~"$namespace"}', 'pod')
      .addRow(
        g.row('Hits')
        .addPanel(
          g.panel('Hit Rate') +
          g.queryPanel('sum(rate(memcached_commands_total{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance", command="get", status="hit"}[1m])) / sum(rate(memcached_commands_total{cluster=~"$cluster", job=~"($namespace)/($name)", command="get"}[1m]))', 'Hit Rate') +
          { yaxes: g.yaxes('percentunit') },
        )
      )
      .addRow(
        g.row('Ops')
        .addPanel(
          g.panel('Commands') +
          g.queryPanel('sum without (job, instance) (rate(memcached_commands_total{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"}[1m]))', '{{command}} {{status}}')
        )
        .addPanel(
          g.panel('Evictions') +
          g.queryPanel('sum without (job) (rate(memcached_items_evicted_total{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"}[1m]))', '{{instance}}')
        )
        .addPanel(
          g.panel('Stored') +
          g.queryPanel('sum without (job) (rate(memcached_items_total{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"}[1m]))', '{{instance}}')
        )
      )
      .addRow(
        g.row('Memory')
        .addPanel(
          g.panel('Memory') +
          g.queryPanel('sum without (job) (memcached_current_bytes{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"})', '{{instance}}') +
          g.stack +
          { yaxes: g.yaxes('bytes') },
          // TODO add memcached_limit_bytes
        )
        .addPanel(
          g.panel('Items') +
          g.queryPanel('sum without (job) (memcached_current_items{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"})', '{{instance}}') +
          g.stack,
        )
      )
      .addRow(
        g.row('Network')
        .addPanel(
          g.panel('Connections') +
          g.queryPanel([
            'sum without (job) (rate(memcached_connections_total{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"}[1m]))',
            'sum without (job) (memcached_current_connections{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"})',
            'sum without (job) (memcached_max_connections{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"})',
          ], [
            '{{instance}} - Connection Rate',
            '{{instance}} - Current Connrections',
            '{{instance}} - Max Connections',
          ])
        )
        .addPanel(
          g.panel('Reads') +
          g.queryPanel('sum without (job) (rate(memcached_read_bytes_total{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"}[1m]))', '{{instance}}') +
          { yaxes: g.yaxes('bps') },
        )
        .addPanel(
          g.panel('Writes') +
          g.queryPanel('sum without (job) (rate(memcached_written_bytes_total{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"}[1m]))', '{{instance}}') +
          { yaxes: g.yaxes('bps') },
        )
      )
      .addRow(
        g.row('Memcached Info')
        .addPanel(
          g.panel('Memcached Info') +
          g.tablePanel([
            'count by (job, instance, version) (memcached_version{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"})',
            'max by (job, instance) (memcached_uptime_seconds{cluster=~"$cluster", job=~"($namespace)/($name)", instance=~"$instance"})',
          ], {
            job: { alias: 'Job' },
            instance: { alias: 'Instance' },
            version: { alias: 'Version' },
            'Value #A': { alias: 'Count', type: 'hidden' },
            'Value #B': { alias: 'Uptime', type: 'number', unit: 'dtdurations' },
          })
        )
      ) +
      {
        templating+: {
          list+: [
            {
              allValue: null,
              current: {
                text: 'All',
                value: '$__all',
              },
              datasource: '$datasource',
              hide: 0,
              includeAll: true,
              label: 'name',
              multi: true,
              name: 'name',
              options: [],
              query: 'query_result(max by(job) (memcached_commands_total))',
              refresh: 1,
              regex: '/job=\\".*\\/(.*)\\"/',
              sort: 2,
              tagValuesQuery: '',
              tags: [],
              tagsQuery: '',
              type: 'query',
              useTags: false,
            },
          ],
        },
      },
  },
}
