local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local dashboardUid = 'clickhouse-replica';
local promDatasourceName = 'prometheus_datasource';
local getMatcher(cfg) = '%(clickhouseSelector)s' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local interserverConnectionsPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Number of connections due to interserver communication',
    fieldConfig: {
      defaults: {
        color: {
          mode: 'palette-classic',
        },
        custom: {
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 0,
          gradientMode: 'none',
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
          spanNulls: false,
          stacking: {
            group: 'A',
            mode: 'none',
          },
          thresholdsStyle: {
            mode: 'off',
          },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: null,
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
      },
      overrides: [],
    },
    options: {
      legend: {
        calcs: [],
        displayMode: 'list',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
    targets: [
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'ClickHouseMetrics_InterserverConnection{' + matcher + '}',
        legendFormat: '{instance} - interserver connections',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Interserver connections',
    type: 'timeseries',
  };
local replicaQueueSizePanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Number of replica tasks in queue',
    fieldConfig: {
      defaults: {
        color: {
          mode: 'palette-classic',
        },
        custom: {
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 0,
          gradientMode: 'none',
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
          spanNulls: false,
          stacking: {
            group: 'A',
            mode: 'none',
          },
          thresholdsStyle: {
            mode: 'off',
          },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: null,
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
      },
      overrides: [],
    },
    options: {
      legend: {
        calcs: [],
        displayMode: 'list',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
    targets: [
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'ClickHouseAsyncMetrics_ReplicasMaxQueueSize{' + matcher + '}',
        legendFormat: '{instance} - max queue size',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Replica queue size',
    type: 'timeseries',
  };
local replicaOperationsPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Replica Operations over time to other nodes',
    fieldConfig: {
      defaults: {
        color: {
          mode: 'palette-classic',
        },
        custom: {
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 0,
          gradientMode: 'none',
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
          spanNulls: false,
          stacking: {
            group: 'A',
            mode: 'none',
          },
          thresholdsStyle: {
            mode: 'off',
          },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: null,
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
        unit: '/ sec',
      },
      overrides: [],
    },
    options: {
      legend: {
        calcs: [],
        displayMode: 'list',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
    targets: [
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'rate(ClickHouseProfileEvents_ReplicatedPartFetches{' + matcher + '}[$__rate_interval])',
        legendFormat: '{instance} - part fetches',
        range: true,
        refId: 'A',
      },
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'rate(ClickHouseProfileEvents_ReplicatedPartMerges{' + matcher + '}[$__rate_interval])',
        hide: false,
        legendFormat: '{instance} - part merges',
        range: true,
        refId: 'B',
      },
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'rate(ClickHouseProfileEvents_ReplicatedPartMutations{' + matcher + '}[$__rate_interval])',
        hide: false,
        legendFormat: '{instance} - part mutations',
        range: true,
        refId: 'C',
      },
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'rate(ClickHouseProfileEvents_ReplicatedPartChecks{' + matcher + '}[$__rate_interval])',
        hide: false,
        legendFormat: '{instance} - part checks',
        range: true,
        refId: 'D',
      },
    ],
    title: 'Replica operations',
    type: 'timeseries',
  };
local replicaReadOnlyPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Shows replicas in read-only state over time',
    fieldConfig: {
      defaults: {
        color: {
          mode: 'palette-classic',
        },
        custom: {
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 0,
          gradientMode: 'none',
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
          spanNulls: false,
          stacking: {
            group: 'A',
            mode: 'none',
          },
          thresholdsStyle: {
            mode: 'off',
          },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: null,
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
      },
      overrides: [],
    },
    options: {
      legend: {
        calcs: [],
        displayMode: 'list',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
    targets: [
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'ClickHouseMetrics_ReadonlyReplica{' + matcher + '}',
        legendFormat: '{instance} - read only',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Replica read only',
    type: 'timeseries',
  };
local zooKeeperWatchesPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Current number of watches in ZooKeeper',
    fieldConfig: {
      defaults: {
        color: {
          mode: 'palette-classic',
        },
        custom: {
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 0,
          gradientMode: 'none',
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
          spanNulls: false,
          stacking: {
            group: 'A',
            mode: 'none',
          },
          thresholdsStyle: {
            mode: 'off',
          },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: null,
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
      },
      overrides: [],
    },
    options: {
      legend: {
        calcs: [],
        displayMode: 'list',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
    targets: [
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'ClickHouseMetrics_ZooKeeperWatch{' + matcher + '}',
        legendFormat: '{instance} - zookeeper watch',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Zookeeper watches',
    type: 'timeseries',
  };
local zooKeeperSessionsPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Current number of sessions to ZooKeeper',
    fieldConfig: {
      defaults: {
        color: {
          mode: 'palette-classic',
        },
        custom: {
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 0,
          gradientMode: 'none',
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
          spanNulls: false,
          stacking: {
            group: 'A',
            mode: 'none',
          },
          thresholdsStyle: {
            mode: 'off',
          },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: null,
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
      },
      overrides: [],
    },
    options: {
      legend: {
        calcs: [],
        displayMode: 'list',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
    targets: [
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'ClickHouseMetrics_ZooKeeperSession{' + matcher + '}',
        legendFormat: '{instance} - zookeeper session',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Zookeeper sessions',
    type: 'timeseries',
  };
local zooKeeperRequestsPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Current number of active requests to ZooKeeper',
    fieldConfig: {
      defaults: {
        color: {
          mode: 'palette-classic',
        },
        custom: {
          axisCenteredZero: false,
          axisColorMode: 'text',
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 0,
          gradientMode: 'none',
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
          spanNulls: false,
          stacking: {
            group: 'A',
            mode: 'none',
          },
          thresholdsStyle: {
            mode: 'off',
          },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'green',
              value: null,
            },
            {
              color: 'red',
              value: 80,
            },
          ],
        },
      },
      overrides: [],
    },
    options: {
      legend: {
        calcs: [],
        displayMode: 'list',
        placement: 'bottom',
        showLegend: true,
      },
      tooltip: {
        mode: 'single',
        sort: 'none',
      },
    },
    targets: [
      {
        datasource: promDatasource,
        editorMode: 'code',
        expr: 'ClickHouseMetrics_ZooKeeperRequest{' + matcher + '}',
        legendFormat: '{instance} - zookeeper request',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Zookeeper requests',
    type: 'timeseries',
  };
{
  grafanaDashboards+:: {

    'clickhouse-replica.json':
      dashboard.new(
        'ClickHouse replica',
        time_from='%s' % $._config.dashboardPeriod,
        editable=false,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        graphTooltip='shared_crosshair',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other ClickHouse dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      )).addTemplates(
        [
          template.datasource(
            promDatasourceName,
            'prometheus',
            null,
            label='Data source',
            refresh='load'
          ),
          template.new(
            name='job',
            label='job',
            datasource=promDatasource,
            query='label_values(ClickHouseMetrics_InterserverConnection,job)',
            current='',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            name='instance',
            label='instance',
            datasource=promDatasource,
            query='label_values(ClickHouseMetrics_InterserverConnection{job=~"$job"}, instance)',
            current='',
            refresh=2,
            includeAll=true,
            sort=1
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(ClickHouseMetrics_InterserverConnection{job=~"$job"}, cluster)',
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
        ]
      )
      .addPanels(
        std.flattenArrays([
          [
            interserverConnectionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
            replicaQueueSizePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          ],
          //next row
          [
            replicaOperationsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            replicaReadOnlyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          ],
          //next row
          [
            zooKeeperWatchesPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
            zooKeeperSessionsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          ],
          //next row
          [
            zooKeeperRequestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 24 } },
          ],
        ])
      ),
  },
}
