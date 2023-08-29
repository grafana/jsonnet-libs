# Status panels lib

This status panels lib can be used to add a status panel row for integration dashboards using [grafonnet](https://github.com/grafana/grafonnet).

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
  type='metrics',
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
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

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

![Dashboard screenshot](example/status-panel-dashboard.png?raw=true "Optional Title")
