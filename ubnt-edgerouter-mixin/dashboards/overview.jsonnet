local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;

local gBuilder = import 'grafana-builder/grafana.libsonnet';

local sharedMatcher = 'job=~"$job", instance=~"$instance"';

{
  queries:: {
    sysName: 'sysName{' + sharedMatcher + '}',
    sysDescr: 'sysDescr{' + sharedMatcher + '}',
    sysContact: 'sysContact{' + sharedMatcher + '}',
    sysLocation: 'sysLocation{' + sharedMatcher + '}',
    sysUptime: 'hrSystemUptime{' + sharedMatcher + '} / 100',  // Somehow this is neither seconds nor milliseconds, but rather 100th's of a second? ¯\_(ツ)_/¯
    sysUsers: 'hrSystemNumUsers{' + sharedMatcher + '}',
    sysProcesses: 'hrSystemProcesses{' + sharedMatcher + '}',
  },

  panels:: {
    infoTable:
      gBuilder.tablePanel(
        [$.queries.sysName, $.queries.sysDescr, $.queries.sysContact, $.queries.sysLocation],
        {
          sysName: { alias: 'Name' },
          snmp_target: { alias: 'Hostname' },
          sysDescr: { alias: 'Description' },
          sysContact: { alias: 'Contact' },
          sysLocation: { alias: 'Location' },
        },
      ) +
      {
        datasource: '$datasource',
        transformations: [
          {
            id: 'joinByField',
            options: {
              byField: 'snmp_target',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                pattern: 'snmp_target|sys(Name|Descr|Contact|Location)',
              },
            },
          },
          {
            id: 'organize',
            options: {
              excludeByName: {},
              indexByName: {
                sysName: 0,
                snmp_target: 1,
                sysDescr: 2,
                sysContact: 3,
                sysLocation: 4,
              },
              renameByName: {},
            },
          },
        ],
      },
    sysUptime:
      grafana.statPanel.new(
        'Uptime',
        datasource='$datasource',
        colorMode='background',
        graphMode='none',
        noValue='No Data',
        unit='s',
        reducerFunction='last',
      )
      .addTarget(
        grafana.prometheus.target($.queries.sysUptime),
      ) + $.fixedColorMode('light-blue'),
    users:
      grafana.statPanel.new(
        'Users',
        datasource='$datasource',
        colorMode='background',
        noValue='No Data',
        reducerFunction='last',
      )
      .addTarget(
        grafana.prometheus.target($.queries.sysUsers),
      ) + $.fixedColorMode('light-purple'),
    processes:
      grafana.statPanel.new(
        'Processes',
        datasource='$datasource',
        colorMode='background',
        noValue='No Data',
        reducerFunction='last',
      )
      .addTarget(
        grafana.prometheus.target($.queries.sysProcesses),
      ) + $.fixedColorMode('light-blue'),
  },

  fixedColorMode(color):: {
    fieldConfig+: {
      defaults+: {
        color: {
          mode: 'fixed',
          fixedColor: color,
        },
      },
    },
  },

  grafanaDashboards+:: {
    'ubnt-edgrouterx-overview.json':
      dashboard.new(
        'UBNT EdgeRouter X Overview',
        time_from='now-1h',
      ).addTemplates([
        // Data Source
        {
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
        },
        // Job
        grafana.template.new(
          'job',
          '$datasource',
          'label_values(up{snmp_target!=""}, job)',
          label='job',
          refresh='load',
          multi=true,
          includeAll=true,
          allValues='.+',
          sort=1,
        ),
        // Instance
        grafana.template.new(
          'instance',
          '$datasource',
          'label_values(up{snmp_target!="", job=~"$job"}, instance)',
          label='instance',
          refresh='load',
          multi=true,
          includeAll=true,
          allValues='.+',
          sort=1,
        ),
      ])
      .addRow(
        row.new()
        .addPanel($.panels.infoTable { span: 12, height: 3 })
      )
      .addRow(
        row.new()
        .addPanel($.panels.sysUptime)
        .addPanel($.panels.users)
        .addPanel($.panels.processes),
      ),
  },
}
