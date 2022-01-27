local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local statPanel = grafana.statPanel;
local pieChartPanel = grafana.pieChartPanel;

local dashboardUid = 'eqcdR8HDA';

local matcher = 'job=~"$job", instance=~"$instance"';

local queries = {
  awx_system_info: 'awx_system_info{' + matcher + '}',
  orgs_total: 'sum (awx_organizations_total{' + matcher + '})',
  users_total: 'sum (awx_users_total{' + matcher + '})',
  teams_total: 'sum (awx_teams_total{' + matcher + '})',
  inventories_total: 'sum (awx_inventories_total{' + matcher + '})',
  projects_total: 'sum (awx_projects_total{' + matcher + '})',
  job_templates_total: 'sum (awx_job_templates_total{' + matcher + '})',
  workflow_job_templates_total: 'sum (awx_workflow_job_templates_total{' + matcher + '})',
  active_hosts: 'sum (awx_hosts_total{type="active", ' + matcher + '})',
  inactive_hosts: 'sum (awx_hosts_total{type="total", ' + matcher + '}) - ' + queries.active_hosts,
  schedules_total: 'sum (awx_schedules_total{' + matcher + '})',
  sessions_by_type: 'sum by (type) (awx_sessions_total{' + matcher + '})',

  license_expiry_seconds: '',
  external_logging: '',
};

// Templates
local ds_template = {
  current: {
    text: 'default',
    value: 'default',
  },
  hide: 0,
  label: 'Data Source',
  name: 'datasource',
  options: [],
  query: 'prometheus',
  refresh: 1,
  regex: '',
  type: 'datasource',
};

local job_template =
  grafana.template.new(
    'job',
    '$datasource',
    'label_values(rclone_speed, job)',
    label='job',
    refresh='load',
    multi=true,
    includeAll=true,
    allValues='.+',
    sort=1,
  );

local instance_template =
  grafana.template.new(
    'instance',
    '$datasource',
    'label_values(rclone_speed{job=~"$job"}, instance)',
    refresh='load',
    multi=true,
    includeAll=true,
    allValues='.+',
    sort=1,
  );

// Local styles and overrides
local piechartupdate =
  {
    type: 'piechart',
    options: {
      reduceOptions: {
        values: false,
        calcs: [
          'lastNotNull',
        ],
        fields: '',
      },
      pieType: 'donut',
      tooltip: {
        mode: 'single',
      },
      legend: {
        displayMode: 'table',
        placement: 'right',
        values: [
          'value',
          'percent',
        ],
      },
    },
  };

// Utilities
/* This is a helper function to allow a panel to reference a query from another panel, reducing the cost of loading a dashboard
by not repeating queries.

The `panels` input parameter is expected to be a flat array of panels. I.E. No panels which themselves have a "panels" property, as used by the old rows pattern.

Panels may either announce themselves as a publisher of shared queries, or specify that they subscribe to one or more queries.

Publishing panels must have a hidden property named `target_publisher` which can be set to any value, this function only checks
that it is present.

Subscribing panels must have a hidden property named `target_subscriber` which is an array of queries to match from publishing panels.

Example:
```
local query = 'up{job=~"$job"}';
local query1 = 'foo{job=~"$job"}';

local pub_panel = statPanel.new('zero').addTarget(grafana.prometheus.target(query)) + { target_publisher:: true };
local pub_panel1 = statPanel.new('one').addTarget(grafana.prometheus.target(query)) + { target_publisher:: true };

local sub_panel = statPanel.new('sub') + { target_subscriber: [query, query1] };

local rendered_dash =
  dashboard.new('dash')
  .addPanels([
    row.new('Dont nest panels in rows'),
    pub_panel,
    pub_panel1,
    sub_panel,
  ]);

{
  grafanaDashboards+:: {
    'dashboard.json':
      rendered_dash
      + target_matchmake(rendered_dash.panels),
  },
}
```
*/
local target_matchmake(panels) = {
  pubMap:: {
    [pubT.expr]: { panel: pubP, target: pubT }
    for pubP in std.filter(function(p) std.objectHasAll(p, 'target_publisher'), panels)
    for pubT in pubP.targets
  },
  panels:
    std.map(
      function(p)
        if std.objectHasAll(p, 'target_subscriber') then
          p {
            targets+: std.map(function(sub) {
              panelId: $.pubMap[sub].panel.id,
              refId: $.pubMap[sub].target.refId,
            }, p.target_subscriber),
          }
        else p, panels
    ),
};

