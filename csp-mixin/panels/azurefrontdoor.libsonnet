local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    // Azure Front Door

    afd_endpoint_count:
      this.signals.azurefrontdoorOverview.endpointCount.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

    afd_top5_errors:
      this.signals.azurefrontdoorOverview.top5Errors.asTable(format='table')
      + commonlib.panels.generic.table.base.stylize()
      + g.panel.table.standardOptions.withOverrides(
        [
          {
            matcher: {
              id: 'byName',
              options: 'Value',
            },
            properties: [
              {
                id: 'custom.width',
                value: 80,
              },
              {
                id: 'color',
              },
              {
                id: 'custom.cellOptions',
                value: {
                  type: 'gauge',
                  valueDisplayMode: 'color',
                },
              },
              {
                id: 'unit',
                value: 'percent',
              },
              {
                id: 'thresholds',
                value: {
                  mode: 'percentage',
                  steps: [
                    {
                      color: 'text',
                      value: 0,
                    },
                    {
                      color: 'red',
                      value: 1,
                    },
                  ],
                },
              },
              {
                id: 'min',
                value: 0,
              },
              {
                id: 'max',
                value: 100,
              },
            ],
          },
        ]
      )
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              subscriptionName: true,
            },
            includeByName: {},
            indexByName: {
              Time: 0,
              Value: 7,
              dimensionClientCountry: 6,
              dimension_ClientCountry: 6,
              dimensionClientRegion: 5,
              dimension_ClientRegion: 5,
              job: 1,
              resourceGroup: 2,
              resourceName: 3,
              subscriptionName: 4,
            },
            renameByName: {
              dimensionClientCountry: 'Country',
              dimension_ClientCountry: 'Country',
              dimensionClientRegion: 'Region',
              dimension_ClientRegion: 'Region',
              job: 'Job',
              resourceGroup: 'Group',
              resourceName: 'Resource',
            },
          },
        },
      ]),

    afd_total_requests:
      this.signals.azurefrontdoorOverview.totalRequests.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.options.legend.withShowLegend(false),

    afd_requests_by_country:
      this.signals.azurefrontdoorOverview.requestsByCountry.asTimeSeries()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + commonlib.panels.generic.timeSeries.base.stylize(),

    afd_requests_by_status:
      this.signals.azurefrontdoorOverview.requestsByStatus.asTimeSeries()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + commonlib.panels.generic.timeSeries.base.stylize(),

    afd_requests_by_errors:
      commonlib.panels.generic.timeSeries.base.new('Request by Errors percentage', targets=[])
      + this.signals.azurefrontdoorOverview.error4xx.asPanelMixin()
      + this.signals.azurefrontdoorOverview.error5xx.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.table.standardOptions.withOverrides(
        [
          {
            matcher: {
              id: 'byName',
              options: '4xx',
            },
            properties: [
              {
                id: 'color',
                value: {
                  fixedColor: 'orange',
                  mode: 'fixed',
                },
              },
              {
                id: 'unit',
                value: 'percent',
              },
            ],
          },
          {
            matcher: {
              id: 'byName',
              options: '5xx',
            },
            properties: [
              {
                id: 'color',
                value: {
                  fixedColor: 'red',
                  mode: 'fixed',
                },
              },
              {
                id: 'unit',
                value: 'percent',
              },
            ],
          },
        ]
      ),

    afd_requests_responses_size:
      commonlib.panels.generic.timeSeries.base.new('Request/Responses size', targets=[])
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withDescription('The number of bytes sent as requests/responses from clients to AFDX and from HTTP/S proxy to clients.')
      + this.signals.azurefrontdoorOverview.requestsSize.asPanelMixin()
      + this.signals.azurefrontdoorOverview.responsesSize.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('requests(-) | responses(+)')
      + g.panel.table.standardOptions.withOverrides(
        [
          {
            matcher: {
              id: 'byName',
              options: 'Requests',
            },
            properties: [
              {
                id: 'custom.transform',
                value: 'negative-Y',
              },
              {
                id: 'unit',
                value: 'decbytes',
              },
            ],
          },
        ]
      ),

    afd_total_latency:
      this.signals.azurefrontdoorOverview.totalLatency.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.options.legend.withShowLegend(false),

    afd_origin_health:
      this.signals.azurefrontdoorOverview.originHealthPercentage.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.options.legend.withShowLegend(false)
      + g.panel.table.standardOptions.withOverrides(
        [
          {
            matcher: {
              id: 'byName',
              options: 'Value',
            },
            properties: [
              {
                id: 'unit',
                value: 'percent',
              },
              {
                id: 'thresholds',
                value: {
                  mode: 'percentage',
                  steps: [
                    {
                      color: 'text',
                      value: 0,
                    },
                    {
                      value: 1,
                      color: 'red',
                    },
                    {
                      value: 85,
                      color: 'yellow',
                    },
                    {
                      color: 'green',
                      value: 90,
                    },
                  ],
                },
              },
              {
                id: 'color',
                value: {
                  mode: 'thresholds',
                },
              },
            ],
          },
        ]
      ),

    afd_origin_latency:
      this.signals.azurefrontdoorOverview.originLatency.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.options.legend.withShowLegend(false),

    afd_requests_by_endpoint:
      this.signals.azurefrontdoor.requestsByEndpoint.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    afd_requests_size_by_endpoint:
      this.signals.azurefrontdoor.requestsSizeByEndpoints.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    afd_responses_size_by_endpoint:
      this.signals.azurefrontdoor.responsesSizeByEndpoints.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    afd_total_latency_by_endpoint:
      this.signals.azurefrontdoor.totalLatencyByEndpoints.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    afd_errors_by_endpoint:
      this.signals.azurefrontdoor.errorsByEndpoints.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.table.standardOptions.withOverrides(
        [
          {
            matcher: {
              id: 'byName',
              options: 'Value',
            },
            properties: [
              {
                id: 'color',
                value: {
                  mode: 'fixed',
                  fixedColor: 'red',
                },
              },
              {
                id: 'unit',
                value: 'percent',
              },
            ],
          },
        ]
      ),

    afd_origin_requests_by_endpoint:
      this.signals.azurefrontdoor.originRequestsByEndpoints.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    afd_origin_latency_by_endpoint:
      this.signals.azurefrontdoor.originLatencyByEndpoints.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
  },
}
