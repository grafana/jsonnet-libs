# Status panels lib

This status panels lib can be used to add a status panel row for integration dashboards using [grafonnet](https://github.com/grafana/grafonnet).

The status panels provide the following information for an integration.

- Metrics status
  - Shows if the agent is sending metrics for this integration
  - Shows the latest timestamp the metrics were received for this integration
- Logs status
  - Shows if the agent is sending logs for this integration
  - Shows the latest timestamp the logs were received for this integration
- Integration version
  - Shows the current installed version of the integration

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/status-panels-lib
```

# Usage

## Metrics

```
(statusPanels.new(
  'Integration Status',
  type='metrics',
  statusPanelsQueryMetrics='up{job=~"$job"}',
  datasourceNameMetrics='$prometheus_datasource',
  showIntegrationVersion=true,
  integrationVersion='x.x.x',
  panelsHeight=2,
  panelsWidth=8,
  rowPositionY=10,
)).panels.statusPanelsRow
```

## Logs

```
(statusPanels.new(
  'Integration Status',
  type='logs',
  statusPanelsQueryLogs='count_over_time{job=~"$job"}',
  datasourceNameLogs='$loki_datasource',
  showIntegrationVersion=true,
  integrationVersion='x.x.x',
  panelsHeight=2,
  panelsWidth=8,
  rowPositionY=10,
)).panels.statusPanelsRow
```

This will return a row with the status panels appended to it

## Options

### title

Title of the status panels row

### type

`metrics`, `logs` or `both` (Default `metrics`)
When using `metrics` provide `statusPanelsQueryMetrics` and `datasourceNameMetrics`
When using `logs` provide `statusPanelsQueryLogs` and `datasourceNameLogs`
When using `both` provide both metrics & logs query & data source names

### statusPanelsQueryMetrics

Query for checking the status of the integration (Should be the most commonly available metric which is almost always available like up{job="integrations/my-integration"})

### statusPanelsQueryLogs

Query for checking the status of the integration (Should be the most commonly available metric which is almost always available like count_over_time{job="integrations/my-integration"})

### datasourceNameMetrics

Name of the data source to be used with the query targets for metrics

### datasourceNameLogs

Name of the data source to be used with the query targets for logs

### showIntegrationVersion

Whether to show or hide the integration version panel (Default `true`)

### integrationVersion

Pass integration version in "x.x.x" format (Applicable if `showIntegrationVersion` is set to true)

### panelsHeight

Height of the status panels (Default `2`)

### panelsWidth

Width of the status panels (Default `8`)

### rowPositionY

Position (Default `0`)

## Sample Dashboard

`status-panel-dashboard.libsonnet`

```
local statusPanels = import '../status-panels/main.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-v10.0.0/main.libsonnet';

local dashboard = g.dashboard;
local title = 'Status Panel Example';

{
  grafanaDashboards+:: {
      'status-panel-example.json': dashboard.new(title)
        + dashboard.withUid(g.util.string.slugify(title))
        + dashboard.withPanels(
          (statusPanels.new(
            'Integration Status',
            type='metrics',
            statusPanelsQueryMetrics='up{job=~"$job"}',
            datasourceNameMetrics='$prometheus_datasource',
            showIntegrationVersion=true,
            integrationVersion='x.x.x',
            panelsHeight=2,
            panelsWidth=8,
            rowPositionY=10,
          )).panels.statusPanelsRow
        )
  }
}

```

### Screenshot

![Dashboard screenshot](https://github.com/grafana/jsonnet-libs/assets/17196882/7d9cecd0-861e-4ddf-aa85-df92cdf555bc)
