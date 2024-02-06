local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local dashboardUid = 'clickhouse-latency';
local promDatasourceName = 'prometheus_datasource';
local getMatcher(cfg) = '%(clickhouseSelector)s' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local diskReadLatencyPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Time spent waiting for read syscall',
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
        unit: 'µs',
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
        editorMode: 'builder',
        expr: 'increase(ClickHouseProfileEvents_DiskReadElapsedMicroseconds{' + matcher + '}[$__rate_interval])',
        legendFormat: '{instance} - disk read elapsed',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Disk read latency',
    type: 'timeseries',
  };

local diskWriteLatencyPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Time spent waiting for write syscall',
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
        unit: 'µs',
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
        editorMode: 'builder',
        expr: 'increase(ClickHouseProfileEvents_DiskWriteElapsedMicroseconds{' + matcher + '}[$__rate_interval])',
        legendFormat: '{instance} - disk write elapsed',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Disk write latency',
    type: 'timeseries',
  };

local networkTransmitLatencyPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Latency of inbound network traffic',
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
        unit: 'µs',
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
        editorMode: 'builder',
        expr: 'increase(ClickHouseProfileEvents_NetworkReceiveElapsedMicroseconds{' + matcher + '}[$__rate_interval])',
        legendFormat: '{instance} - network receive elapsed',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Network receive latency',
    type: 'timeseries',
  };

local networkTransmitLatencyPanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Latency of outbound network traffic',
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
        unit: 'µs',
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
        editorMode: 'builder',
        expr: 'increase(ClickHouseProfileEvents_NetworkSendElapsedMicroseconds{' + matcher + '}[$__rate_interval])',
        legendFormat: '{instance} - network send elapsed',
        range: true,
        refId: 'A',
      },
    ],
    title: 'Network transmit latency',
    type: 'timeseries',
  };

local zooKeeperWaitTimePanel(matcher) =
  {
    datasource: promDatasource,
    description: 'Time spent waiting for ZooKeeper request to process',
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
        unit: 'µs',
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
        editorMode: 'builder',
        expr: 'increase(ClickHouseProfileEvents_ZooKeeperWaitMicroseconds{' + matcher + '}[$__rate_interval])',
        legendFormat: '{instance} - ZooKeeper wait',
        range: true,
        refId: 'A',
      },
    ],
    title: 'ZooKeeper wait time',
    type: 'timeseries',
  };
{
  grafanaDashboards+:: {

    'clickhouse-latency.json':
      dashboard.new(
        'ClickHouse latency',
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
            query='label_values(ClickHouseProfileEvents_DiskReadElapsedMicroseconds,job)',
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
            query='label_values(ClickHouseProfileEvents_DiskReadElapsedMicroseconds{job=~"$job"}, instance)',
            current='',
            refresh=2,
            includeAll=true,
            sort=1
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(ClickHouseProfileEvents_DiskReadElapsedMicroseconds{job=~"$job"}, cluster)',
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
            diskReadLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
            diskWriteLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          ],
          //next row
          [
            networkTransmitLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
            networkTransmitLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          ],
          //next row
          [
            zooKeeperWaitTimePanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 16 } },
          ],
        ])
      ),
  },
}
