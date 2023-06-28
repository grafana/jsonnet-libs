local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
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

    // 1. create and export kubernetes logs dashboard
    'kube.json': (
      logs.new('Kubernetes apps',
               datasourceRegex='',
               filterSelector=$._config.kubeFilterSelector,
               labels=$._config.kubeLabels,
               formatParser=$._config.formatParser)
    ).dashboards.logs,

    // 2. create and export systemd logs dashboard
    local systemdLogs =
      logs.new('Linux systemd',
               datasourceRegex='',
               filterSelector=$._config.linuxFilterSelector,
               labels=$._config.linuxLabels,
               formatParser='unpack',
               showLogsVolume=true)
      // override panels or variables using grafonnet
      {
        panels+:
          {
            logs+:
              g.panel.logs.options.withEnableLogDetails(true),
          },
        variables+:
          {
            regex_search+:
              g.dashboard.variable.textbox.new('regex_search', default=''),
          },
      },
    // export logs dashboard
    'systemd.json': systemdLogs.dashboards.logs,

    // 3. create and export kubernetes logs dashboard
    'docker.json': (
      logs.new('Docker',
               datasourceRegex='',
               filterSelector=$._config.dockerFilterSelector,
               labels=$._config.dockerLabels,
               formatParser='logfmt')
    ).dashboards.logs,
  },
}
