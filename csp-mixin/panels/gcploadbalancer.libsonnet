local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    // GCP Load Balancer
    glb_reqsec:
      this.signals.gcploadbalancer.requestsByStatus.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    glb_reqcountry:
      this.signals.gcploadbalancer.requestsByCountry.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    glb_reqcache:
      this.signals.gcploadbalancer.requestsByCache.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    glb_reqprotocol:
      this.signals.gcploadbalancer.requestsByProtocol.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    glb_errorrate:
      this.signals.gcploadbalancer.errorRate.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.options.legend.withShowLegend(false)
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Error Rate visualization',
          },
          properties: [
            {
              id: 'noValue',
              value: '0',
            },
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'red',
              },
            },
          ],
        },
      ]),

    glb_reslatency:
      this.signals.gcploadbalancer.totalResponseLatency50.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.totalResponseLatency90.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.totalResponseLatency99.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.totalResponseLatencyAverage.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'p50',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p90',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'orange',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p99',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'red',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Average',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'blue',
              },
            },
          ],
        },
      ]),

    glb_frontendlatency:
      this.signals.gcploadbalancer.frontendLatency50.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.frontendLatency90.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.frontendLatency99.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'p50',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p90',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'orange',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p99',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'red',
              },
            },
          ],
        },
      ]),

    glb_backendlatency:
      this.signals.gcploadbalancer.backendLatency50.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.backendLatency90.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.backendLatency99.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'p50',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p90',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'orange',
              },
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'p99',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'red',
              },
            },
          ],
        },
      ]),

    glb_req_bytes_count:
      this.signals.gcploadbalancer.totalReqSent.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcploadbalancer.totalReqReceived.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('out(-) | in(+)')
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Sent',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'blue',
              },
            },
            {
              id: 'custom.transform',
              value: 'negative-Y',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Received',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
      ]),

    glb_backend_req_bytes_count:
      this.signals.gcpoadbalancerBackend.backendTotalReqSent.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + this.signals.gcpoadbalancerBackend.backendTotalReqReceived.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('out(-) | in(+)')
      + g.panel.timeSeries.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Sent',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'blue',
              },
            },
            {
              id: 'custom.transform',
              value: 'negative-Y',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Received',
          },
          properties: [
            {
              id: 'color',
              value: {
                mode: 'fixed',
                fixedColor: 'green',
              },
            },
          ],
        },
      ]),
  },
}
