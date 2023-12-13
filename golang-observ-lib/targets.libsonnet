local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local prometheusQuery = g.query.prometheus;
local lokiQuery = g.query.loki;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,

    'group:go_memstats_sys_bytes:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_memstats_sys_bytes{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),
    'group:go_memstats_stack_sys_bytes:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_memstats_stack_sys_bytes{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s stack inuse (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_memstats_mspan_sys_bytes:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_memstats_mspan_sys_bytes{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s mspan (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_memstats_mcache_sys_bytes:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_memstats_mcache_sys_bytes{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s mcache (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_memstats_buck_hash_sys_bytes:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_memstats_buck_hash_sys_bytes{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s mbuck hash (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_memstats_gc_sys_bytes:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_memstats_gc_sys_bytes{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s gc (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_memstats_heap_sys_bytes:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_memstats_heap_sys_bytes{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s heap reserved (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_memstats_heap_inuse_bytes:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_memstats_heap_inuse_bytes{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s heap in use (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_memstats_alloc_bytes:avg_rate':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (rate(go_memstats_alloc_bytes_total{%(queriesSelector)s}[$__rate_interval]))' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s bytes malloced/s (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_memstats_mallocs:avg_rate':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (rate(go_memstats_mallocs_total{%(queriesSelector)s}[$__rate_interval]))' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s obj mallocs/s (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_goroutines:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_goroutines{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s goroutine count (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_gc_duration_seconds:avg_min':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_gc_duration_seconds{quantile="0", %(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s min gc time (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),
    'group:go_gc_duration_seconds:avg_max':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_gc_duration_seconds{quantile="1", %(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s max gc time (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),

    'group:go_memstats_next_gc_bytes:avg':
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (%(agg)s) (go_gc_duration_seconds{%(queriesSelector)s})' % (vars { agg: std.join(',', this.config.groupLabels) })
      )
      + prometheusQuery.withLegendFormat('%s next gc bytes (avg)' % commonlib.utils.labelsToPanelLegend(this.config.groupLabels)),


  },
}
