local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local timeSeries = g.panel.timeSeries;
local stat = g.panel.stat;
local table = g.panel.table;
local pieChart = g.panel.pieChart;
local geomap = g.panel.geomap;
local logs = g.panel.logs;
local filters = |||
  device_name=~"$device_name",
  network_local_address=~"$network_local_address",
  network_peer_address=~"$network_peer_address",
  job=~"$job"
|||;
{
  totalTraffic: timeSeries.new('Total traffic')
                + timeSeries.panelOptions.withDescription('Total observed traffic, aggregated by receiving device')
                + timeSeries.queryOptions.withInterval('1m')
                + timeSeries.queryOptions.withTargets(
                  [
                    g.query.prometheus.new(
                      '$prometheus_datasource',
                      |||
                        sum(network_io_by_flow_bytes{%s}) by (device_name)
                      ||| % [filters],
                    ),
                  ]
                )
                + timeSeries.panelOptions.withTransparent(true)
                + timeSeries.standardOptions.withUnit('bytes')
                + timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
                + timeSeries.fieldConfig.defaults.custom.withAxisPlacement('right')
                + timeSeries.options.legend.withShowLegend(false),

  stats: stat.new('')
         + stat.panelOptions.withDescription('Known sources, destinations, endpoints and total overall traffic')
         + stat.queryOptions.withInterval('1m')
         + stat.queryOptions.withTargets(
           [
             g.query.prometheus.new(
               '$prometheus_datasource',
               |||
                 count(count(network_io_by_flow_bytes{%s}) by (device_name))
               ||| % [filters],
             )
             + g.query.prometheus.withLegendFormat('Collecting devices'),
             g.query.prometheus.new(
               '$prometheus_datasource',
               |||
                 count(count(network_io_by_flow_bytes{%s}) by (network_local_address))
               ||| % [filters],
             )
             + g.query.prometheus.withLegendFormat('Sources'),
             g.query.prometheus.new(
               '$prometheus_datasource',
               |||
                 count(count(network_io_by_flow_bytes{%s}) by (network_peer_address))
               ||| % [filters],
             )
             + g.query.prometheus.withLegendFormat('Destinations'),
             g.query.prometheus.new(
               '$prometheus_datasource',
               |||
                 sum(sum_over_time(network_io_by_flow_bytes{%s}[$__range]))
               ||| % [filters],
             )
             + g.query.prometheus.withLegendFormat('Total observed traffic')
             + g.query.prometheus.withRefId('TotalTraffic'),
           ]
         )
         + stat.standardOptions.withOverrides([{
           matcher: {
             id: 'byFrameRefID',
             options: 'TotalTraffic',
           },
           properties: [
             {
               id: 'unit',
               value: 'bytes',
             },
           ],
         }])
         + stat.standardOptions.withMin(0)
         + { fieldConfig+: { defaults+: { fieldMinMax: true } } }
         + stat.standardOptions.color.withMode('palette-classic')
         + stat.options.withColorMode('background')
         + stat.panelOptions.withTransparent(true),


  topSources: table.new('Top sources')
              + table.panelOptions.withDescription('Source adresses ordered by observed traffic during the time range')
              + table.standardOptions.withOverrides([
                {
                  matcher: {
                    id: 'byName',
                    options: 'Value (sum)',
                  },
                  properties: [
                    {
                      id: 'custom.cellOptions',
                      value: {
                        mode: 'basic',
                        type: 'gauge',
                        valueDisplayMode: 'color',
                      },
                    },
                    {
                      id: 'unit',
                      value: 'bytes',
                    },
                  ],
                },
              ])
              + table.standardOptions.color.withMode('fixed')
              + table.standardOptions.color.withFixedColor('green')
              + table.queryOptions.withInterval('1m')
              + table.queryOptions.withTargets([
                g.query.prometheus.new(
                  '$prometheus_datasource',
                  |||
                    topk(5,network_io_by_flow_bytes{%s})
                  ||| % [filters],
                )
                + g.query.prometheus.withFormat('table'),
              ])
              + table.queryOptions.withTransformationsMixin([
                {
                  id: 'groupBy',
                  options: {
                    fields: {
                      Value: {
                        aggregations: [
                          'sum',
                        ],
                        operation: 'aggregate',
                      },
                      network_local_address: {
                        aggregations: [],
                        operation: 'groupby',
                      },
                      network_peer_address: {
                        aggregations: [
                          'distinctCount',
                        ],
                        operation: 'aggregate',
                      },
                      network_protocol_name: {
                        aggregations: [
                          'distinctCount',
                        ],
                        operation: 'aggregate',
                      },
                    },
                  },
                },
                {
                  id: 'organize',
                  options: {
                    excludeByName: {},
                    includeByName: {},
                    indexByName: {
                      'Value (sum)': 3,
                      network_local_address: 0,
                      'network_peer_address (distinctCount)': 2,
                      'network_protocol_name (distinctCount)': 1,
                    },
                    renameByName: {
                      'Value (sum)': 'Bytes transferred',
                      network_local_address: 'Source',
                      'network_peer_address (distinctCount)': 'Destinations',
                      'network_protocol_name (distinctCount)': 'Protocols',
                    },
                  },
                },
                {
                  id: 'sortBy',
                  options: {
                    fields: {},
                    sort: [
                      {
                        desc: true,
                        field: 'Bytes transferred',
                      },
                    ],
                  },
                },
              ]),
  topDestinations: self.topSources
                   + table.panelOptions.withTitle('Top destinations')
                   + table.panelOptions.withDescription('Destination adresses ordered by observed traffic during the time range')
                   + table.queryOptions.withInterval('1m')
                   + table.queryOptions.withTransformations([
                     {
                       id: 'groupBy',
                       options: {
                         fields: {
                           Value: {
                             aggregations: [
                               'sum',
                             ],
                             operation: 'aggregate',
                           },
                           device_name: {
                             aggregations: [
                               'distinctCount',
                             ],
                           },
                           network_local_address: {
                             aggregations: [
                               'distinctCount',
                             ],
                             operation: 'aggregate',
                           },
                           network_peer_address: {
                             aggregations: [
                               'distinctCount',
                             ],
                             operation: 'groupby',
                           },
                           network_protocol_name: {
                             aggregations: [
                               'distinctCount',
                             ],
                             operation: 'aggregate',
                           },
                         },
                       },
                     },
                     {
                       id: 'organize',
                       options: {
                         excludeByName: {},
                         includeByName: {},
                         indexByName: {
                           'Value (sum)': 3,
                           'network_local_address (distinctCount)': 2,
                           network_peer_address: 0,
                           'network_protocol_name (distinctCount)': 1,
                         },
                         renameByName: {
                           'Value (sum)': 'Bytes Transferred',
                           'device_name (distinctCount)': 'Devices',
                           network_local_address: 'Source',
                           'network_local_address (distinctCount)': 'Sources',
                           network_peer_address: 'Destination',
                           'network_peer_address (distinctCount)': 'Devices',
                           'network_protocol_name (distinctCount)': 'Protocols',
                         },
                       },
                     },
                     {
                       id: 'sortBy',
                       options: {
                         fields: {},
                         sort: [
                           {
                             desc: true,
                             field: 'Bytes transferred',
                           },
                         ],
                       },
                     },
                   ]),
  conversationTotalBytes: table.new('Conversation total bytes')
                          + table.panelOptions.withDescription('Source/Destination pairs and their total traffic across all dimensions. Ordered by total traffic during selected time range')
                          + table.standardOptions.withOverrides([
                            {
                              matcher: {
                                id: 'byType',
                                options: 'string',
                              },
                              properties: [
                                {
                                  id: 'custom.filterable',
                                  value: true,
                                },
                              ],
                            },
                            {
                              matcher: {
                                id: 'byName',
                                options: 'Value',
                              },
                              properties: [
                                {
                                  id: 'custom.cellOptions',
                                  value: {
                                    mode: 'basic',
                                    type: 'gauge',
                                  },
                                },
                              ],
                            },
                          ])
                          + table.standardOptions.color.withMode('continuous-BlPu')
                          + table.standardOptions.withUnit('bytes')
                          + table.options.footer.withEnablePagination(true)
                          + table.queryOptions.withInterval('1m')
                          + table.queryOptions.withTargets([
                            g.query.prometheus.new(
                              '$prometheus_datasource',
                              |||
                                sum(
                                  sum_over_time(network_io_by_flow_bytes{%s}[$__range])
                                ) by (network_local_address,network_peer_address)
                              ||| % [filters],
                            )
                            + g.query.prometheus.withInstant(true)
                            + g.query.prometheus.withFormat('table'),
                          ])
                          + table.queryOptions.withTransformations([
                            {
                              id: 'sortBy',
                              options: {
                                fields: {},
                                sort: [
                                  {
                                    desc: true,
                                    field: 'Value',
                                  },
                                ],
                              },
                            },
                            {
                              id: 'organize',
                              options: {
                                excludeByName: {
                                  Time: true,
                                },
                                includeByName: {},
                                indexByName: {},
                                renameByName: {
                                  Value: 'Bytes',
                                  network_local_address: 'Source',
                                  network_peer_address: 'Destination',
                                },
                              },
                            },
                          ]),

  conversationTraffic: timeSeries.new('Conversation traffic over time')
                       + timeSeries.panelOptions.withDescription('Traffic distribution of source/destination pairs over time')
                       + timeSeries.panelOptions.withTransparent(true)
                       + timeSeries.standardOptions.withUnit('bytes')
                       + timeSeries.options.legend.withShowLegend(false)
                       + timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
                       + timeSeries.fieldConfig.defaults.custom.withFillOpacity(80)
                       + timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal', group: 'A' })
                       + timeSeries.queryOptions.withInterval('1m')
                       + timeSeries.queryOptions.withTargets([
                         g.query.prometheus.new('$prometheus_datasource',
                                                |||
                                                  sum(network_io_by_flow_bytes{%s}) by (network_local_address,network_peer_address,device_name)
                                                ||| % [filters]),
                       ]),

  conversationByPair: pieChart.new('Breakdown by source/destination pair')
                      + pieChart.panelOptions.withDescription('Breakdown of total traffic between source/destination pairs observed during the selected time range')
                      + pieChart.panelOptions.withTransparent(true)
                      + pieChart.options.legend.withPlacement('right')
                      + pieChart.options.legend.withValues(['value'])
                      + pieChart.standardOptions.withUnit('bytes')
                      + pieChart.options.withPieType('donut')
                      + pieChart.options.reduceOptions.withValues(true)
                      + pieChart.queryOptions.withInterval('1m')
                      + pieChart.queryOptions.withTargets([
                        g.query.prometheus.new(
                          '$prometheus_datasource',
                          |||
                            sum(sum_over_time(network_io_by_flow_bytes{%s}[$__range])) by (network_local_address,network_peer_address)
                          ||| % [filters],
                        )
                        + g.query.prometheus.withInstant(true)
                        + g.query.prometheus.withFormat('table'),
                      ]),
  protocolTotalBytes: table.new('Total bytes')
                      + table.panelOptions.withDescription('List of protocols and the total amount of observed traffic during the selected time range')
                      + table.standardOptions.color.withMode('continuous-BlPu')
                      + table.standardOptions.withUnit('bytes')
                      + table.standardOptions.withOverrides([
                        {
                          matcher: {
                            id: 'byName',
                            options: 'Value',
                          },
                          properties: [
                            {
                              id: 'custom.cellOptions',
                              value: {
                                mode: 'basic',
                                type: 'gauge',
                                valueDisplayMode: 'color',
                              },
                            },
                          ],
                        },
                      ])
                      + table.queryOptions.withInterval('1m')
                      + table.queryOptions.withTargets([
                        g.query.prometheus.new(
                          '$prometheus_datasource',
                          |||
                            sum(sum_over_time(network_io_by_flow_bytes{%s}[$__range])) by (network_protocol_name)
                          ||| % [filters],
                        )
                        + g.query.prometheus.withInstant(true)
                        + g.query.prometheus.withFormat('table'),
                      ])
                      + table.queryOptions.withTransformations([
                        {
                          id: 'sortBy',
                          options: {
                            fields: {},
                            sort: [
                              {
                                desc: true,
                                field: 'Value',
                              },
                            ],
                          },
                        },
                        {
                          id: 'organize',
                          options: {
                            excludeByName: {
                              Time: true,
                            },
                            includeByName: {},
                            indexByName: {},
                            renameByName: {
                              Value: 'Bytes',
                              network_protocol_name: 'Protocol',
                            },
                          },
                        },
                      ]),
  protocolDistribution: pieChart.new('Distribution')
                        + pieChart.panelOptions.withDescription('Distribution of protocols and the total amount of observed traffic during the selected time range')
                        + pieChart.panelOptions.withTransparent(true)
                        + pieChart.options.legend.withDisplayMode('table')
                        + pieChart.options.legend.withPlacement('right')
                        + pieChart.options.legend.withValues(['value'])
                        + pieChart.standardOptions.withUnit('bytes')
                        + pieChart.options.withPieType('donut')
                        + pieChart.options.reduceOptions.withValues(true)
                        + pieChart.queryOptions.withInterval('1m')
                        + pieChart.queryOptions.withTargets([
                          g.query.prometheus.new(
                            '$prometheus_datasource',
                            |||
                              sum(sum_over_time(network_io_by_flow_bytes{%s}[$__range])) by (network_protocol_name)
                            ||| % [filters],
                          )
                          + g.query.prometheus.withLegendFormat('{{network_protocol_name}}')
                          + g.query.prometheus.withInstant(true),
                        ]),
  protocolOverTime: timeSeries.new('Protocol traffic over time')
                    + pieChart.panelOptions.withDescription('Protocols and the amount of observed traffic over the selected time range')
                    + timeSeries.panelOptions.withTransparent(true)
                    + timeSeries.standardOptions.withUnit('bytes')
                    + timeSeries.fieldConfig.defaults.custom.withDrawStyle('bars')
                    + timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal', group: 'A' })
                    + timeSeries.fieldConfig.defaults.custom.withFillOpacity(80)
                    + timeSeries.queryOptions.withMaxDataPoints(20)
                    + timeSeries.queryOptions.withInterval('1m')
                    + timeSeries.queryOptions.withTargets([
                      g.query.prometheus.new(
                        '$prometheus_datasource',
                        |||
                          sum(sum_over_time(network_io_by_flow_bytes{%s}[$__interval])) by (network_protocol_name)
                        ||| % [filters],
                      )
                      + g.query.prometheus.withLegendFormat('{{network_protocol_name}}'),
                    ]),
  topDestinationMap: geomap.new('Top destination')
                     + geomap.panelOptions.withDescription('Geographic heatmap showing the total amount of traffic to specific countries')
                     + geomap.standardOptions.withUnit('bytes')
                     + geomap.standardOptions.color.withMode('continuous-BlPu')
                     + geomap.options.withLayers([
                       {
                         config: {
                           blur: 19,
                           radius: 21,
                           weight: {
                             fixed: 1,
                             max: 1,
                             min: 0,
                           },
                         },
                         filterData: {
                           id: 'byRefId',
                           options: 'A',
                         },
                         location: {
                           lookup: 'network_peer_country',
                           mode: 'lookup',
                         },
                         name: 'Destinations',
                         opacity: 0.5,
                         tooltip: true,
                         type: 'heatmap',
                       },
                     ])
                     + geomap.queryOptions.withInterval('1m')
                     + geomap.queryOptions.withTargets([
                       g.query.prometheus.new(
                         '$prometheus_datasource',
                         |||
                           sum(sum_over_time(network_io_by_flow_bytes{%s,network_peer_country!="Private IP"}[$__range])) by (network_peer_country)
                         ||| % [filters],
                       )
                       + g.query.prometheus.withFormat('table')
                       + g.query.prometheus.withInstant(true),
                     ]),
  destinationsLegend: table.new('')
                      + table.panelOptions.withDescription('Total traffic to specific countries during the selected time range')
                      + table.standardOptions.withUnit('bytes')
                      + table.standardOptions.color.withMode('continuous-BlPu')
                      + table.queryOptions.withInterval('1m')
                      + table.queryOptions.withTargets(self.topDestinationMap.targets)
                      + table.options.footer.withEnablePagination(true)
                      + table.standardOptions.withOverrides([
                        {
                          matcher: {
                            id: 'byName',
                            options: 'Value',
                          },
                          properties: [
                            {
                              id: 'custom.cellOptions',
                              value: {
                                mode: 'basic',
                                type: 'gauge',
                              },
                            },
                          ],
                        },
                        {
                          matcher: {
                            id: 'byType',
                            options: 'string',
                          },
                          properties: [
                            {
                              id: 'custom.filterable',
                              value: true,
                            },
                            {
                              id: 'custom.width',
                              value: 100,
                            },
                          ],
                        },
                      ])
                      + table.queryOptions.withTransformations([
                        {
                          id: 'sortBy',
                          options: {
                            fields: {},
                            sort: [
                              {
                                desc: true,
                                field: 'Value',
                              },
                            ],
                          },
                        },
                        {
                          id: 'organize',
                          options: {
                            excludeByName: {
                              Time: true,
                            },
                            includeByName: {},
                            indexByName: {},
                            renameByName: {
                              Value: 'Bytes',
                              network_peer_country: 'Country',
                              network_local_country: 'Country',
                            },
                          },
                        },
                      ]),
  topSourcesMap: self.topDestinationMap
                 + geomap.panelOptions.withTitle('Top sources')
                 + geomap.panelOptions.withDescription('Geographic heatmap showing the total amount of traffic from specific countries')
                 + geomap.options.withLayers([
                   {
                     config: {
                       blur: 19,
                       radius: 21,
                       weight: {
                         fixed: 1,
                         max: 1,
                         min: 0,
                       },
                     },
                     filterData: {
                       id: 'byRefId',
                       options: 'A',
                     },
                     location: {
                       lookup: 'network_local_country',
                       mode: 'lookup',
                     },
                     name: 'Destinations',
                     opacity: 0.5,
                     tooltip: true,
                     type: 'heatmap',
                   },
                 ])
                 + geomap.queryOptions.withTargets([
                   g.query.prometheus.new(
                     '$prometheus_datasource',
                     |||
                       sum(sum_over_time(network_io_by_flow_bytes{%s,network_local_country!="Private IP"}[$__range])) by (network_local_country)
                     ||| % [filters],
                   )
                   + g.query.prometheus.withFormat('table')
                   + g.query.prometheus.withInstant(true),
                 ]),
  sourcesLegend: self.destinationsLegend
                 + table.panelOptions.withDescription('Total traffic from specific countries during the selected time range')
                 + table.queryOptions.withTargets(self.topSourcesMap.targets),
  collectorLogs: logs.new('Collector logs')
                 + logs.panelOptions.withDescription('Logs of the ktranslate instance')
                 + logs.queryOptions.withTargets([
                   g.query.loki.new(
                     '$loki_datasource',
                     |||
                       {service_name="integrations/ktranslate-netflow"}
                     |||,
                   ),
                 ]),
  deviceStats: stat.new('Devices sending flows')
               + stat.panelOptions.withDescription('Protocol statistics per device sending them')
               + stat.standardOptions.withUnit('bytes')
               + stat.options.withColorMode('background')
               + stat.options.withTextMode('value_and_name')
               + stat.standardOptions.color.withMode('palette-classic')
               + stat.queryOptions.withInterval('1m')
               + stat.queryOptions.withTargets([
                 g.query.prometheus.new(
                   '$prometheus_datasource',
                   |||
                     sum(network_io_by_flow_bytes{%s}) by (device_name)
                   ||| % [filters],
                 )
                 + g.query.prometheus.withLegendFormat('{{device_name}}'),

               ]),
}