// Panels
local cluster_objs =
  statPanel.new(
    'Cluster Objects',
    datasource='$datasource',
    colorMode='background',
    graphMode='none',
    justifyMode='center',
    orientation='vertical',
  )
  .addTargets([
    grafana.prometheus.target(queries.orgs_total, legendFormat='Orgs'),
    grafana.prometheus.target(queries.teams_total, legendFormat='Teams'),
    grafana.prometheus.target(queries.projects_total, legendFormat='Projects'),
    grafana.prometheus.target(queries.schedules_total, legendFormat='Schedules'),
  ]) +
  {
    fieldConfig+: {
      defaults+: {
        color: { mode: 'continuous-blues' },
      },
    },
  };

local sessions_pie =
  pieChartPanel.new('Sessions', datasource='$datasource')
  .addTarget(grafana.prometheus.target(queries.sessions_by_type, legendFormat='{{type}}'))
  + piechartupdate +
  {
    fieldConfig+: {
      overrides+: [
        {
          matcher: {
            id: 'byName',
            options: 'anonymous',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Anonymous',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'user',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Authenticated',
            },
          ],
        },
      ],
    },
    transformations: [
      {
        id: 'filterFieldsByName',
        options: {
          include: {
            names: [
              'Time',
              'anonymous',
              'user',
            ],
          },
        },
      },
    ],
  };

local hosts_pie =
  pieChartPanel.new('Hosts', datasource='$datasource')
  .addTarget(grafana.prometheus.target(queries.active_hosts, legendFormat='Active'))
  .addTarget(grafana.prometheus.target(queries.inactive_hosts, legendFormat='Inactive'))
  + piechartupdate;

local tower_ver_stat =
  statPanel.new('Tower Version', datasource='$datasource', colorMode='background', graphMode='none')
  .addTarget(grafana.prometheus.target(queries.awx_system_info)) +
  {
    target_publisher:: true,
    options+: {
      reduceOptions: {
        values: false,
        calcs: [
          'lastNotNull',
        ],
        fields: '/^tower_version$/',
      },
    },
    fieldConfig+: {
      defaults+: {
        color: { mode: 'palette-classic' },
      },
    },
    transformations: [
      {
        id: 'labelsToFields',
      },
    ],
  };

local license_expiry_stat =
  statPanel.new('License Expiry', datasource='$datasource', colorMode='background', graphMode='none', unit='s')
  .addThresholds([
    {
      color: 'red',
      value: null,
    },
    {
      color: '#EAB839',
      value: 7776000,
    },
    {
      color: 'super-light-green',
      value: 15552000,
    },
    {
      value: 31536000,
      color: 'green',
    },
  ]) +
  {
    target_subscriber:: [queries.awx_system_info],
    options+: {
      reduceOptions: {
        values: false,
        calcs: [
          'lastNotNull',
        ],
        fields: '/^license_expiry$/',
      },
    },
    fieldConfig+: {
      defaults+: {
        color: { mode: 'thresholds' },
      },
    },
    transformations: [
      {
        id: 'labelsToFields',
      },
    ],
  };

local awx_dashboard =
  dashboard.new(
    'AWX',
    uid=dashboardUid,
    time_from='now-1h',
  ).addTemplates([
    ds_template,
    job_template,
    instance_template,
  ])
  .addPanels([
    row.new('Overview'),
    sessions_pie { gridPos: { x: 0, y: 1, w: 8, h: 8 } },
    cluster_objs { gridPos: { x: 8, y: 1, w: 8, h: 8 } },
    hosts_pie { gridPos: { x: 16, y: 1, w: 8, h: 8 } },
    tower_ver_stat { gridPos: { x: 0, y: 8, w: 3, h: 3 } },
    license_expiry_stat { gridPos: { x: 0, y: 11, w: 3, h: 3 } },
  ]);

{
  grafanaDashboards+:: {
    'awx.json':
      awx_dashboard
      + target_matchmake(awx_dashboard.panels),
  },
}
