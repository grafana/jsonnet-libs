local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'couchbase-bucket-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local topBucketsByMemoryUsedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, kv_mem_used_bytes{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"})',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{bucket}}',
      format='time_series',
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

local topBucketsByDiskUsedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, couch_docs_actual_disk_size{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"})',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{bucket}}',
    ),
  ],
  type: 'bargauge',
  title: 'Top buckets by disk used',
  description: 'Total space on disk used for the top buckets.',
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

local topBucketsByCurrentItemsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, kv_curr_items{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"})',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{bucket}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top buckets by current items',
  description: 'Number of active items for the largest buckets.',
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
      unit: 'none',
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

local topBucketsByOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(bucket, couchbase_cluster, instance, job, op) (rate(kv_ops{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{bucket}} - {{op}}',
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
            value: null,
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

local topBucketsByOperationsFailedPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(bucket, couchbase_cluster, instance, job) (rate(kv_ops_failed{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"}[$__rate_interval])))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{bucket}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top buckets by operations failed',
  description: 'Rate of failed operations for the most problematic buckets.',
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

local topBucketsByHighPriorityRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(bucket, couchbase_cluster, instance, job) (kv_num_high_pri_requests{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"}))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{bucket}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top buckets by high priority requests',
  description: 'Rate of high priority requests processed by the KV engine for the top buckets.',
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

local bottomBucketsByCacheHitRatioPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'bottomk(5, sum by(couchbase_cluster, job, instance, bucket) (index_cache_hits{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"})) / (clamp_min(sum by(couchbase_cluster, job, instance, bucket) (index_cache_hits{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"}), 1) + sum by(couchbase_cluster, job, instance, bucket) (index_cache_misses{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"}))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{bucket}}',
    ),
  ],
  type: 'timeseries',
  title: 'Bottom buckets by cache hit ratio',
  description: 'Worst buckets by cache hit ratio.',
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
      max: 1,
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

local topBucketsByVBucketsCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(bucket, couchbase_cluster, instance, job) (kv_num_vbuckets{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"}))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{bucket}}',
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

local topBucketsByVBucketQueueMemoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk(5, sum by(bucket, couchbase_cluster, instance, job) (kv_vb_queue_memory_bytes{job=~"$job", couchbase_cluster=~"$couchbase_cluster", instance=~"$instance", bucket=~"$bucket"}))',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{bucket}}',
    ),
  ],
  type: 'timeseries',
  title: 'Top buckets by vBucket queue memory',
  description: 'Memory occupied by the queue for a virtual bucket for the top buckets.',
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

{
  grafanaDashboards+:: {
    'couchbase-bucket-overview.json':
      dashboard.new(
        'Couchbase bucket overview',
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
            'label_values(kv_mem_used_bytes,job)',
            label='Job',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'couchbase_cluster',
            promDatasource,
            'label_values(kv_mem_used_bytes,couchbase_cluster)',
            label='Couchbase cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(kv_mem_used_bytes,instance)',
            label='Instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='',
            sort=0
          ),
          template.new(
            'bucket',
            promDatasource,
            'label_values(kv_mem_used_bytes,bucket)',
            label='Bucket',
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
          topBucketsByMemoryUsedPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          topBucketsByDiskUsedPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          topBucketsByCurrentItemsPanel { gridPos: { h: 8, w: 8, x: 0, y: 8 } },
          topBucketsByOperationsPanel { gridPos: { h: 8, w: 8, x: 8, y: 8 } },
          topBucketsByOperationsFailedPanel { gridPos: { h: 8, w: 8, x: 16, y: 8 } },
          topBucketsByHighPriorityRequestsPanel { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          bottomBucketsByCacheHitRatioPanel { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          topBucketsByVBucketsCountPanel { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
          topBucketsByVBucketQueueMemoryPanel { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
        ]
      ),
  },
}
