local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'apache-hadoop-resourcemanager-overview';

local promDatasourceName = 'prometheus_datasource';
local lokiDatasourceName = 'loki_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local lokiDatasource = {
  uid: '${%s}' % lokiDatasourceName,
};

local nodeManagersStatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_numactivenms{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="ClusterMetrics",}',
      datasource=promDatasource,
      legendFormat='active',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numdecommissionednms{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="ClusterMetrics",}',
      datasource=promDatasource,
      legendFormat='decommissioned',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numlostnms{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="ClusterMetrics"}',
      datasource=promDatasource,
      legendFormat='lost',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numunhealthynms{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="ClusterMetrics"}',
      datasource=promDatasource,
      legendFormat='healthy',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numrebootednms{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="ClusterMetrics"}',
      datasource=promDatasource,
      legendFormat='rebooted',
    ),
    prometheus.target(
      'hadoop_resourcemanager_numshutdownnms{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="ClusterMetrics"}',
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

local applicationsStatePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_appsrunning{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='running',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appspending{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='pending',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appskilled{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='killed',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appssubmitted{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='submitted',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appscompleted{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='completed',
    ),
    prometheus.target(
      'hadoop_resourcemanager_appsfailed{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
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

local availableMemoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_allocatedmb{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='allocated',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_resourcemanager_availablemb{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
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

local availableVirtualCoresPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_availablevcores{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
      datasource=promDatasource,
      legendFormat='available',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_resourcemanager_allocatedvcores{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster", name="QueueMetrics",q0="root", q1="default"}',
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

local memoryUsedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_memheapusedm{name="JvmMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
      datasource=promDatasource,
      legendFormat='heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_resourcemanager_memnonheapusedm{name="JvmMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local memoryCommittedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hadoop_resourcemanager_memheapcommittedm{name="JvmMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
      datasource=promDatasource,
      legendFormat='heap',
      format='time_series',
    ),
    prometheus.target(
      'hadoop_resourcemanager_memnonheapcommittedm{name="JvmMetrics", job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}',
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

local garbageCollectionCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hadoop_resourcemanager_gccount{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}[$__interval:])',
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

local averageGarbageCollectionTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hadoop_resourcemanager_gctimemillis{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}[$__interval:]) / clamp_min(increase(hadoop_resourcemanager_gccount{job=~"$job", instance=~"$instance", hadoop_cluster=~"$hadoop_cluster"}[$__interval:]), 1)',
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

local resourcemanagerLogsPanel = {
  datasource: lokiDatasource,
  targets: [
    {
      datasource: lokiDatasource,
      editorMode: 'code',
      expr: '{job=~"$job", hadoop_cluster=~"$hadoop_cluster", instance=~"$instance", filename=~".*/hadoop/logs/.*-resourcemanager.*.log"} |= ``',
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
              'instance',
              promDatasource,
              'label_values(hadoop_resourcemanager_activeapplications{job=~"$job"}, instance)',
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
              'label_values(hadoop_resourcemanager_activeapplications{job=~"$job"}, hadoop_cluster)',
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
            nodeManagersStatePanel { gridPos: { h: 9, w: 24, x: 0, y: 0 } },
            applicationsRow { gridPos: { h: 1, w: 24, x: 0, y: 9 } },
            applicationsStatePanel { gridPos: { h: 8, w: 24, x: 0, y: 10 } },
            availableMemoryPanel { gridPos: { h: 6, w: 12, x: 0, y: 18 } },
            availableVirtualCoresPanel { gridPos: { h: 6, w: 12, x: 12, y: 18 } },
            jvmRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
            memoryUsedPanel { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
            memoryCommittedPanel { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
            garbageCollectionCountPanel { gridPos: { h: 6, w: 12, x: 0, y: 31 } },
            averageGarbageCollectionTimePanel { gridPos: { h: 6, w: 12, x: 12, y: 31 } },
          ],
          if $._config.enableLokiLogs then [
            resourcemanagerLogsPanel { gridPos: { h: 8, w: 24, x: 0, y: 37 } },
          ] else [],
          [
          ],
        ])
      ),
  },
}
