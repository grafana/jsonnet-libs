local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;
local dashboardUid = 'f5-cluster-overview';

local promDatasourceName = 'datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local nodeAvailabilityPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * sum by(partition, instance) (bigip_node_status_availability_state{job=~"$job", instance=~"$instance"})  / clamp_min(count by(partition, instance) (bigip_node_status_availability_state{job=~"$job", instance=~"$instance"}),1)',
      datasource=promDatasource,
      legendFormat='{{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Node availability',
  description: 'The percentage of nodes available.',
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
            color: 'red',
            value: null,
          },
          {
            color: 'red',
            value: 95,
          },
          {
            color: '#EAB839',
            value: 96,
          },
          {
            color: 'green',
            value: 100,
          },
        ],
      },
      unit: 'percent',
    },
    overrides: [],
  },
  options: {
    colorMode: 'value',
    graphMode: 'none',
    justifyMode: 'auto',
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    textMode: 'auto',
  },
  pluginVersion: '10.2.0-60139',
};

local poolAvailabilityPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * sum by(partition, instance) (bigip_pool_status_availability_state{job=~"$job", instance=~"$instance"}) / clamp_min(count by(partition, instance)  (bigip_pool_status_availability_state{job=~"$job", instance=~"$instance"}),1)',
      datasource=promDatasource,
      legendFormat='{{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Pool availability',
  description: 'The percentage of pools available.',
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
            color: 'red',
            value: null,
          },
          {
            color: 'red',
            value: 95,
          },
          {
            color: 'yellow',
            value: 96,
          },
          {
            color: 'green',
            value: 100,
          },
        ],
      },
      unit: 'percent',
    },
    overrides: [],
  },
  options: {
    colorMode: 'value',
    graphMode: 'none',
    justifyMode: 'auto',
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    textMode: 'auto',
  },
  pluginVersion: '10.2.0-60139',
};

local virtualServerAvailabilityPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '100 * sum by(partition, instance) (bigip_vs_status_availability_state{job=~"$job", instance=~"$instance"}) / clamp_min(count by(partition, instance) (bigip_vs_status_availability_state{job=~"$job", instance=~"$instance"}),1)',
      datasource=promDatasource,
      legendFormat='{{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'stat',
  title: 'Virtual server availability',
  description: 'The percentage of virtual servers available.',
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
            color: 'red',
            value: null,
          },
          {
            color: 'red',
            value: 95,
          },
          {
            color: 'yellow',
            value: 96,
          },
          {
            color: 'green',
            value: 100,
          },
        ],
      },
      unit: 'percent',
    },
    overrides: [],
  },
  options: {
    colorMode: 'value',
    graphMode: 'none',
    justifyMode: 'auto',
    orientation: 'auto',
    reduceOptions: {
      calcs: [
        'lastNotNull',
      ],
      fields: '',
      values: false,
    },
    textMode: 'auto',
  },
  pluginVersion: '10.2.0-60139',
};

local topActiveServersideNodesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, bigip_node_serverside_cur_conns{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{node}} - {{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'bargauge',
  title: 'Top active server-side nodes',
  description: 'Nodes with the highest number of active server-side connections.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
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
      unit: 'none',
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
  pluginVersion: '10.2.0-60139',
};

local topOutboundTrafficNodesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, increase(bigip_node_serverside_bytes_out{job=~"$job", instance=~"$instance"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{node}} - {{partition}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'bargauge',
  title: 'Top outbound traffic nodes',
  description: 'Nodes with the highest outbound traffic.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
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
      unit: 'decbytes',
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
  pluginVersion: '10.2.0-60139',
};

local topActiveMembersInPoolsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, bigip_pool_active_member_cnt{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'bargauge',
  title: 'Top active members in pools',
  description: 'Pools with the highest number of active members.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
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
      unit: 'none',
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
  pluginVersion: '10.2.0-60139',
};

local topRequestedPoolsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, increase(bigip_pool_tot_requests{job=~"$job", instance=~"$instance"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'bargauge',
  title: 'Top requested pools',
  description: 'Pools with the highest number of requests.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
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
      unit: 'requests',
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
  pluginVersion: '10.2.0-60139',
};

local topQueueDepthPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, bigip_pool_connq_depth{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{pool}} - {{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'bargauge',
  title: 'Top queue depth',
  description: 'Pools with the largest connection queues.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
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
      unit: 'none',
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
  pluginVersion: '10.2.0-60139',
};

local topUtilizedVirtualServersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, increase(bigip_vs_clientside_bytes_in{job=~"$job", instance=~"$instance"}[$__interval:])) + topk(5, increase(bigip_vs_clientside_bytes_out{job=~"$job", instance=~"$instance"}[$__interval:]))',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}}',
      format='time_series',
      interval='1m',
    ),
  ],
  type: 'bargauge',
  title: 'Top utilized virtual servers',
  description: 'Virtual servers with the highest traffic (inbound and outbound).',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
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
      unit: 'decbytes',
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
  pluginVersion: '10.2.0-60139',
};

local topLatencyVirtualServersPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'topk($k, bigip_vs_cs_mean_conn_dur{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='{{vs}} - {{partition}} - {{instance}}',
      format='time_series',
    ),
  ],
  type: 'bargauge',
  title: 'Top latency virtual servers',
  description: 'Virtual servers with the highest response times.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      mappings: [],
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
      unit: 'ms',
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
  pluginVersion: '10.2.0-60139',
};

{
  grafanaDashboards+:: {
    'f5-cluster-overview.json':
      dashboard.new(
        'F5 cluster overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other F5 dashboards',
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
            label='Data Source',
            refresh='load'
          ),
          template.new(
            'job',
            promDatasource,
            'label_values(bigip_node_status_availability_state,job)',
            label='job',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(bigip_node_status_availability_state{job=~"$job"}, instance)',
            label='instance',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.custom(
            'k',
            query='5,10,20,50',
            current='5',
            label='top node count',
            refresh='never',
            includeAll=false,
            multi=false,
            allValues='',
          ),
        ]
      )
      .addPanels(
        [
          nodeAvailabilityPanel { gridPos: { h: 6, w: 8, x: 0, y: 0 } },
          poolAvailabilityPanel { gridPos: { h: 6, w: 8, x: 8, y: 0 } },
          virtualServerAvailabilityPanel { gridPos: { h: 6, w: 8, x: 16, y: 0 } },
          topActiveServersideNodesPanel { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          topOutboundTrafficNodesPanel { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          topActiveMembersInPoolsPanel { gridPos: { h: 6, w: 8, x: 0, y: 12 } },
          topRequestedPoolsPanel { gridPos: { h: 6, w: 8, x: 8, y: 12 } },
          topQueueDepthPanel { gridPos: { h: 6, w: 8, x: 16, y: 12 } },
          topUtilizedVirtualServersPanel { gridPos: { h: 6, w: 12, x: 0, y: 18 } },
          topLatencyVirtualServersPanel { gridPos: { h: 6, w: 12, x: 12, y: 18 } },
        ]
      ),
  },
}
