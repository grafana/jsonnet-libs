// variables.libsonnet
local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(
    groupLabels,
    instanceLabels,
    variables,
  ): {

    local promDatasource = {
      uid: '${%s}' % variables.datasources.prometheus.name,
    },
    osRolesTimeline:
      g.panel.statusHistory.new('Roles timeline')
      + g.panel.statusHistory.panelOptions.withDescription('OpenSearch node roles over time.')
      + g.panel.statusHistory.options.withShowValue('never')
      + g.panel.statusHistory.options.withLegend(false)
      + g.panel.statusHistory.queryOptions.withMaxDataPoints(100)
      + g.panel.statusHistory.queryOptions.withTargets(
        [
          g.query.prometheus.new(
            promDatasource.uid,
            |||
              max by (node,role) (
                  max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="data"}[1m]) == 1
              ) * 2
            |||
            % {
              queriesSelector: variables.queriesSelector,
            },
          )
          + g.query.prometheus.withLegendFormat('{{node}}'),
          g.query.prometheus.new(
            promDatasource.uid,
            |||
              max by (node,role) (
                  max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="master"}[1m]) == 1
              ) * 3
            |||
            % { queriesSelector: variables.queriesSelector },
          )
          + g.query.prometheus.withLegendFormat('{{node}}'),
          g.query.prometheus.new(
            promDatasource.uid,
            |||
              max by (node,role) (
                  max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="ingest"}[1m]) == 1
              ) * 4
            |||
            % { queriesSelector: variables.queriesSelector },
          )
          + g.query.prometheus.withLegendFormat('{{node}}'),
          g.query.prometheus.new(
            promDatasource.uid,
            |||
              max by (node,role) (
                  max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="cluster_manager"}[1m]) == 1
              ) * 5
            |||
            % { queriesSelector: variables.queriesSelector },
          )
          + g.query.prometheus.withLegendFormat('{{node}}'),
          g.query.prometheus.new(
            promDatasource.uid,
            |||
              max by (node,role) (
                  max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="remote_cluster_client"}[1m]) == 1
              ) * 6
            |||
            % { queriesSelector: variables.queriesSelector },
          )
          + g.query.prometheus.withLegendFormat('{{node}}'),
        ]
      )
      + g.panel.statusHistory.standardOptions.withMappings([
        {
          type: 'value',
          options: {
            '2': {
              color: 'light-purple',
              index: 0,
              text: 'data',
            },
            '3': {
              color: 'light-green',
              index: 1,
              text: 'master',
            },
            '4': {
              color: 'light-blue',
              index: 2,
              text: 'ingest',
            },
            '5': {
              text: 'cluster_manager',
              color: 'light-yellow',
              index: 3,
            },
            '6': {
              text: 'remote_cluster_client',
              color: 'super-light-red',
              index: 4,
            },
          },
        },
      ]),

    osRoles:
      g.panel.table.new('Roles')
      + g.panel.table.panelOptions.withDescription('OpenSearch node roles.')
      + g.panel.table.queryOptions.withTargets([
        g.query.prometheus.new(
          promDatasource.uid,
          'max by (%(agg)s) (last_over_time(opensearch_node_role_bool{%(queriesSelector)s}[1d]))'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', groupLabels + instanceLabels + ['node', 'nodeid', 'role', 'primary_ip']),
          },
        )
        + g.query.prometheus.withLegendFormat(utils.labelsToPanelLegend(instanceLabels))
        + g.query.prometheus.withInstant(true),
      ])
      + g.panel.table.standardOptions.withMappings([
        {
          options: {
            '0': {
              color: 'super-light-orange',
              index: 5,
              text: 'False',
            },
            '1': {
              color: 'light-green',
              index: 3,
              text: 'True',
            },
            Data: {
              color: 'light-purple',
              index: 0,
              text: 'data',
            },
            Ingest: {
              color: 'light-blue',
              index: 2,
              text: 'ingest',
            },
            Master: {
              color: 'light-green',
              index: 1,
              text: 'master',
            },
            'Remote cluster client': {
              color: 'light-orange',
              index: 4,
              text: 'remote_cluster_client',
            },
          },
          type: 'value',
        },
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byRegexp',
            options: '/Data|Master|Ingest|Remote.+|Cluster.+/',
          },
          properties: [
            {
              id: 'custom.cellOptions',
              value: {
                type: 'color-text',
              },
            },
          ],
        },
      ])
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'labelsToFields',
          options: {
            mode: 'columns',
            valueLabel: 'role',
          },
        },
        {
          id: 'merge',
          options: {},
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
            },
            indexByName: {
              Time: 0,  // hide time
              node: 3,
              nodeid: 3,
              master: 104,
              data: 105,
              ingest: 106,
              remote_cluster_client: 107,
              cluster_manager: 108,
            } + {
              [k]: 3
              for k in groupLabels + instanceLabels
            }
            ,
            renameByName: {
              Time: '',
              cluster: 'Cluster',
              //roles:
              cluster_manager: 'Cluster manager',
              data: 'Data',
              ingest: 'Ingest',
              master: 'Master',
              node: 'Node',
              nodeid: 'Nodeid',
              remote_cluster_client: 'Remote cluster client',
            },
          },
        },
      ]),
  },
}
