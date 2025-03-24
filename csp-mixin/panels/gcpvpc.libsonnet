local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    _serviceTableCommon(valueColNiceName)::
      g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            pattern: 'service_name.*|Value.*',
          },
        }),
        g.panel.table.queryOptions.transformation.withId('joinByField')
        + g.panel.table.queryOptions.transformation.withOptions({
          byField: 'service_name',
          mode: 'outer',
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'service_name',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Service name',
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
              id: 'displayName',
              value: valueColNiceName,
            },
          ],
        },
      ]),

    gcpvpc_services_in_use_count:
      this.signals.gcpvpc.gcpvpc_services_in_use_count.asStat()
      + g.panel.stat.standardOptions.color.withMode('fixed')
      + g.panel.stat.standardOptions.color.withFixedColor('text'),

    gcpvpc_subnets_in_use_count:
      this.signals.gcpvpc.gcpvpc_subnets_in_use_count.asStat()
      + g.panel.stat.standardOptions.color.withMode('fixed')
      + g.panel.stat.standardOptions.color.withFixedColor('text'),

    gcpvpc_fixed_usage_tier_network_egress:
      this.signals.gcpvpc.gcpvpc_fixed_usage_tier_network_egress.asTimeSeries()
      + g.panel.timeSeries.standardOptions.withNoValue('0'),

    gcpvpc_service_topk_throughput:
      this.signals.gcpvpc.gcpvpc_service_topk_throughput_bytes.common(type='table')
      + g.panel.table.standardOptions.withUnit('bps')
      + commonlib.panels.generic.table.base.new(
        'Top 5 services - Average throughput',
        [
          this.signals.gcpvpc.gcpvpc_service_topk_throughput_bytes.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Average throughput',
      ) + self._serviceTableCommon('Average throughput'),

    gcpvpc_service_topk_error:
      this.signals.gcpvpc.gcpvpc_service_topk_error_percent.common(type='table')
      + g.panel.table.standardOptions.withUnit('percent')
      + commonlib.panels.generic.table.base.new(
        'Top 5 services - Average error rate',
        [
          this.signals.gcpvpc.gcpvpc_service_topk_error_percent.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Average error rate',
      ) + self._serviceTableCommon('Average error rate'),

    gcpvpc_service_throughput:
      commonlib.panels.network.timeSeries.traffic.new('Total service network throughput', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.gcpvpc.gcpvpc_service_request_bytes.asPanelMixin()
      + this.signals.gcpvpc.gcpvpc_service_response_bytes.asPanelMixin(),

    gcpvpc_service_by_service_throughput:
      commonlib.panels.network.timeSeries.traffic.new('Service network throughput by service', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.gcpvpc.gcpvpc_service_request_by_service_bytes.asPanelMixin()
      + this.signals.gcpvpc.gcpvpc_service_response_by_service_bytes.asPanelMixin(),

    gcpvpc_service_by_responsecode_throughput:
      commonlib.panels.network.timeSeries.traffic.new('Service network throughput by response code', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.gcpvpc.gcpvpc_service_request_by_responsecode_bytes.asPanelMixin()
      + this.signals.gcpvpc.gcpvpc_service_response_by_responsecode_bytes.asPanelMixin(),

    gcpvpc_service_by_service_error_throughput:
      commonlib.panels.network.timeSeries.errors.new('Service network throughput percent by service in error', targets=[])
      + this.signals.gcpvpc.gcpvpc_service_request_by_service_error_bytes.asPanelMixin()
      + this.signals.gcpvpc.gcpvpc_service_response_by_service_error_bytes.asPanelMixin(),

    gcpvpc_tunnel_throughput:
      commonlib.panels.network.timeSeries.traffic.new('Total tunnel network throughput', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.gcpvpc.gcpvpn_tunnel_egress_bytes.asPanelMixin()
      + this.signals.gcpvpc.gcpvpn_tunnel_ingress_bytes.asPanelMixin(),

    gcpvpc_tunnel_by_protocol_throughput:
      commonlib.panels.network.timeSeries.traffic.new('Total tunnel network throughput by protocol', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.gcpvpc.gcpvpn_tunnel_egress_by_protocol_bytes.asPanelMixin()
      + this.signals.gcpvpc.gcpvpn_tunnel_ingress_by_protocol_bytes.asPanelMixin(),

    gcpvpc_tunnel_by_resource_type_throughput:
      commonlib.panels.network.timeSeries.traffic.new('Total tunnel network throughput by resource type', targets=[])
      + commonlib.panels.network.timeSeries.traffic.withNegateOutPackets()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal')
      + this.signals.gcpvpc.gcpvpn_tunnel_egress_by_resource_type_bytes.asPanelMixin()
      + this.signals.gcpvpc.gcpvpn_tunnel_ingress_by_resource_type_bytes.asPanelMixin(),
  },
}
