local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local lokiQuery = g.query.loki;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,

    lokiQuery1:
      lokiQuery.new(
        '${' + vars.datasources.loki.name + '}',
        '{%(queriesSelector)s, level=~"error|Error"} |= "searchstring"' % vars
      ),
    uptime1:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'uptime{%(queriesSelector)s}*1000 > $__from < $__to' % vars
      ),
    metric1:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'metric1{%(queriesSelector)s}' % vars
      ),
    metric2:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'metric2{%(queriesSelector)s}' % vars
      ),
    metric3:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        '100 - (avg without (mode,core) (rate(metric3{mode="idle", %(queriesSelector)s}[$__rate_interval])*100))' % vars
      )
      + prometheusQuery.withLegendFormat('CPU usage'),

    // add more metrics or loki queries as targets below:

  },
}
