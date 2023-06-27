local logs = import 'lib/logs/main.libsonnet';
local utils = import 'utils.libsonnet';

{

  _config+:: {

    //Additional selector to add to all variable queries and alerts(if any)
    kubeFilterSelector: 'namespace!=""',
    // Array of labels to compose chained grafana variables (order matters)
    kubeLabels: ['cluster', 'namespace', 'app', 'pod', 'container'],

    // Array of labels to compose chained grafana variables
    linuxFilterSelector: 'unit!=""',
    linuxLabels: ['job', 'instance', 'unit', 'level'],

    // Array of labels to compose chained grafana variables
    dockerFilterSelector: 'container_name!=""',
    dockerLabels: ['job', 'instance', 'container_name'],

    // pick one of Loki's parsers to use: i.e. logfmt, json.
    // | __error__=`` is appended automatically
    // https://grafana.com/docs/loki/latest/logql/log_queries/#parser-expression
    formatParser: 'logfmt',

  },
  grafanaDashboards+:: {

    'kube.json': (
      logs.new('Kubernetes apps',
               datasourceRegex='',
               filterSelector=$._config.kubeFilterSelector,
               labels=$._config.kubeLabels,
               formatParser=$._config.formatParser)
    ).dashboard,

    'systemd.json': (
      logs.new('Linux systemd',
               datasourceRegex='',
               filterSelector=$._config.linuxFilterSelector,
               labels=$._config.linuxLabels,
               formatParser='unpack')
    ).dashboard,

    'docker.json': (
      logs.new('Docker',
               datasourceRegex='',
               filterSelector=$._config.dockerFilterSelector,
               labels=$._config.dockerLabels,
               formatParser='logfmt')
    ).dashboard,
  },
}