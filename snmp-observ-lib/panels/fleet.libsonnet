local g = import '../g.libsonnet';
local legend = import './legend.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

{
  new(signals, this):: {
    // common-lib's withDataLink links with ${datasource}. With logs on, the Prometheus variable is prometheus_datasource.
    local drillDownLink =
      g.panel.timeSeries.standardOptions.withLinks({
        title: 'Drill down to this instance',
        url: '/d/%s?%s&${__url_time_range}&${%s:queryparam}' % [
          this.grafana.dashboards['snmp-overview.json'].uid,
          std.join('&', ['var-%s=${__field.labels.%s}' % [l, l] for l in this.config.instanceLabels]),
          signals.system.datasource,
        ],
      }),
    deviceTable:
      local fieldOverride = g.panel.table.fieldOverride;
      signals.fleetInterface.interfacesCount.asTable(name='Network devices', format='table', filterable=true)
      + signals.system.sysName.asTableColumn(format='table')
      + signals.system.version.asTableColumn(format='table')
      + signals.system.uptime.asTableColumn(format='table')
      + commonlib.panels.system.table.uptime.stylizeByName('Uptime')
      + signals.cpu.cpuUsage.asTableColumn(format='table')
      + commonlib.panels.generic.table.percentage.stylizeByName('CPU utilization')
      + signals.memory.memoryUsage.asTableColumn(format='table')
      + commonlib.panels.generic.table.percentage.stylizeByName('Memory utilization')
      + signals.fleetInterface.networkOutBitPerSec.asTableColumn(format='table')
      + commonlib.panels.generic.table.coldHotGauge.stylizeByName('Transmitted')
      + signals.fleetInterface.networkInBitPerSec.asTableColumn(format='table')
      + commonlib.panels.generic.table.coldHotGauge.stylizeByName('Received')
      + signals.fleetInterface.networkAllErrorsPerSec.asTableColumn(format='table')
      + signals.alerts.alertsWarning
        .withExprWrappersMixin(['count by (%s)(' % std.join(',', this.config.instanceLabels + this.config.groupLabels), ')'])
        .asTableColumn(format='table')
      + signals.alerts.alertsCritical
        .withExprWrappersMixin(['count by (%s)(' % std.join(',', this.config.instanceLabels + this.config.groupLabels), ')'])
        .asTableColumn(format='table')
      // asTableColumn() appends each column's description to the table's. These columns' descriptions only repeated their titles.
      + g.panel.table.panelOptions.withDescription('')
      + {
        options+: {
          sortBy: [
            {
              displayName: 'Transmitted',
              desc: true,
            },
          ],
        },
      }
      //extra links overrides to another dashboard
      + g.panel.table.standardOptions.withOverridesMixin(
        [
          fieldOverride.byRegexp.new(std.join('|', std.map(commonlib.utils.toSentenceCase, this.config.instanceLabels)))
          + fieldOverride.byRegexp.withProperty('custom.filterable', true)
          + fieldOverride.byRegexp.withProperty('links', [
            {
              targetBlank: false,
              title: 'Drill down to ${__field.name} ${__value.text}',
              url: 'd/%s?var-%s=${__data.fields.%s}&${__url_time_range}&${%s:queryparam}' % [
                this.grafana.dashboards['snmp-overview.json'].uid,
                xtd.array.slice(this.config.instanceLabels, -1)[0],
                xtd.array.slice(this.config.instanceLabels, -1)[0],
                signals.system.datasource,
              ],
            },
          ]),

          fieldOverride.byRegexp.new(std.join('|', std.map(commonlib.utils.toSentenceCase, this.config.groupLabels)))
          + fieldOverride.byRegexp.withProperty('custom.filterable', true)
          + fieldOverride.byRegexp.withProperty('links', [
            {
              targetBlank: false,
              title: 'Filter by ${__field.name}',
              url: 'd/%s?var-${__field.name}=${__value.text}&${__url_time_range}&${%s:queryparam}' % [this.grafana.dashboards['snmp-fleet.json'].uid, signals.system.datasource],
            },
          ]),
        ]
      ),

    traffic:
      signals.fleetInterface.networkOutBitPerSec.withTopK().asTimeSeries('Traffic')
      + signals.fleetInterface.networkInBitPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.traffic.stylize()
      + drillDownLink
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + legend.table
      + g.panel.timeSeries.queryOptions.withInterval(this.config.minInterval),

    errors:
      signals.fleetInterface.networkInErrorsPerSec.withTopK().asTimeSeries('Network errors')
      + signals.fleetInterface.networkOutErrorsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.errors.stylize()
      + drillDownLink
      + commonlib.panels.network.timeSeries.errors.withNegateOutPackets()
      + legend.table
      + g.panel.timeSeries.queryOptions.withInterval(this.config.minInterval),

    dropped:
      signals.fleetInterface.networkInDroppedPerSec.withTopK().asTimeSeries('Packets dropped')
      + signals.fleetInterface.networkOutDroppedPerSec.withTopK().asPanelMixin()
      + signals.fleetInterface.ifInUnknownProtos.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.dropped.stylize()
      + drillDownLink
      + commonlib.panels.network.timeSeries.dropped.withNegateOutPackets()
      + legend.table
      + g.panel.timeSeries.queryOptions.withInterval(this.config.minInterval),

    packetsUnicast:
      signals.fleetInterface.networkInUnicastPacketsPerSec.withTopK().asTimeSeries('Unicast')
      + signals.fleetInterface.networkOutUnicastPacketsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.unicast.stylize()
      + drillDownLink
      + commonlib.panels.network.timeSeries.unicast.withNegateOutPackets()
      + legend.table
      + g.panel.timeSeries.queryOptions.withInterval(this.config.minInterval),

    packetsBroadcast:
      signals.fleetInterface.networkInBroadcastPacketsPerSec.withTopK().asTimeSeries('Broadcast')
      + signals.fleetInterface.networkOutBroadcastPacketsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.broadcast.stylize()
      + drillDownLink
      + commonlib.panels.network.timeSeries.broadcast.withNegateOutPackets()
      + legend.table
      + g.panel.timeSeries.queryOptions.withInterval(this.config.minInterval),

    packetsMulticast:
      signals.fleetInterface.networkInMulticastPacketsPerSec.withTopK().asTimeSeries('Multicast')
      + signals.fleetInterface.networkOutMulticastPacketsPerSec.withTopK().asPanelMixin()
      + commonlib.panels.network.timeSeries.multicast.stylize()
      + drillDownLink
      + commonlib.panels.network.timeSeries.multicast.withNegateOutPackets()
      + legend.table
      + g.panel.timeSeries.queryOptions.withInterval(this.config.minInterval),

  },
}
