local g = (import '../g.libsonnet');
local grafana = (import 'grafonnet/grafana.libsonnet');
local dashboard = grafana.dashboard;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
local prometheus = grafana.prometheus;

local dashboardUidSuffix = '-search-and-index-overview';

local promDatasourceName = 'prometheus_datasource';
local instanceLabels = ['index'];

{

  // override
  local hideZeros =
    {
      matcher: {
        id: 'byValue',
        options: {
          reducer: 'allIsZero',
          op: 'gte',
          value: 0,
        },
      },
      properties: [
        {
          id: 'custom.hideFrom',
          value: {
            tooltip: true,
            viz: false,
            legend: true,
          },
        },
      ],
    },
  // variables
  local variables = (import '../variables.libsonnet').new(
    filteringSelector=$._config.filteringSelector,
    groupLabels=$._config.groupLabels,
    instanceLabels=instanceLabels,
    varMetric='opensearch_index_search_fetch_count'
  ),

  local promDatasource = {
    uid: '${%s}' % variables.datasources.prometheus.name,
  },

  local requestPerformanceRow = {
    datasource: promDatasource,
    targets: [],
    type: 'row',
    title: 'Request performance',
    collapsed: false,
  },

  local requestRatePanel = {
                             datasource: promDatasource,
                             targets: [
                               prometheus.target(
                                 'avg by (%(agg)s) (opensearch_index_search_query_current_number{%(queriesSelector)s, context=~"total"})'
                                 % {
                                   queriesSelector: variables.queriesSelector,
                                   agg: std.join(',', $._config.groupLabels + instanceLabels),
                                 },
                                 datasource=promDatasource,
                                 legendFormat='%s - query' % utils.labelsToPanelLegend(instanceLabels),
                               ),
                               prometheus.target(
                                 'avg by (%(agg)s) (opensearch_index_search_fetch_current_number{%(queriesSelector)s, context=~"total"})'
                                 % {
                                   queriesSelector: variables.queriesSelector,
                                   agg: std.join(',', $._config.groupLabels + instanceLabels),
                                 },
                                 datasource=promDatasource,
                                 legendFormat='%s - fetch' % utils.labelsToPanelLegend(instanceLabels),
                               ),
                               prometheus.target(
                                 'avg by (%(agg)s) (opensearch_index_search_scroll_current_number{%(queriesSelector)s, context=~"total"})'
                                 % {
                                   queriesSelector: variables.queriesSelector,
                                   agg: std.join(',', $._config.groupLabels + instanceLabels),
                                 },
                                 datasource=promDatasource,
                                 legendFormat='%s - scroll' % utils.labelsToPanelLegend(instanceLabels),
                               ),
                             ],
                             type: 'timeseries',
                             title: 'Request rate',
                             description: 'Rate of fetch, scroll, and query requests by selected index.',
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
                                   fillOpacity: 0,
                                   gradientMode: 'none',
                                   hideFrom: {
                                     legend: false,
                                     tooltip: false,
                                     viz: false,
                                   },
                                   lineInterpolation: 'linear',
                                   lineWidth: 1,
                                   pointSize: 5,
                                   scaleDistribution: {
                                     type: 'linear',
                                   },
                                   showPoints: 'auto',
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
                                     {
                                       color: 'red',
                                       value: 80,
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
                                 sort: 'none',
                               },
                             },
                           }
                           + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local requestLatencyPanel = {
                                datasource: promDatasource,
                                targets: [
                                  prometheus.target(
                                    'avg by (%(agg)s) (increase(opensearch_index_search_query_time_seconds{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(opensearch_index_search_query_count{%(queriesSelector)s, context="total"}[$__interval:]), 1))'
                                    % {
                                      queriesSelector: variables.queriesSelector,
                                      agg: std.join(',', $._config.groupLabels + instanceLabels),
                                    },
                                    datasource=promDatasource,
                                    legendFormat='%s - query' % utils.labelsToPanelLegend(instanceLabels),
                                    interval='1m',
                                  ),
                                  prometheus.target(
                                    'avg by (%(agg)s) (increase(opensearch_index_search_fetch_time_seconds{%(queriesSelector)s, context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_search_fetch_count{%(queriesSelector)s, context="total"}[$__interval:]), 1))'
                                    % {
                                      queriesSelector: variables.queriesSelector,
                                      agg: std.join(',', $._config.groupLabels + instanceLabels),
                                    },
                                    datasource=promDatasource,
                                    legendFormat='%s - fetch' % utils.labelsToPanelLegend(instanceLabels),
                                    interval='1m',
                                  ),
                                  prometheus.target(
                                    'avg by (%(agg)s) (increase(opensearch_index_search_scroll_time_seconds{%(queriesSelector)s, context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_search_scroll_count{%(queriesSelector)s, context="total"}[$__interval:]), 1))'
                                    % {
                                      queriesSelector: variables.queriesSelector,
                                      agg: std.join(',', $._config.groupLabels + instanceLabels),
                                    },
                                    datasource=promDatasource,
                                    legendFormat='%s - scroll' % utils.labelsToPanelLegend(instanceLabels),
                                    interval='1m',
                                  ),
                                ],
                                type: 'timeseries',
                                title: 'Request latency',
                                description: 'Latency of fetch, scroll, and query requests by selected index.',
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
                                      fillOpacity: 0,
                                      gradientMode: 'none',
                                      hideFrom: {
                                        legend: false,
                                        tooltip: false,
                                        viz: false,
                                      },
                                      lineInterpolation: 'linear',
                                      lineWidth: 1,
                                      pointSize: 5,
                                      scaleDistribution: {
                                        type: 'linear',
                                      },
                                      showPoints: 'auto',
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
                                        {
                                          color: 'red',
                                          value: 80,
                                        },
                                      ],
                                    },
                                    unit: 's',
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
                                    sort: 'none',
                                  },
                                },
                              }
                              + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local cacheHitRatioPanel = {
                               datasource: promDatasource,
                               targets: [
                                 prometheus.target(
                                   'avg by(%(agg)s) (100 * (opensearch_index_requestcache_hit_count{%(queriesSelector)s, context="total"}) / clamp_min(opensearch_index_requestcache_hit_count{%(queriesSelector)s, context="total"} + opensearch_index_requestcache_miss_count{%(queriesSelector)s, context="total"}, 1))'
                                   % {
                                     queriesSelector: variables.queriesSelector,
                                     agg: std.join(',', $._config.groupLabels + instanceLabels),
                                   },
                                   datasource=promDatasource,
                                   legendFormat='%s - request' % utils.labelsToPanelLegend(instanceLabels),
                                 ),
                                 prometheus.target(
                                   'avg by(%(agg)s) (100 * (opensearch_index_querycache_hit_count{%(queriesSelector)s, context="total"}) / clamp_min(opensearch_index_querycache_hit_count{%(queriesSelector)s, context="total"} + opensearch_index_querycache_miss_number{%(queriesSelector)s, context="total"}, 1))'
                                   % {
                                     queriesSelector: variables.queriesSelector,
                                     agg: std.join(',', $._config.groupLabels + instanceLabels),
                                   },
                                   datasource=promDatasource,
                                   legendFormat='%s - query' % utils.labelsToPanelLegend(instanceLabels),
                                 ),
                               ],
                               type: 'timeseries',
                               title: 'Cache hit ratio',
                               description: 'Ratio of query cache and request cache hits and misses.',
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
                                     fillOpacity: 0,
                                     gradientMode: 'none',
                                     hideFrom: {
                                       legend: false,
                                       tooltip: false,
                                       viz: false,
                                     },
                                     lineInterpolation: 'linear',
                                     lineWidth: 1,
                                     pointSize: 5,
                                     scaleDistribution: {
                                       type: 'linear',
                                     },
                                     showPoints: 'auto',
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
                                       {
                                         color: 'red',
                                         value: 80,
                                       },
                                     ],
                                   },
                                   unit: 'percent',
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
                                   sort: 'none',
                                 },
                               },
                             }
                             + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local evictionsPanel = {
                           datasource: promDatasource,
                           targets: [
                             prometheus.target(
                               'avg by(%(agg)s) (increase(opensearch_index_querycache_evictions_count{%(queriesSelector)s, context="total"}[$__interval:]))'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s - query cache' % utils.labelsToPanelLegend(instanceLabels),
                               interval='1m',
                             ),
                             prometheus.target(
                               'avg by(%(agg)s) (increase(opensearch_index_requestcache_evictions_count{%(queriesSelector)s, context="total"}[$__interval:]))'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s - request cache' % utils.labelsToPanelLegend(instanceLabels),
                               interval='1m',
                             ),
                             prometheus.target(
                               'avg by(%(agg)s) (increase(opensearch_index_fielddata_evictions_count{%(queriesSelector)s, context="total"}[$__interval:]))'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s - field data' % utils.labelsToPanelLegend(instanceLabels),
                               interval='1m',
                             ),
                           ],
                           type: 'timeseries',
                           title: 'Evictions',
                           description: 'Total evictions count by cache type for the selected index.',
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
                                 fillOpacity: 0,
                                 gradientMode: 'none',
                                 hideFrom: {
                                   legend: false,
                                   tooltip: false,
                                   viz: false,
                                 },
                                 lineInterpolation: 'linear',
                                 lineWidth: 1,
                                 pointSize: 5,
                                 scaleDistribution: {
                                   type: 'linear',
                                 },
                                 showPoints: 'auto',
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
                                   {
                                     color: 'red',
                                     value: 80,
                                   },
                                 ],
                               },
                               unit: 'evictions',
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
                               sort: 'none',
                             },
                           },
                         }
                         + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local indexPerformanceRow = {
    datasource: promDatasource,
    targets: [],
    type: 'row',
    title: 'Index performance',
    collapsed: false,
  },

  local indexRatePanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'avg by(%(agg)s) (opensearch_index_indexing_index_current_number{%(queriesSelector)s, context="total"})'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + instanceLabels),
        },
        datasource=promDatasource,
        legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'Index rate',
    description: 'Rate of indexed documents for the selected index.',
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
          fillOpacity: 0,
          gradientMode: 'none',
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
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
            {
              color: 'red',
              value: 80,
            },
          ],
        },
        unit: 'documents/s',
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
        mode: 'single',
        sort: 'none',
      },
    },
  } + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local indexLatencyPanel = {
                              datasource: promDatasource,
                              targets: [
                                prometheus.target(
                                  'avg by(%(agg)s) (increase(opensearch_index_indexing_index_time_seconds{%(queriesSelector)s, context=~"total"}[$__interval:]) / clamp_min(increase(opensearch_index_indexing_index_count{%(queriesSelector)s, context=~"total"}[$__interval:]),1))'
                                  % {
                                    queriesSelector: variables.queriesSelector,
                                    agg: std.join(',', $._config.groupLabels + instanceLabels),
                                  },
                                  datasource=promDatasource,
                                  legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                                  interval='1m',
                                ),
                              ],
                              type: 'timeseries',
                              title: 'Index latency',
                              description: 'Document indexing latency for the selected index.',
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
                                    fillOpacity: 0,
                                    gradientMode: 'none',
                                    hideFrom: {
                                      legend: false,
                                      tooltip: false,
                                      viz: false,
                                    },
                                    lineInterpolation: 'linear',
                                    lineWidth: 1,
                                    pointSize: 5,
                                    scaleDistribution: {
                                      type: 'linear',
                                    },
                                    showPoints: 'auto',
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
                                      {
                                        color: 'red',
                                        value: 80,
                                      },
                                    ],
                                  },
                                  unit: 's',
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
                                  mode: 'single',
                                  sort: 'none',
                                },
                              },
                            }
                            + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local indexFailuresPanel = {
                               datasource: promDatasource,
                               targets: [
                                 prometheus.target(
                                   'avg by(%(agg)s) (increase(opensearch_index_indexing_index_failed_count{%(queriesSelector)s, context="total"}[$__interval:]))'
                                   % {
                                     queriesSelector: variables.queriesSelector,
                                     agg: std.join(',', $._config.groupLabels + instanceLabels),
                                   },
                                   datasource=promDatasource,
                                   legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                                   interval='1m',
                                 ),
                               ],
                               type: 'timeseries',
                               title: 'Index failures',
                               description: 'Number of indexing failures for the selected index.',
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
                                     fillOpacity: 0,
                                     gradientMode: 'none',
                                     hideFrom: {
                                       legend: false,
                                       tooltip: false,
                                       viz: false,
                                     },
                                     lineInterpolation: 'linear',
                                     lineWidth: 1,
                                     pointSize: 5,
                                     scaleDistribution: {
                                       type: 'linear',
                                     },
                                     showPoints: 'auto',
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
                                       {
                                         color: 'red',
                                         value: 80,
                                       },
                                     ],
                                   },
                                   unit: 'failures',
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
                                   mode: 'single',
                                   sort: 'none',
                                 },
                               },
                             }
                             + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local flushLatencyPanel = {
    datasource: promDatasource,
    targets: [
      prometheus.target(
        'avg by(%(agg)s) (increase(opensearch_index_flush_total_time_seconds{%(queriesSelector)s, context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_flush_total_count{%(queriesSelector)s, context="total"}[$__interval:]),1))'
        % {
          queriesSelector: variables.queriesSelector,
          agg: std.join(',', $._config.groupLabels + instanceLabels),
        },
        datasource=promDatasource,
        legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
      ),
    ],
    type: 'timeseries',
    title: 'Flush latency',
    description: 'Index flush latency for the selected index.',
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
          fillOpacity: 0,
          gradientMode: 'none',
          hideFrom: {
            legend: false,
            tooltip: false,
            viz: false,
          },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: {
            type: 'linear',
          },
          showPoints: 'auto',
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
            {
              color: 'red',
              value: 80,
            },
          ],
        },
        unit: 's',
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
        mode: 'single',
        sort: 'none',
      },
    },
  } + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local mergeTimePanel = {
                           datasource: promDatasource,
                           targets: [
                             prometheus.target(
                               'avg by(%(agg)s) (increase(opensearch_index_merges_total_time_seconds{%(queriesSelector)s, context="total"}[$__interval:])) > 0'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s - total' % utils.labelsToPanelLegend(instanceLabels),
                             ),
                             prometheus.target(
                               'avg by(%(agg)s) (increase(opensearch_index_merges_total_stopped_time_seconds{%(queriesSelector)s, context="total"}[$__interval:])) > 0'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s - stopped' % utils.labelsToPanelLegend(instanceLabels),
                             ),
                             prometheus.target(
                               'avg by(%(agg)s) (increase(opensearch_index_merges_total_throttled_time_seconds{%(queriesSelector)s, context="total"}[$__interval:])) > 0'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s - throttled' % utils.labelsToPanelLegend(instanceLabels),
                             ),
                           ],
                           type: 'timeseries',
                           title: 'Merge time',
                           description: 'Index merge time for the selected index.',
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
                                 fillOpacity: 0,
                                 gradientMode: 'none',
                                 hideFrom: {
                                   legend: false,
                                   tooltip: false,
                                   viz: false,
                                 },
                                 lineInterpolation: 'linear',
                                 lineWidth: 1,
                                 pointSize: 5,
                                 scaleDistribution: {
                                   type: 'linear',
                                 },
                                 showPoints: 'auto',
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
                                   {
                                     color: 'red',
                                     value: 80,
                                   },
                                 ],
                               },
                               unit: 's',
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
                               sort: 'none',
                             },
                           },
                         }
                         + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
                         + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local refreshLatencyPanel = {
                                datasource: promDatasource,
                                targets: [
                                  prometheus.target(
                                    'avg by(%(agg)s) (increase(opensearch_index_refresh_total_time_seconds{%(queriesSelector)s, context="total"}[$__interval:]) / clamp_min(increase(opensearch_index_refresh_total_count{%(queriesSelector)s, context="total"}[$__interval:]),1))'
                                    % {
                                      queriesSelector: variables.queriesSelector,
                                      agg: std.join(',', $._config.groupLabels + instanceLabels),
                                    },
                                    datasource=promDatasource,
                                    legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                                  ),
                                ],
                                type: 'timeseries',
                                title: 'Refresh latency',
                                description: 'Index refresh latency for the selected index.',
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
                                      fillOpacity: 0,
                                      gradientMode: 'none',
                                      hideFrom: {
                                        legend: false,
                                        tooltip: false,
                                        viz: false,
                                      },
                                      lineInterpolation: 'linear',
                                      lineWidth: 1,
                                      pointSize: 5,
                                      scaleDistribution: {
                                        type: 'linear',
                                      },
                                      showPoints: 'auto',
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
                                        {
                                          color: 'red',
                                          value: 80,
                                        },
                                      ],
                                    },
                                    unit: 's',
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
                                    mode: 'single',
                                    sort: 'none',
                                  },
                                },
                              }
                              + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local translogOperationsPanel = {
                                    datasource: promDatasource,
                                    targets: [
                                      prometheus.target(
                                        'avg by(%(agg)s) (opensearch_index_translog_operations_number{%(queriesSelector)s, context="total"})'
                                        % {
                                          queriesSelector: variables.queriesSelector,
                                          agg: std.join(',', $._config.groupLabels + instanceLabels),
                                        },
                                        datasource=promDatasource,
                                        legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                                      ),
                                    ],
                                    type: 'timeseries',
                                    title: 'Translog operations',
                                    description: 'Current number of translog operations for the selected index.',
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
                                          fillOpacity: 0,
                                          gradientMode: 'none',
                                          hideFrom: {
                                            legend: false,
                                            tooltip: false,
                                            viz: false,
                                          },
                                          lineInterpolation: 'linear',
                                          lineWidth: 1,
                                          pointSize: 5,
                                          scaleDistribution: {
                                            type: 'linear',
                                          },
                                          showPoints: 'auto',
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
                                            {
                                              color: 'red',
                                              value: 80,
                                            },
                                          ],
                                        },
                                        unit: 'operations',
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
                                        mode: 'single',
                                        sort: 'none',
                                      },
                                    },
                                  }
                                  + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local docsDeletedPanel = {
                             datasource: promDatasource,
                             targets: [
                               prometheus.target(
                                 'avg by (%(agg)s) (opensearch_index_indexing_delete_current_number{%(queriesSelector)s, context="total"})'
                                 % {
                                   queriesSelector: variables.queriesSelector,
                                   agg: std.join(',', $._config.groupLabels + instanceLabels),
                                 },
                                 datasource=promDatasource,
                                 legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                               ),
                             ],
                             type: 'timeseries',
                             title: 'Docs deleted',
                             description: 'Rate of documents deleted for the selected index.',
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
                                   fillOpacity: 0,
                                   gradientMode: 'none',
                                   hideFrom: {
                                     legend: false,
                                     tooltip: false,
                                     viz: false,
                                   },
                                   lineInterpolation: 'linear',
                                   lineWidth: 1,
                                   pointSize: 5,
                                   scaleDistribution: {
                                     type: 'linear',
                                   },
                                   showPoints: 'auto',
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
                                     {
                                       color: 'red',
                                       value: 80,
                                     },
                                   ],
                                 },
                                 unit: 'documents/s',
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
                                 mode: 'single',
                                 sort: 'none',
                               },
                             },
                           }
                           + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local indexCapacityRow = {
    datasource: promDatasource,
    targets: [],
    type: 'row',
    title: 'Index capacity',
    collapsed: false,
  },

  local documentsIndexedPanel = {
                                  datasource: promDatasource,
                                  targets: [
                                    prometheus.target(
                                      'avg by (%(agg)s) (opensearch_index_indexing_index_count{%(queriesSelector)s, context="total"})'
                                      % {
                                        queriesSelector: variables.queriesSelector,
                                        agg: std.join(',', $._config.groupLabels + instanceLabels),
                                      },
                                      datasource=promDatasource,
                                      legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                                    ),
                                  ],
                                  type: 'timeseries',
                                  title: 'Documents indexed',
                                  description: 'Number of indexed documents for the selected index.',
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
                                        fillOpacity: 0,
                                        gradientMode: 'none',
                                        hideFrom: {
                                          legend: false,
                                          tooltip: false,
                                          viz: false,
                                        },
                                        lineInterpolation: 'linear',
                                        lineWidth: 1,
                                        pointSize: 5,
                                        scaleDistribution: {
                                          type: 'linear',
                                        },
                                        showPoints: 'auto',
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
                                          {
                                            color: 'red',
                                            value: 80,
                                          },
                                        ],
                                      },
                                      unit: 'documents',
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
                                      mode: 'single',
                                      sort: 'none',
                                    },
                                  },
                                }
                                + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local segmentCountPanel = {
                              datasource: promDatasource,
                              targets: [
                                prometheus.target(
                                  'avg by(%(agg)s) (opensearch_index_segments_number{%(queriesSelector)s, context="total"})'
                                  % {
                                    queriesSelector: variables.queriesSelector,
                                    agg: std.join(',', $._config.groupLabels + instanceLabels),
                                  },
                                  datasource=promDatasource,
                                  legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                                ),
                              ],
                              type: 'timeseries',
                              title: 'Segment count',
                              description: 'Current number of segments for the selected index.',
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
                                    fillOpacity: 0,
                                    gradientMode: 'none',
                                    hideFrom: {
                                      legend: false,
                                      tooltip: false,
                                      viz: false,
                                    },
                                    lineInterpolation: 'linear',
                                    lineWidth: 1,
                                    pointSize: 5,
                                    scaleDistribution: {
                                      type: 'linear',
                                    },
                                    showPoints: 'auto',
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
                                      {
                                        color: 'red',
                                        value: 80,
                                      },
                                    ],
                                  },
                                  unit: 'segments',
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
                                  mode: 'single',
                                  sort: 'none',
                                },
                              },
                            }
                            + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local mergeCountPanel = {
                            datasource: promDatasource,
                            targets: [
                              prometheus.target(
                                'avg by(%(agg)s) (increase(opensearch_index_merges_total_docs_count{%(queriesSelector)s, context="total"}[$__interval:])) > 0'
                                % {
                                  queriesSelector: variables.queriesSelector,
                                  agg: std.join(',', $._config.groupLabels + instanceLabels),
                                },
                                datasource=promDatasource,
                                legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                              ),
                            ],
                            type: 'timeseries',
                            title: 'Merge count',
                            description: 'Number of merge operations for the selected index.',
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
                                  fillOpacity: 0,
                                  gradientMode: 'none',
                                  hideFrom: {
                                    legend: false,
                                    tooltip: false,
                                    viz: false,
                                  },
                                  lineInterpolation: 'linear',
                                  lineWidth: 1,
                                  pointSize: 5,
                                  scaleDistribution: {
                                    type: 'linear',
                                  },
                                  showPoints: 'auto',
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
                                    {
                                      color: 'red',
                                      value: 80,
                                    },
                                  ],
                                },
                                unit: 'merges',
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
                                mode: 'single',
                                sort: 'none',
                              },
                            },
                          }
                          + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
                          + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local cacheSizePanel = {
                           datasource: promDatasource,
                           targets: [
                             prometheus.target(
                               'avg by(%(agg)s) (opensearch_index_querycache_memory_size_bytes{%(queriesSelector)s, context="total"})'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s - query' % utils.labelsToPanelLegend(instanceLabels),
                             ),
                             prometheus.target(
                               'avg by(%(agg)s) (opensearch_index_requestcache_memory_size_bytes{%(queriesSelector)s, context="total"})'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s - request' % utils.labelsToPanelLegend(instanceLabels),
                             ),
                           ],
                           type: 'timeseries',
                           title: 'Cache size',
                           description: 'Size of query cache and request cache.',
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
                                 fillOpacity: 0,
                                 gradientMode: 'none',
                                 hideFrom: {
                                   legend: false,
                                   tooltip: false,
                                   viz: false,
                                 },
                                 lineInterpolation: 'linear',
                                 lineWidth: 1,
                                 pointSize: 5,
                                 scaleDistribution: {
                                   type: 'linear',
                                 },
                                 showPoints: 'auto',
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
                                   {
                                     color: 'red',
                                     value: 80,
                                   },
                                 ],
                               },
                               unit: 'bytes',
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
                               sort: 'none',
                             },
                           },
                         }
                         + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local storeSizePanel = {
                           datasource: promDatasource,
                           targets: [
                             prometheus.target(
                               'avg by(%(agg)s) (opensearch_index_store_size_bytes{%(queriesSelector)s, context="total"})'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                             ),
                           ],
                           type: 'timeseries',
                           title: 'Store size',
                           description: 'Size of the store in bytes for the selected index.',
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
                                 fillOpacity: 0,
                                 gradientMode: 'none',
                                 hideFrom: {
                                   legend: false,
                                   tooltip: false,
                                   viz: false,
                                 },
                                 lineInterpolation: 'linear',
                                 lineWidth: 1,
                                 pointSize: 5,
                                 scaleDistribution: {
                                   type: 'linear',
                                 },
                                 showPoints: 'auto',
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
                                   {
                                     color: 'red',
                                     value: 80,
                                   },
                                 ],
                               },
                               unit: 'bytes',
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
                               mode: 'single',
                               sort: 'none',
                             },
                           },
                         }
                         + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local segmentSizePanel = {
                             datasource: promDatasource,
                             targets: [
                               prometheus.target(
                                 'avg by(%(agg)s) (opensearch_index_segments_memory_bytes{%(queriesSelector)s, context="total"})'
                                 % {
                                   queriesSelector: variables.queriesSelector,
                                   agg: std.join(',', $._config.groupLabels + instanceLabels),
                                 },
                                 datasource=promDatasource,
                                 legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                               ),
                             ],
                             type: 'timeseries',
                             title: 'Segment size',
                             description: 'Memory used by segments for the selected index.',
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
                                   fillOpacity: 0,
                                   gradientMode: 'none',
                                   hideFrom: {
                                     legend: false,
                                     tooltip: false,
                                     viz: false,
                                   },
                                   lineInterpolation: 'linear',
                                   lineWidth: 1,
                                   pointSize: 5,
                                   scaleDistribution: {
                                     type: 'linear',
                                   },
                                   showPoints: 'auto',
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
                                     {
                                       color: 'red',
                                       value: 80,
                                     },
                                   ],
                                 },
                                 unit: 'bytes',
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
                                 mode: 'single',
                                 sort: 'none',
                               },
                             },
                           }
                           + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),

  local mergeSizePanel = {
                           datasource: promDatasource,
                           targets: [
                             prometheus.target(
                               'avg by(%(agg)s) (opensearch_index_merges_current_size_bytes{%(queriesSelector)s, context="total"}) > 0'
                               % {
                                 queriesSelector: variables.queriesSelector,
                                 agg: std.join(',', $._config.groupLabels + instanceLabels),
                               },
                               datasource=promDatasource,
                               legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
                             ),
                           ],
                           type: 'timeseries',
                           title: 'Merge size',
                           description: 'Size of merge operations in bytes for the selected index.',
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
                                 fillOpacity: 0,
                                 gradientMode: 'none',
                                 hideFrom: {
                                   legend: false,
                                   tooltip: false,
                                   viz: false,
                                 },
                                 lineInterpolation: 'linear',
                                 lineWidth: 1,
                                 pointSize: 5,
                                 scaleDistribution: {
                                   type: 'linear',
                                 },
                                 showPoints: 'auto',
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
                                   {
                                     color: 'red',
                                     value: 80,
                                   },
                                 ],
                               },
                               unit: 'bytes',
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
                               mode: 'single',
                               sort: 'none',
                             },
                           },
                         }
                         + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('points')
                         + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),
  local shardCountPanel =
    {
      datasource: promDatasource,
      targets: [
        prometheus.target(
          'sum by (index) (avg by(%(agg)s) (opensearch_index_shards_number{%(queriesSelector)s, type=~"active|active_primary"}))'
          % {
            queriesSelector: variables.queriesSelector,
            agg: std.join(',', $._config.groupLabels + instanceLabels),
          },
          datasource=promDatasource,
          legendFormat='%s' % utils.labelsToPanelLegend(instanceLabels),
        ),
      ],
      type: 'timeseries',
      title: 'Shard count',
      description: 'The number of index shards for the selected index.',
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
            fillOpacity: 0,
            gradientMode: 'none',
            hideFrom: {
              legend: false,
              tooltip: false,
              viz: false,
            },
            lineInterpolation: 'linear',
            lineWidth: 1,
            pointSize: 5,
            scaleDistribution: {
              type: 'linear',
            },
            showPoints: 'auto',
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
              {
                color: 'red',
                value: 80,
              },
            ],
          },
          unit: 'shards',
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
          mode: 'single',
          sort: 'none',
        },
      },
    }
    + g.panel.timeSeries.standardOptions.withOverridesMixin(hideZeros),


  grafanaDashboards+:: {
    'search-and-index-overview.json':
      g.dashboard.new('OpenSearch search and index overview',)
      + g.dashboard.withTags($._config.dashboardTags)
      + g.dashboard.time.withFrom($._config.dashboardPeriod)
      + g.dashboard.withTimezone($._config.dashboardTimezone)
      + g.dashboard.withRefresh($._config.dashboardRefresh)
      + g.dashboard.withUid($._config.uid + dashboardUidSuffix)
      + g.dashboard.withLinks(
        g.dashboard.link.dashboards.new(
          'Other Opensearch dashboards',
          $._config.dashboardTags
        )
        + g.dashboard.link.dashboards.options.withIncludeVars(true)
        + g.dashboard.link.dashboards.options.withKeepTime(true)
        + g.dashboard.link.dashboards.options.withAsDropdown(false)
      )
      + g.dashboard.withPanels(
        [
          requestPerformanceRow { gridPos: { h: 1, w: 24, x: 0, y: 0 } },
          requestRatePanel { gridPos: { h: 8, w: 6, x: 0, y: 1 } },
          requestLatencyPanel { gridPos: { h: 8, w: 6, x: 6, y: 1 } },
          cacheHitRatioPanel { gridPos: { h: 8, w: 6, x: 12, y: 1 } },
          evictionsPanel { gridPos: { h: 8, w: 6, x: 18, y: 1 } },
          indexPerformanceRow { gridPos: { h: 1, w: 24, x: 0, y: 9 } },
          indexRatePanel { gridPos: { h: 8, w: 6, x: 0, y: 10 } },
          indexLatencyPanel { gridPos: { h: 8, w: 6, x: 6, y: 10 } },
          indexFailuresPanel { gridPos: { h: 8, w: 6, x: 12, y: 10 } },
          flushLatencyPanel { gridPos: { h: 8, w: 6, x: 18, y: 10 } },
          mergeTimePanel { gridPos: { h: 8, w: 6, x: 0, y: 18 } },
          refreshLatencyPanel { gridPos: { h: 8, w: 6, x: 6, y: 18 } },
          translogOperationsPanel { gridPos: { h: 8, w: 6, x: 12, y: 18 } },
          docsDeletedPanel { gridPos: { h: 8, w: 6, x: 18, y: 18 } },
          indexCapacityRow { gridPos: { h: 1, w: 24, x: 0, y: 26 } },
          documentsIndexedPanel { gridPos: { h: 8, w: 6, x: 0, y: 27 } },
          segmentCountPanel { gridPos: { h: 8, w: 6, x: 6, y: 27 } },
          mergeCountPanel { gridPos: { h: 8, w: 6, x: 12, y: 27 } },
          cacheSizePanel { gridPos: { h: 8, w: 6, x: 18, y: 27 } },
          storeSizePanel { gridPos: { h: 8, w: 6, x: 0, y: 35 } },
          segmentSizePanel { gridPos: { h: 8, w: 6, x: 6, y: 35 } },
          mergeSizePanel { gridPos: { h: 8, w: 6, x: 12, y: 35 } },
          shardCountPanel { gridPos: { h: 8, w: 6, x: 18, y: 35 } },
        ]
      )
      + g.dashboard.withVariables(variables.multiInstance),
  },
}
