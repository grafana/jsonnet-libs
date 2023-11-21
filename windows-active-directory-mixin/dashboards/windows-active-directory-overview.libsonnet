local g = (import 'grafana-builder/grafana.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;

local dashboardUid = 'active-directory-overview';

local promDatasourceName = 'prometheus_datasource';

local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

local alertsPanel = {
  datasource: promDatasource,
  targets: [],
  type: 'alertlist',
  title: 'Alerts',
  description: ' Currently firing alerts for the Active Directory environment.',
  options: {
    alertInstanceLabelFilter: '{job=~"${job:regex}", instance=~"${instance:regex}"}',
    alertName: '',
    dashboardAlerts: false,
    datasource: 'grafanacloud-keithschmitty-prom',
    groupBy: [],
    groupMode: 'default',
    maxItems: 20,
    sortOrder: 1,
    stateFilter: {
      'error': true,
      firing: true,
      noData: false,
      normal: false,
      pending: true,
    },
    viewMode: 'list',
  },
};

local replicationPendingOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(windows_ad_replication_pending_operations{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='Operations',
    ),
  ],
  type: 'stat',
  title: 'Replication pending operations',
  description: 'The number of replication operations that are pending in Active Directory. These operations could include a variety of tasks, such as updating directory objects, processing changes made on other domain controllers, or applying new schema updates.',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local directoryServiceThreadsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(windows_ad_directory_service_threads{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='Directory service threads',
    ),
  ],
  type: 'stat',
  title: 'Directory service threads',
  description: ' The current number of active threads in the directory service.',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local replicationPendingSynchronizationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'sum(windows_ad_replication_pending_synchronizations{job=~"$job", instance=~"$instance"})',
      datasource=promDatasource,
      legendFormat='Synchronizations',
    ),
  ],
  type: 'stat',
  title: 'Replication pending synchronizations',
  description: 'The number of synchronization requests that are pending in Active Directory. Synchronization in AD refers to the process of ensuring that changes (like updates to user accounts, group policies, etc.) are consistently applied across all domain controllers.',
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
    wideLayout: true,
  },
  pluginVersion: '10.3.0-63516',
};

local ldapBindRequestsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_ad_binds_total{job=~"$job", instance=~"$instance", bind_method=~"ldap"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'LDAP bind requests',
  description: 'The rate at which LDAP bind requests are being made.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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

local ldapOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_ad_directory_operations_total{job=~"$job", instance=~"$instance", origin=~"ldap"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{operation}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'LDAP operations',
  description: 'The rate of LDAP read, search, and write operations.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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

local bindOperationsOverviewPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_ad_binds_total{job=~"$job", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{operation}}',
      format='time_series',
    ),
  ],
  type: 'table',
  title: 'Bind operations overview',
  description: 'Distribution of different types of operations performed on the Active Directory database.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'left',
        cellOptions: {
          type: 'auto',
        },
        filterable: false,
        inspect: true,
        minWidth: 150,
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
    overrides: [
      {
        matcher: {
          id: 'byRegexp',
          options: '/Digest|DS_client|DS_server|External|Fast|LDAP|Negotiate|NTLM|Simple/',
        },
        properties: [
          {
            id: 'custom.cellOptions',
            value: {
              mode: 'basic',
              type: 'gauge',
            },
          },
          {
            id: 'color',
            value: {
              mode: 'continuous-BlPu',
            },
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      fields: [],
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
    sortBy: [],
  },
  pluginVersion: '10.3.0-63516',
  transformations: [
    {
      id: 'joinByField',
      options: {
        byField: 'Time',
        mode: 'outer',
      },
    },
    {
      id: 'joinByLabels',
      options: {
        join: [
          'instance',
        ],
        value: 'bind_method',
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {},
        indexByName: {},
        renameByName: {
          digest: 'Digest',
          ds_client: 'DS_client',
          ds_server: 'DS_server',
          external: 'External',
          fast: 'Fast',
          instance: 'Instance',
          ldap: 'LDAP',
          'localhost:9182 - ': '',
          negotiate: 'Negotiate',
          ntlm: 'NTLM',
          simple: 'Simple',
        },
      },
    },
    {
      id: 'reduce',
      options: {
        includeTimeField: false,
        labelsToFields: false,
        mode: 'reduceFields',
        reducers: [
          'lastNotNull',
        ],
      },
    },
  ],
};

local replicationRow = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      '',
      datasource=promDatasource,
      legendFormat='',
    ),
  ],
  type: 'row',
  title: 'Replication',
  collapsed: false,
};

local intrasiteReplicationTrafficPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_ad_replication_data_intrasite_bytes_total{job=~"$job", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{direction}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Intrasite replication traffic',
  description: 'Rate of replication traffic between servers within the same site.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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
      unit: 'Bps',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [
        'min',
        'max',
        'mean',
      ],
      displayMode: 'table',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local intersiteReplicationTrafficPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_ad_replication_data_intersite_bytes_total{job=~"$job", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{direction}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Intersite replication traffic',
  description: 'Rate of replication traffic between servers across different sites.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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
      unit: 'Bps',
    },
    overrides: [],
  },
  options: {
    legend: {
      calcs: [
        'min',
        'max',
        'mean',
      ],
      displayMode: 'table',
      placement: 'bottom',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local inboundReplicationUpdatesPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_ad_replication_inbound_objects_updated_total{job=~"$job", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - objects',
      format='time_series',
    ),
    prometheus.target(
      'rate(windows_ad_replication_inbound_properties_updated_total{job=~"$job", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - properties',
    ),
  ],
  type: 'timeseries',
  title: 'Inbound replication updates',
  description: 'The rate of traffic received from other replication partners.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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
      calcs: [
        'min',
        'max',
        'mean',
      ],
      displayMode: 'table',
      placement: 'right',
      showLegend: true,
    },
    tooltip: {
      mode: 'multi',
      sort: 'desc',
    },
  },
};

