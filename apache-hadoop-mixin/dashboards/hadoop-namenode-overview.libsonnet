local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-hadoop-namenode-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local datanodeStatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_namenode_numlivedatanodes{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - live DataNodes',
    ),
    prometheus.target(
      'hadoop_namenode_numdeaddatanodes{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - dead DataNodes',
    ),
    prometheus.target(
      'hadoop_namenode_numstaledatanodes{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - stale DataNodes',
    ),
    prometheus.target(
      'hadoop_namenode_numdecommissioningdatanodes{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}} - decommissioning DataNodes',
    ),
  ],
  type: 'piechart',
  title: 'DataNode state',
  description: 'The DataNodes current state.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
      },
      mappings: [],
    },
    overrides: [],
  },
  options: {
    legend: {
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    pieType: 'pie',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local capacityUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * hadoop_namenode_capacityused{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"} / clamp_min(hadoop_namenode_capacitytotal{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}, 1)',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Capacity utilization',
  description: 'The storage utilization of the NameNode.',
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
        ],
      },
      unit: 'percent',
    },
    overrides: [
      {
        __systemRef: 'hideSeriesFrom',
        matcher: {
          id: 'byNames',
          options: {
            mode: 'exclude',
            names: [
              'hadoop-cluster-0 - instance-0',
            ],
            prefix: 'All except:',
            readOnly: true,
          },
        },
        properties: [
          {
            id: 'custom.hideFrom',
            value: {
              legend: false,
              tooltip: false,
              viz: true,
            },
          },
        ],
      },
    ],
  },
  options: {
    legend: {
      calcs: [],
      displayMode: 'list',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local totalBlocksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_namenode_blockstotal{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Total blocks',
  description: 'Total number of blocks managed by the NameNode.',
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
        ],
      },
      unit: '',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local missingBlocksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_namenode_missingblocks{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Missing blocks',
  description: 'Number of blocks reported by DataNodes as missing.',
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
        ],
      },
      unit: '',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local underreplicatedBlocksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_namenode_underreplicatedblocks{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Under-replicated blocks',
  description: 'Number of blocks that are under-replicated.',
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
        ],
      },
      unit: '',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local transactionsSinceLastCheckpointPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_namenode_transactionssincelastcheckpoint{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Transactions since last checkpoint',
  description: 'Number of transactions processed by the NameNode since the last checkpoint.',
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
        ],
      },
      unit: '',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local volumeFailuresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hadoop_namenode_volumefailurestotal{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Volume failures',
  description: 'The recent increase in number of volume failures on all DataNodes.',
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
        ],
      },
      unit: '',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local totalFilesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_namenode_filestotal{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Total files',
  description: 'Total number of files managed by the NameNode.',
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
        ],
      },
      unit: '',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local totalLoadPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_namenode_totalload{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="FSNamesystem"}',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Total load',
  description: 'Total load on the NameNode.',
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
        ],
      },
      unit: '',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local namenodeLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{job=~"$job", hadoop_cluster=~"$hadoop_cluster", instance=~"$instance", filename=~".*/hadoop/logs/.*-namenode.*.log"} |= ``',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'NameNode logs',
  description: 'The NameNode logs.',
  options: {
    dedupStrategy: 'none',
    enableLogDetails: true,
    prettifyLogMessage: false,
    showCommonLabels: false,
    showLabels: false,
    showTime: false,
    sortOrder: 'Descending',
    wrapLogMessage: false,
  },
};

{
  grafanaDashboards+:: {
    'apache-hadoop-namenode-overview.json':
      dashboard.new(
        'Apache Hadoop NameNode overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache Hadoop dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addTemplates(
        std.flattenArrays([
          [
            template.datasource(
              promDatasourceName,
              'prometheus',
              null,
              label='Data Source',
              refresh='load'
            ),
          ],
          if $._config.enableLokiLogs then [
            template.datasource(
              lokiDatasourceName,
              'loki',
              null,
              label='Loki Datasource',
              refresh='load'
            ),
          ] else [],
          [
            template.new(
              'job',
              promDatasource,
              'label_values(hadoop_namenode_blockstotal,job)',
              label='Job',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(hadoop_namenode_blockstotal{job=~"$job"}, instance)',
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'hadoop_cluster',
              promDatasource,
              'label_values(hadoop_namenode_blockstotal{job=~"$job"}, hadoop_cluster)',
              label='Hadoop cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
          ],
        ])
      )
      .addPanels(
        std.flattenArrays([
          [
            datanodeStatePanel { gridPos: { h: 9, w: 12, x: 0, y: 0 } },
            capacityUtilizationPanel { gridPos: { h: 9, w: 12, x: 12, y: 0 } },
            totalBlocksPanel { gridPos: { h: 6, w: 8, x: 0, y: 9 } },
            missingBlocksPanel { gridPos: { h: 6, w: 8, x: 8, y: 9 } },
            underreplicatedBlocksPanel { gridPos: { h: 6, w: 8, x: 16, y: 9 } },
            transactionsSinceLastCheckpointPanel { gridPos: { h: 6, w: 12, x: 0, y: 15 } },
            volumeFailuresPanel { gridPos: { h: 6, w: 12, x: 12, y: 15 } },
            totalFilesPanel { gridPos: { h: 6, w: 12, x: 0, y: 21 } },
            totalLoadPanel { gridPos: { h: 6, w: 12, x: 12, y: 21 } },
          ],
          if $._config.enableLokiLogs then [
            namenodeLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 27 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
