local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'mongodb-atlas-operations-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local queryOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_opcounters_query{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Query operations',
  description: 'The rate of query operations the node has received.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local insertOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_opcounters_insert{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Insert operations',
  description: 'The rate of insert operations the node has received.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local updateOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_opcounters_update{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Update operations',
  description: 'The rate of update operations this node has received.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local deleteOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_opcounters_delete{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Delete operations',
  description: 'The rate of delete operations this node has received.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local currentConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mongodb_connections_current{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Current connections',
  description: 'The number of incoming connections from clients to the node.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local activeConnectionsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mongodb_connections_active{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Active connections',
  description: 'The number of connections that currently have operations in progress.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local readAndWriteOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_opLatencies_reads_ops{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - reads',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_opLatencies_writes_ops{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - writes',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Read and write operations',
  description: 'The rate of read and write operations performed by the node.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local readAndWriteLatencyPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_opLatencies_reads_latency{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - reads',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_opLatencies_writes_latency{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - writes',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Read and write latency / $__interval',
  description: 'The latency time for read and write operations performed by this node.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local locksRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
      format='time_series',
    ),
  ],
  type: 'row',
  title: 'Locks',
};

local databaseDeadlocksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_locks_Database_deadlockCount_W{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Database_deadlockCount_w{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Database_deadlockCount_R{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - shared',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Database_deadlockCount_r{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent shared',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Database deadlocks / $__interval',
  description: 'The number of deadlocks that have occurred for the database lock.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local databaseWaitCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_locks_Database_acquireWaitCount_W{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Database_acquireWaitCount_w{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Database_acquireWaitCount_R{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - shared',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Database_acquireWaitCount_r{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent shared',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Database wait count / $__interval',
  description: 'The number of database lock acquisitions that had to wait.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local databaseWaitTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_locks_Database_timeAcquiringMicros_W{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Database_timeAcquiringMicros_w{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Database_timeAcquiringMicros_R{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - shared',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Database_timeAcquiringMicros_r{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent shared',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Database wait time / $__interval',
  description: 'The time spent waiting for the database lock acquisition.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local collectionDeadlocksPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_locks_Collection_deadlockCount_W{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Collection_deadlockCount_w{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Collection_deadlockCount_R{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - shared',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Collection_deadlockCount_r{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent shared',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Collection deadlocks / $__interval',
  description: 'The number of deadlocks that have occurred for the collection lock.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local collectionWaitCountPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_locks_Collection_acquireWaitCount_W{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Collection_acquireWaitCount_w{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Collection_acquireWaitCount_R{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - shared',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Collection_acquireWaitCount_r{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent shared',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Collection wait count / $__interval',
  description: 'The number of collection lock acquisitions that had to wait.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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

local collectionWaitTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(mongodb_locks_Collection_timeAcquiringMicros_W{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Collection_timeAcquiringMicros_w{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent exclusive',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Collection_timeAcquiringMicros_R{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - shared',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(mongodb_locks_Collection_timeAcquiringMicros_r{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - intent shared',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Collection wait time / $__interval',
  description: 'The time spent waiting for the collection lock acquisition.',
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
        fillOpacity: 10,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'linear',
        lineWidth: 1,
        pointSize: 5,
        scaleDistribution: {
          type: 'linear',
        },
        showPoints: 'never',
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
      mode: 'multi',
      sort: 'desc',
    },
  },
};

{
  grafanaDashboards+:: {
    'mongodb-atlas-operations-overview.json':
      dashboard.new(
        'MongoDB Atlas operations overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )

      .addTemplates(
        [
          template.datasource(
            promDatasourceName,
            'prometheus',
            null,
            label='Data Source',
            refresh='load'
          ),
          template.new(
            'job',
            promDatasource,
            'label_values(mongodb_network_bytesIn,job)',
            label='Job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.new(
            'cl_name',
            promDatasource,
            'label_values(mongodb_network_bytesIn{job=~"$job"},cl_name)',
            label='Atlas cluster',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.new(
            'rs',
            promDatasource,
            'label_values(mongodb_network_bytesIn{cl_name=~"$cl_name"},rs_nm)',
            label='Replica set',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(mongodb_network_bytesIn{rs_nm=~"$rs"},instance)',
            label='Node',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=0
          ),
        ]
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='MongoDB Atlas dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      ))
      .addPanels(
        [
          queryOperationsPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          insertOperationsPanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          updateOperationsPanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          deleteOperationsPanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          currentConnectionsPanel { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          activeConnectionsPanel { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          readAndWriteOperationsPanel { gridPos: { h: 8, w: 12, x: 0, y: 24 } },
          readAndWriteLatencyPanel { gridPos: { h: 8, w: 12, x: 12, y: 24 } },
          locksRow { gridPos: { h: 1, w: 24, x: 0, y: 32 } },
          databaseDeadlocksPanel { gridPos: { h: 8, w: 8, x: 0, y: 33 } },
          databaseWaitCountPanel { gridPos: { h: 8, w: 8, x: 8, y: 33 } },
          databaseWaitTimePanel { gridPos: { h: 8, w: 8, x: 16, y: 33 } },
          collectionDeadlocksPanel { gridPos: { h: 8, w: 8, x: 0, y: 41 } },
          collectionWaitCountPanel { gridPos: { h: 8, w: 8, x: 8, y: 41 } },
          collectionWaitTimePanel { gridPos: { h: 8, w: 8, x: 16, y: 41 } },
        ]
      ),
  },
}
