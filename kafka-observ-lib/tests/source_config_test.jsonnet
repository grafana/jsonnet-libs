// Exercise generated Kafka alerts for every supported exporter, both as a string
// and an array. Bitnami has no election source and uses the Prometheus fallback.
local kafka = import '../main.libsonnet';
local grafana = 'sum by (kafka_cluster,instance) (increase(kafka_controller_controllerstats_uncleanleaderelectionspersec{job="kafka"}[10m]))';
local prometheus = 'sum by (kafka_cluster,instance) (increase(kafka_controller_controllerstats_uncleanleaderelections_total{job="kafka"}[10m]))';
local cases = [
  { source: 'prometheus', expected: [prometheus] },
  { source: 'bitnami', expected: [prometheus] },
  { source: 'grafanacloud', expected: [grafana] },
  { source: ['prometheus'], expected: [prometheus] },
  { source: ['bitnami'], expected: [prometheus] },
  { source: ['grafanacloud'], expected: [grafana] },
  { source: ['prometheus', 'bitnami'], expected: [prometheus] },
  { source: ['bitnami', 'prometheus'], expected: [prometheus] },
  { source: ['bitnami', 'grafanacloud'], expected: [grafana, prometheus] },
  { source: ['grafanacloud', 'bitnami'], expected: [grafana, prometheus] },
  { source: ['prometheus', 'grafanacloud'], expected: [grafana, prometheus] },
  { source: ['grafanacloud', 'prometheus'], expected: [grafana, prometheus] },
  { source: ['prometheus', 'bitnami', 'grafanacloud'], expected: [grafana, prometheus] },
  { source: ['bitnami', 'grafanacloud', 'prometheus'], expected: [grafana, prometheus] },
  { source: ['grafanacloud', 'prometheus', 'bitnami'], expected: [grafana, prometheus] },
  { source: ['bitnami', 'bitnami'], expected: [prometheus] },
];
local electionExpr(source) =
  local config = kafka.withConfigMixin({
    metricsSource: source,
    filteringSelector: 'job="kafka"',
    zookeeperEnabled: false,
  });
  local alerts = (kafka.new() + config).prometheus.alerts.groups[0].rules;
  [rule.expr for rule in alerts if rule.alert == 'KafkaUncleanLeaderElection'][0];
assert std.foldl(
  function(ok, c)
    if electionExpr(c.source) == '(%s) != 0' % std.join('\nor\n', c.expected) then ok
    else error 'Incorrect election alert for %s: %s' % [std.toString(c.source), electionExpr(c.source)],
  cases,
  true
);
'Kafka metricsSource generation: OK'
