local commonlib = import 'common-lib/common/main.libsonnet';
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
local signals = import '../signals/main.libsonnet';
{
  trafficRate: signals.trafficRate.asTimeSeries()
               + timeSeries.panelOptions.withTransparent(true)
               + timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
               + timeSeries.fieldConfig.defaults.custom.withAxisPlacement('right')
               + timeSeries.options.legend.withShowLegend(false),

  stats: stat.new('')
         + stat.panelOptions.withDescription('Known sources, destinations, endpoints and total overall traffic')
         + stat.queryOptions.withInterval('1m')
         + signals.collectingDevices.asPanelMixin()
         + signals.sources.asPanelMixin()
         + signals.destinations.asPanelMixin()
         + signals.totalTraffic.asPanelMixin()
         + stat.standardOptions.withMin(0)
         + { fieldConfig+: { defaults+: { fieldMinMax: true } } }
         + stat.standardOptions.color.withMode('palette-classic')
         + stat.options.withColorMode('background')
         + stat.panelOptions.withTransparent(true),


  topSources: signals.topSources.asTable()
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
  conversationTotalBytes: signals.conversationTraffic.asTable()
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

  conversationTraffic: signals.conversationTrafficOverTime.asTimeSeries()
                       + timeSeries.panelOptions.withTransparent(true)
                       + timeSeries.standardOptions.withUnit('bytes')
                       + timeSeries.options.legend.withShowLegend(false)
                       + timeSeries.fieldConfig.defaults.custom.withLineInterpolation('smooth')
                       + timeSeries.fieldConfig.defaults.custom.withFillOpacity(80)
                       + timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal', group: 'A' }),

  conversationByPair: pieChart.new('Breakdown by source/destination pair')
                      + pieChart.panelOptions.withTransparent(true)
                      + pieChart.options.legend.withPlacement('right')
                      + pieChart.options.legend.withValues(['value'])
                      + pieChart.standardOptions.withUnit('bytes')
                      + pieChart.options.withPieType('donut')
                      + pieChart.options.reduceOptions.withValues(true)
                      + pieChart.queryOptions.withInterval('1m')
                      + pieChart.queryOptions.withTargets([
                        signals.conversationPairs.asTableTarget(),
                      ]),
  protocolTotalBytes: signals.protocolTraffic.asTable()
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
                        + pieChart.queryOptions.withTargets([
                          signals.protocolTraffic.asTableTarget()
                          + g.query.prometheus.withLegendFormat('{{network_protocol_name}}'),
                        ]),
  protocolOverTime: signals.protocolOverTime.asTimeSeries()
                    + timeSeries.panelOptions.withTransparent(true)
                    + timeSeries.fieldConfig.defaults.custom.withDrawStyle('bars')
                    + timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal', group: 'A' })
                    + timeSeries.fieldConfig.defaults.custom.withFillOpacity(80)
                    + timeSeries.queryOptions.withMaxDataPoints(20),
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
                     + geomap.queryOptions.withTargets([
                       signals.trafficByDestination.asTableTarget(),
                     ]),
  destinationsLegend: signals.trafficByDestination.asTable()
                      + table.standardOptions.withUnit('bytes')
                      + table.standardOptions.color.withMode('continuous-BlPu')
                      + table.queryOptions.withInterval('1m')
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
                 + table.panelOptions.withTitle('Traffic by source')
                 + table.panelOptions.withDescription('Total traffic from specific countries during the selected time range')
                 + table.queryOptions.withTargets([signals.trafficBySource.asTableTarget()]),
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
