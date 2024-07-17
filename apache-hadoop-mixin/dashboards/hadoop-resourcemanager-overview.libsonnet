local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-hadoop-resourcemanager-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local getMatcher(cfg) = '%(hadoopSelector)s, instance=~"$instance"' % cfg;

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local nodeManagersStatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_numactivenms{' + matcher + ', name="ClusterMetrics",}',
      datasource=promDatasource,
      legendFormat='active',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numdecommissionednms{' + matcher + ', name="ClusterMetrics",}',
      datasource=promDatasource,
      legendFormat='decommissioned',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numlostnms{' + matcher + ', name="ClusterMetrics"}',
      datasource=promDatasource,
      legendFormat='lost',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numunhealthynms{' + matcher + ', name="ClusterMetrics"}',
      datasource=promDatasource,
      legendFormat='healthy',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numrebootednms{' + matcher + ', name="ClusterMetrics"}',
      datasource=promDatasource,
      legendFormat='rebooted',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numshutdownnms{' + matcher + ', name="ClusterMetrics"}',
      datasource=promDatasource,
      legendFormat='shutdown',
    ),
  ],
  type: 'bargauge',
  title: 'Node Managers state',
  description: 'The number of Node Managers by state in the Hadoop ResourceManager.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
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
    },
    overrides: [],
  },
  options: {
    displayMode: 'gradient',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'horizontal',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    showUnfilled: true,
    valueMode: 'color',
  },
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local applicationsRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'Applications',
  collapsed: false,
};

local applicationsStatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_appsrunning{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='running',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appspending{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='pending',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appskilled{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='killed',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appssubmitted{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='submitted',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appscompleted{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='completed',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appsfailed{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='failed',
    ),
  ],
  type: 'timeseries',
  title: 'Applications state',
  description: 'Number of applications by state for the Hadoop ResourceManager.',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local availableMemoryPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_allocatedmb{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='allocated',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_resourcemanager_availablemb{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='available',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Available memory',
  description: 'The available memory in the Hadoop ResourceManager.',
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
      unit: 'decmbytes',
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

local availableVirtualCoresPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_availablevcores{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='available',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_resourcemanager_allocatedvcores{' + matcher + ', name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='allocated',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Available virtual cores',
  description: 'The available virtual cores in the Hadoop ResourceManager.',
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

local jvmRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'JVM',
  collapsed: false,
};

local memoryUsedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_memheapusedm{name="JvmMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_resourcemanager_memnonheapusedm{name="JvmMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='nonheap',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Memory used',
  description: 'The Heap and non-heap memory used for the ResourceManager.',
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
          mode: 'normal',
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
      unit: 'decmbytes',
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
  pluginVersion: '10.0.2-cloud.1.94a6f396',
};

local memoryCommittedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_memheapcommittedm{name="JvmMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_resourcemanager_memnonheapcommittedm{name="JvmMetrics", ' + matcher + '}',
      datasource=promDatasource,
      legendFormat='nonheap',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Memory committed',
  description: 'The Heap and non-heap memory committed for the ResourceManager.',
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
      unit: 'decmbytes',
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

local garbageCollectionCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hadoop_resourcemanager_gccount{' + matcher + '}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Garbage collection count',
  description: 'The recent increase in the number of garbage collection events for the ResourceManager JVM.',
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

local averageGarbageCollectionTimePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hadoop_resourcemanager_gctimemillis{' + matcher + '}[$__interval:]) / clamp_min(increase(hadoop_resourcemanager_gccount{' + matcher + '}[$__interval:]), 1)',
      datasource=promDatasource,
      legendFormat='{{hadoop_cluster}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Average garbage collection time',
  description: 'The average duration for each garbage collection operation in the ResourceManager JVM.',
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
      unit: 'ms',
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

local resourcemanagerLogsPanel(matcher) = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{' + matcher + '} |= `` | (filename=~".*/hadoop/logs/.*-resourcemanager.*.log" or log_type="resourcemanager")',
      queryType: 'range',
      refId: 'A',
    },
  ],
  type: 'logs',
  title: 'ResourceManager logs',
  description: 'The ResourceManager logs.',
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
    'apache-hadoop-resourcemanager-overview.json':
      dashboard.new(
        'Apache Hadoop ResourceManager overview',
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
              'label_values(hadoop_resourcemanager_activeapplications,job)',
              label='Job',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'cluster',
              promDatasource,
              'label_values(hadoop_resourcemanager_activeapplications{%(hadoopSelector)s}, cluster)' % $._config,
              label='Cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.*',
              hide=if $._config.enableMultiCluster then '' else 'variable',
              sort=0
            ),
            template.new(
              'instance',
              promDatasource,
              'label_values(hadoop_resourcemanager_activeapplications{%(hadoopSelector)s}, instance)' % $._config,
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
              'label_values(hadoop_resourcemanager_activeapplications{%(hadoopSelector)s}, hadoop_cluster)' % $._config,
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
            nodeManagersStatePanel(getMatcher($._config)) { gridPos: { h: 9, w: 24, x: 0, y: 0 } },
            applicationsRow { gridPos: { h: 1, w: 24, x: 0, y: 9 } },
            applicationsStatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 10 } },
            availableMemoryPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 18 } },
            availableVirtualCoresPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 18 } },
            jvmRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
            memoryUsedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
            memoryCommittedPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
            garbageCollectionCountPanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 0, y: 31 } },
            averageGarbageCollectionTimePanel(getMatcher($._config)) { gridPos: { h: 6, w: 12, x: 12, y: 31 } },
          ],
          if $._config.enableLokiLogs then [
            resourcemanagerLogsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 24, x: 0, y: 37 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