local databaseRow = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: 'Database',
  collapsed: true,
};

local databaseOperationsOverviewPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_ad_database_operations_total{job=~"$job", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{operation}}',
      format='time_series',
    ),
  ],
  type: 'table',
  title: 'Database operations overview',
  description: 'Distribution of different types of operations performed on the Active Directory database.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'thresholds',
      },
      custom: {
        align: 'auto',
        cellOptions: {
          type: 'auto',
        },
        inspect: false,
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
    overrides: [
      {
        matcher: {
          id: 'byRegexp',
          options: '/Add|Delete|Modify|Recycle/',
        },
        properties: [
          {
            id: 'custom.cellOptions',
            value: {
              mode: 'basic',
              type: 'gauge',
              valueDisplayMode: 'text',
            },
          },
          {
            id: 'color',
            value: {
              mode: 'continuous-BlPu',
            },
          },
        ],
      },
    ],
  },
  options: {
    cellHeight: 'sm',
    footer: {
      countRows: false,
      fields: '',
      reducer: [
        'sum',
      ],
      show: false,
    },
    showHeader: true,
  },
  pluginVersion: '10.3.0-63516',
  transformations: [
    {
      id: 'joinByField',
      options: {
        byField: 'Time',
        mode: 'outer',
      },
    },
    {
      id: 'joinByLabels',
      options: {
        join: [
          'instance',
        ],
        value: 'operation',
      },
    },
    {
      id: 'reduce',
      options: {
        includeTimeField: false,
        labelsToFields: false,
        mode: 'reduceFields',
        reducers: [
          'lastNotNull',
        ],
      },
    },
    {
      id: 'organize',
      options: {
        excludeByName: {},
        includeByName: {},
        indexByName: {},
        renameByName: {
          add: 'Add',
          delete: 'Delete',
          instance: 'Instance',
          modify: 'Modify',
          recycle: 'Recycle',
        },
      },
    },
  ],
};

local databaseOperationsPanel = {
  datasource: promDatasource,
  targets: [
    prometheus.target(
      'rate(windows_ad_database_operations_total{job=~"$job", instance=~"$instance"}[$__rate_interval])',
      datasource=promDatasource,
      legendFormat='{{instance}} - {{operation}}',
      format='time_series',
    ),
  ],
  type: 'timeseries',
  title: 'Database operations',
  description: 'The rate of database operations.',
  fieldConfig: {
    defaults: {
      color: {
        mode: 'palette-classic',
      },
      custom: {
        axisBorderShow: false,
        axisCenteredZero: false,
        axisColorMode: 'text',
        axisLabel: '',
        axisPlacement: 'auto',
        barAlignment: 0,
        drawStyle: 'line',
        fillOpacity: 15,
        gradientMode: 'none',
        hideFrom: {
          legend: false,
          tooltip: false,
          viz: false,
        },
        insertNulls: false,
        lineInterpolation: 'smooth',
        lineWidth: 2,
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
      displayMode: 'table',
      placement: 'right',
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
    'windows-active-directory-overview.json':
      dashboard.new(
        'Active Directory overview',
        time_from='%s' % $._config.dashboardPeriod,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        description='',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Windows Active Directory dashboards',
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
            'label_values(windows_ad_binds_total,job)',
            label='Job',
            refresh=2,
            includeAll=false,
            multi=false,
            allValues='',
            sort=0
          ),
          template.new(
            'instance',
            promDatasource,
            'label_values(windows_ad_directory_operations_total{job=~"$job"},instance)',
            label='Instance',
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
          alertsPanel { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
          replicationPendingOperationsPanel { gridPos: { h: 4, w: 6, x: 12, y: 0 } },
          directoryServiceThreadsPanel { gridPos: { h: 4, w: 6, x: 18, y: 0 } },
          replicationPendingSynchronizationsPanel { gridPos: { h: 4, w: 12, x: 12, y: 4 } },
          ldapBindRequestsPanel { gridPos: { h: 9, w: 12, x: 0, y: 8 } },
          ldapOperationsPanel { gridPos: { h: 9, w: 12, x: 12, y: 8 } },
          bindOperationsOverviewPanel { gridPos: { h: 7, w: 24, x: 0, y: 17 } },
          replicationRow { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
          intrasiteReplicationTrafficPanel { gridPos: { h: 9, w: 12, x: 0, y: 25 } },
          intersiteReplicationTrafficPanel { gridPos: { h: 9, w: 12, x: 12, y: 25 } },
          inboundReplicationUpdatesPanel { gridPos: { h: 9, w: 24, x: 0, y: 34 } },
          databaseRow { gridPos: { h: 1, w: 24, x: 0, y: 43 } },
          databaseOperationsOverviewPanel { gridPos: { h: 9, w: 11, x: 0, y: 44 } },
          databaseOperationsPanel { gridPos: { h: 9, w: 13, x: 11, y: 44 } },
        ]
      ),
  },
}
