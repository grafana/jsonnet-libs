local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'mongodb-atlas-performance-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local memoryPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'mongodb_mem_resident{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - RAM',
      format='time_series',
    ),
    prometheus.target(
      'mongodb_mem_virtual{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - virtual',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Memory',
  description: 'The amount of RAM and virtual memory being used by the database process.',
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
      unit: 'mbytes',
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

local hardwareCPUInterruptServiceTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hardware_system_cpu_irq_milliseconds{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Hardware CPU interrupt service time / $__interval',
  description: 'The amount of time spent servicing CPU interrupts.',
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

local diskSpacePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'hardware_disk_metrics_disk_space_free_bytes{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - free',
      format='time_series',
    ),
    prometheus.target(
      'hardware_disk_metrics_disk_space_used_bytes{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}',
      datasource=promDatasource,
      legendFormat='{{instance}} - used',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Disk space',
  description: "The amount of free and used disk space on this node's hardware.",
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

local diskSpaceUtilizationPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '(hardware_disk_metrics_disk_space_used_bytes{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}) / clamp_min((hardware_disk_metrics_disk_space_free_bytes{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}) + (hardware_disk_metrics_disk_space_used_bytes{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}), 1)',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Disk space utilization',
  description: "The disk space utilization for this node's hardware.",
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
      max: 1,
      min: 0,
      thresholds: {
        mode: 'absolute',
        steps: [
          {
            color: 'green',
            value: null,
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

local networkRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_network_numRequests{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Network requests',
  description: 'The rate of distinct requests the node has received.',
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

local slowNetworkRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_network_numSlowDNSOperations{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - DNS',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_network_numSlowSSLOperations{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - SSL',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Slow network requests',
  description: 'The rate of slow DNS and SSL operations received by this node.',
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

local networkThroughputPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(mongodb_network_bytesIn{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - received',
      format='time_series',
    ),
    prometheus.target(
      'rate(mongodb_network_bytesOut{job=~"$job",cl_name=~"$cl_name",rs_nm=~"$rs",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - sent',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Network throughput',
  description: 'The rate of bytes sent and received by the node over a network connection.',
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

local hardwareIOPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(hardware_disk_metrics_read_count{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - reads',
      format='time_series',
    ),
    prometheus.target(
      'rate(hardware_disk_metrics_write_count{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - writes',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Hardware I/O',
  description: "The rate of read and write I/O's processed by this node.",
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
      unit: 'iops',
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

local hardwareIOWaitTimePanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'increase(hardware_disk_metrics_read_time_milliseconds{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - read',
      format='time_series',
      interval='1m',
    ),
    prometheus.target(
      'increase(hardware_disk_metrics_write_time_milliseconds{job=~"$job",cl_name=~"$cl_name",instance=~"$instance"}[$__interval:])',
      datasource=promDatasource,
      legendFormat='{{instance}} - write',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'timeseries',
  title: 'Hardware I/O wait time / $__interval',
  description: "The amount of time the node has spent waiting for read and write I/O's to process.",
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

{
  grafanaDashboards+:: {
    'mongodb-atlas-performance-overview.json':
      dashboard.new(
        'MongoDB Atlas performance overview',
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
            allValues='',
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
            allValues='',
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
            allValues='',
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
            allValues='',
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
          memoryPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          hardwareCPUInterruptServiceTimePanel { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
          diskSpacePanel { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
          diskSpaceUtilizationPanel { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
          networkRequestsPanel { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
          slowNetworkRequestsPanel { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
          networkThroughputPanel { gridPos: { h: 8, w: 24, x: 0, y: 24 } },
          hardwareIOPanel { gridPos: { h: 8, w: 24, x: 0, y: 32 } },
          hardwareIOWaitTimePanel { gridPos: { h: 8, w: 24, x: 0, y: 40 } },
        ]
      ),
  },
}
