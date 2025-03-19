local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    // Azure Virtual Network
    vn_under_ddos:
      this.signals.azurevirtualnetwork.underDdos.asStat(),

    vn_pingmesh_avg:
      this.signals.azurevirtualnetwork.pingMeshAvgRoundrip.asTimeSeries(),

    vn_packet_trigger:
      commonlib.panels.generic.timeSeries.base.new('DDoS trigger packets by type', targets=[])
      + g.panel.timeSeries.panelOptions.withDescription('Total packet count contributing to DDoS mitigation being triggered, grouped by protocol.')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.synTriggerPackets.asPanelMixin()
      + this.signals.azurevirtualnetwork.tcpTriggerPackets.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpTriggerPackets.asPanelMixin(),

    vn_bytes_by_action:
      commonlib.panels.generic.timeSeries.base.new('Bytes by DDoS action', targets=[])
      + g.panel.timeSeries.panelOptions.withDescription('Total byte count handled by DDoS mitigation, grouped by action.')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.bytesDropped.asPanelMixin()
      + this.signals.azurevirtualnetwork.bytesForwarded.asPanelMixin(),

    vn_bytes_dropped_by_protocol:
      commonlib.panels.generic.timeSeries.base.new('Bytes dropped in DDoS by protocol', targets=[])
      + g.panel.timeSeries.panelOptions.withDescription('Total byte count dropped by DDoS mitigation, grouped by protocol.')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.tcpBytesDropped.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpBytesDropped.asPanelMixin(),

    vn_bytes_forwarded_by_protocol:
      commonlib.panels.generic.timeSeries.base.new('Bytes forwarded in DDoS by protocol', targets=[])
      + g.panel.timeSeries.panelOptions.withDescription('Total byte count forwarded by DDoS mitigation, grouped by protocol.')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.tcpBytesForwarded.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpBytesForwarded.asPanelMixin(),

    vn_packets_by_action:
      commonlib.panels.generic.timeSeries.base.new('Packets by DDoS action', targets=[])
      + g.panel.timeSeries.panelOptions.withDescription('Total packet per second count handled by DDoS mitigation, grouped by action.')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.packetsDropped.asPanelMixin()
      + this.signals.azurevirtualnetwork.packetsForwarded.asPanelMixin(),

    vn_packets_dropped_by_protocol:
      commonlib.panels.generic.timeSeries.base.new('Packets dropped in DDoS by protocol', targets=[])
      + g.panel.timeSeries.panelOptions.withDescription('Total packet per second count dropped by DDoS mitigation, grouped by protocol.')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.tcpPacketsDropped.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpPacketsDropped.asPanelMixin(),

    vn_packets_forwarded_by_protocol:
      commonlib.panels.generic.timeSeries.base.new('Packets forwarded in DDoS by protocol', targets=[])
      + g.panel.timeSeries.panelOptions.withDescription('Total packet per second count forwarded by DDoS mitigation, grouped by protocol.')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.azurevirtualnetwork.tcpPacketsForwarded.asPanelMixin()
      + this.signals.azurevirtualnetwork.udpPacketsForwarded.asPanelMixin(),
  },
}
