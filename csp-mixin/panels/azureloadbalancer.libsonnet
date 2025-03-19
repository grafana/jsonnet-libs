local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    // Azure Load Balancer

    alb_sync_packets:
      this.signals.azureloadbalancer.summarySyncPackets.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withColorMode('background_solid')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.withNoValue('0')
      + g.panel.stat.standardOptions.withOverrides([]),

    alb_total_packets:
      this.signals.azureloadbalancer.summaryTotalPackets.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withColorMode('background_solid')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.withNoValue('0')
      + g.panel.stat.standardOptions.withOverrides([]),

    alb_total_bytes:
      this.signals.azureloadbalancer.summaryTotalBytes.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withColorMode('background_solid')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withUnit('decbytes')
      + g.panel.stat.standardOptions.withNoValue('0')
      + g.panel.stat.standardOptions.withOverrides([]),

    alb_snat_connections:
      this.signals.azureloadbalancer.summarySnatConn.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.options.withColorMode('background_solid')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.withNoValue('0')
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.withOverrides([]),

    alb_details_sync_packets:
      this.signals.azureloadbalancer.detailsSyncPackets.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_details_total_packets:
      this.signals.azureloadbalancer.detailsTotalPackets.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_details_total_bytes:
      this.signals.azureloadbalancer.detailsTotalBytes.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('decbytes')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_details_snat_connections:
      this.signals.azureloadbalancer.detailsSnatConn.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(10)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('none')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_snatports:
      this.signals.azureloadbalancer.snatPorts.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.azureloadbalancer.allocatedSnatPorts.asPanelMixin()
      + g.panel.timeSeries.options.tooltip.withMode('multi')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([]),

    alb_used_snatports:
      this.signals.azureloadbalancer.usedSnatPorts.asGauge()
      + this.signals.azureloadbalancer.allocatedSnatPorts.asPanelMixin()
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + g.panel.timeSeries.standardOptions.withNoValue('0')
      + g.panel.timeSeries.standardOptions.withOverrides([])
      + g.panel.gauge.queryOptions.withTransformations([
        {
          id: 'configFromData',
          options: {
            configRefId: 'Allocated SNAT Ports',
            mappings: [
              {
                fieldName: 'Allocated',
                handlerKey: 'max',
              },
            ],
          },
        },
      ]),
  },
}
