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
    span: 4,
    fieldConfig+: {
      defaults+: {
        color: { mode: 'continuous-blues' },
      },
    },
  };

local sessions_pie =
  pieChartPanel.new('Sessions', span=4, datasource='$datasource')
  .addTarget(grafana.prometheus.target(queries.sessions_by_type, legendFormat='{{type}}'))
  + piechartupdate +
  {
    span: 4,
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
  + piechartupdate +
  { span: 4 };

{
  grafanaDashboards+:: {
    'awx.json':
      dashboard.new(
        'AWX',
        uid=dashboardUid,
        time_from='now-1h',
      ).addTemplates([
        ds_template,
        job_template,
        instance_template,
      ])
      .addRow(
        row.new('Overview')
        .addPanel(sessions_pie)
        .addPanel(cluster_objs)
        .addPanel(hosts_pie)
      ),
  },
}
