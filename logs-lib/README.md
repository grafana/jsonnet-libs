# Logs lib

This logs lib can be used to generate logs dashboard using [grafonnet](https://github.com/grafana/grafonnet).

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/logs-lib
```

## Examples

### Generate kubernetes logs dashboard

```jsonnet
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
{

  _config+:: {

    //Additional selector to add to all variable queries and alerts(if any)
    kubeFilterSelector: 'namespace!=""',
    // Array of labels to compose chained grafana variables (order matters)
    kubeLabels: ['cluster', 'namespace', 'app', 'pod', 'container'],

    // pick one of Loki's parsers to use: i.e. logfmt, json.
    // | __error__=`` is appended automatically
    // https://grafana.com/docs/loki/latest/logql/log_queries/#parser-expression
    formatParser: 'logfmt',

  },
  grafanaDashboards+:: {

    // 1. create and export kubernetes logs dashboard
    'kube.json': (
      logsDashboard.new('Kubernetes apps logs',
               datasourceRegex='',
               filterSelector=$._config.kubeFilterSelector,
               labels=$._config.kubeLabels,
               formatParser=$._config.formatParser)
    ).dashboards.logs,
  },
}
```

![image](https://github.com/grafana/jsonnet-libs/assets/14870891/7b246cc9-5de1-42f5-b3cd-bb9f89302405)

### Generate systemd logs dashboard and modify panels and variables

This lib exposes `variables`, `targets`, `panels`, and `dashboards`.

Because of that, you can override options of those objects before exporting the dashboard.

Again, use [Grafonnet](https://grafana.github.io/grafonnet/API/panel/index.html) for this:

```jsonnet

local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';

{

  _config+:: {

    // Array of labels to compose chained grafana variables
    linuxFilterSelector: 'unit!=""',
    linuxLabels: ['job', 'instance', 'unit', 'level'],

    // pick one of Loki's parsers to use: i.e. logfmt, json.
    // | __error__=`` is appended automatically
    // https://grafana.com/docs/loki/latest/logql/log_queries/#parser-expression
    formatParser: 'unpack',

  },
  grafanaDashboards+:: {

    // 2. create and export systemd logs dashboard
    local systemdLogs =
      logsDashboard.new('Linux systemd logs',
               datasourceRegex='',
               filterSelector=$._config.linuxFilterSelector,
               labels=$._config.linuxLabels,
               formatParser=$._config.formatParser,
               showLogsVolume=true)
      // override panels or variables using grafonnet
      {
        panels+:
          {
            logs+:
              g.panel.logs.options.withEnableLogDetails(false),
          },
        variables+:
          {
            regex_search+:
              g.dashboard.variable.textbox.new('regex_search', default='error'),
          },
      },
    // export logs dashboard
    'systemd.json': systemdLogs.dashboards.logs,
  },
}
```

![image](https://github.com/grafana/jsonnet-libs/assets/14870891/5e6313fd-9135-446a-b7bf-cf124b436970)

### Generate docker logs dashboard

```jsonnet

local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
{

  _config+:: {

    // Array of labels to compose chained grafana variables
    dockerFilterSelector: 'container_name!=""',
    dockerLabels: ['job', 'instance', 'container_name'],

    // pick one of Loki's parsers to use: i.e. logfmt, json.
    // | __error__=`` is appended automatically
    // https://grafana.com/docs/loki/latest/logql/log_queries/#parser-expression
    formatParser: 'logfmt',

  },
  grafanaDashboards+:: {

    // 3. create and export kubernetes logs dashboard
    'docker.json': (
      logsDashboard.new('Docker logs',
               datasourceRegex='',
               filterSelector=$._config.dockerFilterSelector,
               labels=$._config.dockerLabels,
               formatParser=$._config.formatParser)
    ).dashboards.logs,
  },
}

```
