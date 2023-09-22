# Windows observ lib

This observ lib can be used to generate observ package for Windows.

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/windows-observ-lib
```

## Examples

### Basic example

You can use lib to fill in monitoring-mixin structure:

```jsonnet
// mixin.libsonnet file
local g = import './g.libsonnet';
local var = g.dashboard.variable;
local winlib = import './windows-observ-lib/main.libsonnet';
{
  // init lib
  local windows =
    winlib.new(
      dashboardNamePrefix=$._config.dashboardNamePrefix,
      uid=$._config.uid,
      filteringSelector=$._config.filteringSelector,
    )
    +
    // provide config to customize results
    {
      config+: (import 'config.libsonnet')._config,
    },
  
  // get alerts from package:
  prometheusAlerts+:: windows.alerts,
  
  // get dashboards from package, buy modify datasource regex filters first using grafonnet:
  grafanaDashboards+::
    (windows {
       variables+: {
         datasources+: {
           loki+: var.datasource.withRegex('Loki|.+logs'),
           prometheus+: var.datasource.withRegex('Prometheus|Cortex|Mimir|grafanacloud-.+-prom'),
         },
       },
     })
    .dashboards,
}

// config.libsonnet file

{
  _config+:: {
    // labels to group windows hosts:
    groupLabels: ['job'],
    // labels to identify single windows host:
    instanceLabels: ['instance'],
    // selector to include in all queries(including alerts)
    filteringSelector: 'job=~".*windows.*"',
    // prefix all dashboards uids and alert groups
    uid: 'windows',
    // prefix dashboards titles
    dashboardNamePrefix: '',
    dashboardTags: ['windows'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    alertsCPUThresholdWarning: '90',
    alertMemoryUsageThresholdCritical: '90',
    alertDiskUsageThresholdCritical: '90',
    // set to false to disable logs dashboard and logs annotations
    enableLokiLogs: true,
  },
}


```
Examples:
Fleet dashboard:
![image](https://github.com/grafana/jsonnet-libs/assets/14870891/b36b6245-643a-426f-9745-5437d93815ad)
Overview dashboard:
![image](https://github.com/grafana/jsonnet-libs/assets/14870891/723df88c-a789-4e73-a85e-724d9ea06cd2)
Logs dashboard:
![image](https://github.com/grafana/jsonnet-libs/assets/14870891/ec136706-96c1-4bc4-b608-f7184327d845)
Drill down disks dashboard:
![image](https://github.com/grafana/jsonnet-libs/assets/14870891/dfcda70d-4c2e-494f-b092-7d37a13d65d1)


## Collectors used:

Grafana Agent or combination of windows_exporter/promtail can be used in order to collect data required.

The following collectors should be enabled in windows_exporter/windows integration:

`enabled_collectors: cpu,cs,logical_disk,net,os,service,system,textfile,time,diskdrive`

### Logs collection

Loki logs are used to populate logs dashboard and also for quering annotations.

To opt-out, you can set `enableLokiLogs: false` in config. See example above

The following scrape snippet can be used:

```yaml
    - job_name: integrations/windows-exporter-application
        windows_events:
        use_incoming_timestamp: true
        bookmark_path: "C:\\Program Files\\Grafana Agent\\bookmarks-app.xml"
        eventlog_name: "Application"
        labels:
            job: integrations/windows_exporter
            instance: 'win-test' # must match instance used in windows_exporter
        relabel_configs:
        - source_labels: ['computer']
            target_label: 'agent_hostname'
        pipeline_stages:
        - json:
            expressions:
                source: source
                level: levelText
        - labels:
            source:
            level:
    # disable or enable depending on your requirements
    - job_name: integrations/windows-exporter-security
        windows_events:
        use_incoming_timestamp: true
        bookmark_path: "C:\\Program Files\\Grafana Agent\secsys.xml"
        eventlog_name: Security
        labels:
            job: integrations/windows_exporter
            instance: 'win-test' # must match instance used in windows_exporter
        relabel_configs:
        - source_labels: ['computer']
            target_label: 'agent_hostname'
        pipeline_stages:
        - json:
            expressions:
                source: source
                level: levelText
        - labels:
            source:
            level:
    - job_name: integrations/windows-exporter-system
        windows_events:
        use_incoming_timestamp: true
        bookmark_path: "C:\\Program Files\\Grafana Agent\\bookmarks-sys.xml"
        eventlog_name: "System"
        labels:
            job: integrations/windows_exporter
            instance: 'win-test' # must match instance used in windows_exporter
        relabel_configs:
        - source_labels: ['computer']
            target_label: 'agent_hostname'
        pipeline_stages:
        - json:
            expressions:
                source: source
                level: levelText
                keywords:
        - labels:
            source:
            level:
            keywords:
```
