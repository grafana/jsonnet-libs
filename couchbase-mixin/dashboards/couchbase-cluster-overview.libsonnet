local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'couchbase-cluster-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local topNodesByMemoryUsagePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(job, couchbase_cluster, instance) (sys_mem_actual_used{' + matcher + '})) / (sum by(job, couchbase_cluster, instance) (clamp_min(sys_mem_actual_free{' + matcher + '}, 1)) + sum by(couchbase_cluster, instance, job) (sys_mem_actual_used{' + matcher + '}))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top nodes by memory usage',
  description: 'Top nodes by memory usage across the Couchbase cluster.',
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
      unit: 'percentunit',
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

local topNodesByHTTPRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(job, couchbase_cluster, instance) (rate(cm_http_requests_total{' + matcher + '}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top nodes by HTTP requests',
  description: 'Rate of HTTP requests handled by the cluster manager for the top nodes.',
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
      unit: 'reqps',
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

local topNodesByQueryServiceRequestsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(job, instance, couchbase_cluster) (rate(n1ql_requests{' + matcher + '}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top nodes by query service requests',
  description: 'Rate of N1QL requests processed by the query service for the top nodes.',
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
      unit: 'reqps',
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

local topNodesByIndexAverageScanLatencyPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, avg by(instance, couchbase_cluster, job) (index_avg_scan_latency{' + matcher + '}))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top nodes by index average scan latency',
  description: 'Average time to serve an index service scan request for the top nodes.',
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
      unit: 'ns',
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

local xdcrReplicationRatePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, job) (rate(xdcr_data_replicated_bytes{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'XDCR replication rate',
  description: 'Rate of replication through the Cross Data Center Replication feature.',
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
      unit: 'Bps',
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

local xdcrDocsReceivedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(job, couchbase_cluster) (rate(xdcr_docs_received_from_dcp_total{' + matcher + '}[$__rate_interval]))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}}',
    ),
  ],
  type: 'timeseries',
  title: 'XDCR docs received',
  description: 'The rate of mutations received by this cluster.',
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
      unit: 'mut/sec',
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

local localBackupSizePanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum by(couchbase_cluster, job, instance) (backup_data_size{' + matcher + '})',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{instance}}',
    ),
  ],
  type: 'bargauge',
  title: 'Local backup size',
  description: 'The size of the locally replicated data stored, per node.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'green',
        mode: 'fixed',
      },
      mappings: [],
      min: 1,
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
      unit: 'decbytes',
    },
    overrides: [],
  },
  options: {
    displayMode: 'basic',
    minVizHeight: 10,
    minVizWidth: 0,
    orientation: 'auto',
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

local bucketsRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Buckets',
  collapsed: false,
};

local topBucketsByMemoryUsedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(bucket, couchbase_cluster, job) (kv_mem_used_bytes{' + matcher + '}))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{bucket}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top buckets by memory used',
  description: 'Memory used for the top buckets.',
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
      unit: 'decbytes',
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

local topBucketsByDiskUsedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(job, couchbase_cluster, bucket) (couch_docs_actual_disk_size{' + matcher + '}))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{bucket}}',
    ),
  ],
  type: 'bargauge',
  title: 'Top buckets by disk used',
  description: 'Space on disk used for the top buckets.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'green',
        mode: 'fixed',
      },
      mappings: [],
      min: 1,
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
      unit: 'decbytes',
    },
    overrides: [],
  },
  options: {
    displayMode: 'basic',
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

local topBucketsByOperationsPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(couchbase_cluster, job, bucket) (rate(kv_ops{' + matcher + '}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{bucket}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top buckets by operations',
  description: 'Rate of operations for the busiest buckets.',
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
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
      unit: 'ops',
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

local topBucketsByOperationsFailedPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(couchbase_cluster, job, bucket) (rate(kv_ops_failed{' + matcher + '}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{bucket}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top buckets by operations failed',
  description: 'Rate of operations failed for the most problematic buckets.',
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
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
      unit: 'ops',
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

local topBucketsByVBucketsCountPanel(matcher) = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(couchbase_cluster, job, bucket) (kv_num_vbuckets{' + matcher + '}))',
      datasource=promDatasource,
      legendFormat='{{couchbase_cluster}} - {{bucket}}',
    ),
  ],
  type: 'bargauge',
  title: 'Top buckets by vBuckets count',
  description: 'Number of virtual buckets across the cluster for the top buckets.',
  fieldConfig: {
    defaults: {
      color: {
        fixedColor: 'green',
        mode: 'fixed',
      },
      mappings: [],
      min: 1,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
          },
          {
            color: 'red',
            value: 80,
          },
        ],
      },
      unit: 'none',
    },
    overrides: [],
  },
  options: {
    displayMode: 'basic',
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

local getMatcher(cfg) = '%(couchbaseSelector)s, couchbase_cluster=~"$couchbase_cluster"' % cfg;

{
  grafanaDashboards+:: {
    'couchbase-cluster-overview.json':
      dashboard.new(
        'Couchbase cluster overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Couchbase dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addTemplates(
        [
          template.datasource(
            promDatasourceName,
            'prometheus',
            null,
            label='Data source',
            refresh='load'
          ),
          template.new(
            'job',
            promDatasource,
            'label_values(kv_num_vbuckets,job)',
            label='Job',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'cluster',
            promDatasource,
            'label_values(kv_num_vbuckets{%(multiclusterSelector)s}, cluster)' % $._config,
            label='Cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.*',
            hide=if $._config.enableMultiCluster then '' else 'variable',
            sort=0
          ),
          template.new(
            'couchbase_cluster',
            promDatasource,
            'label_values(kv_num_vbuckets{%(couchbaseSelector)s},couchbase_cluster)',
            label='Couchbase cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
        ]
      )
      .addPanels(
        [
          topNodesByMemoryUsagePanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          topNodesByHTTPRequestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          topNodesByQueryServiceRequestsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          topNodesByIndexAverageScanLatencyPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          xdcrReplicationRatePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 16 } },
          xdcrDocsReceivedPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 16 } },
          localBackupSizePanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 16 } },
          bucketsRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
          topBucketsByMemoryUsedPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 0, y: 25 } },
          topBucketsByDiskUsedPanel(getMatcher($._config)) { gridPos: { h: 8, w: 12, x: 12, y: 25 } },
          topBucketsByOperationsPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 0, y: 33 } },
          topBucketsByOperationsFailedPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 8, y: 33 } },
          topBucketsByVBucketsCountPanel(getMatcher($._config)) { gridPos: { h: 8, w: 8, x: 16, y: 33 } },
        ]
      ),
  },
}
