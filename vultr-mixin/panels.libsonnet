local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals.instance,
    local fieldOverride = g.panel.table.fieldOverride,


    instanceCountStat:
      signals.instanceCount.asStat()
      + commonlib.panels.generic.stat.info.stylize(),

    instanceList:
      signals.instanceInfo.asTable()
      + commonlib.panels.generic.table.percentage.stylizeByName('CPU usage')
      + commonlib.panels.generic.table.percentage.stylizeByName('GPU utilization')
      + g.panel.table.queryOptions.withTargetsMixin([
        signals.cpuUsage.asTableTarget(),
        signals.gpuUtilization.asTableTarget(),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        fieldOverride.byName.new('Instance Label')
        + fieldOverride.byName.withProperty('custom.filterable', true)
        + fieldOverride.byName.withProperty('links', [
          {
            targetBlank: false,
            title: 'Drill down to ${__value.text}',
            url: 'd/%s?var-%s=${__data.fields.%s}&${__url_time_range}&${datasource:queryparam}' % [this.grafana.dashboards['vultr-instance-details.json'].uid, 'label', 'label'],
          },
        ]),

      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        g.panel.table.queryOptions.transformation.withId('joinByField')
        + g.panel.table.queryOptions.transformation.withOptions({
          byField: 'label',
          mode: 'inner',
        }),
        g.panel.table.queryOptions.transformation.withId('organize')
        + g.panel.table.queryOptions.transformation.withOptions({
          excludeByName: {},
          indexByName: {
            Label: 0,
            Region: 1,
            plan: 2,
            os: 3,
            'CPU usage': 4,
            'GPU utilization': 5,
          },
          includeByName: {
            label: true,
            region: true,
            os: true,
            plan: true,
            'CPU usage': true,
            'GPU utilization': true,
          },
          renameByName: {
            Label: 'Instance Label',
            os: 'Operating System',
            plan: 'Plan',
          },
        }),
      ]),

    cpuUsage:
      signals.cpuUsage.asTimeSeries()
      + commonlib.panels.cpu.timeSeries.utilization.stylize(),

    diskOperations:
      commonlib.panels.generic.timeSeries.base.new('Disk operations', targets=[])
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.queryOptions.withDatasource('prometheus', '${datasource}')
      + signals.diskReadOps.asPanelMixin()
      + signals.diskWriteOps.asPanelMixin()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('write(-) | read(+)')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisCenteredZero(true)
      + g.panel.timeSeries.standardOptions.withOverrides(
        g.panel.timeSeries.fieldOverride.byRegexp.new('/write/')
        + g.panel.timeSeries.fieldOverride.byRegexp.withPropertiesFromOptions(
          g.panel.timeSeries.fieldConfig.defaults.custom.withTransform('negative-Y')
        )
      )
      + g.panel.timeSeries.panelOptions.withDescription('Disk read and write operations per second. Writes are shown on the negative y-axis.'),

    networkTraffic:
      commonlib.panels.network.timeSeries.traffic.new(
        'Network traffic',
        targets=[],
        description='Network receive and transmit rates. Transmit is shown on the negative y-axis.',
      )
      + g.panel.timeSeries.queryOptions.withDatasource('prometheus', '${datasource}')
      + signals.networkReceive.asPanelMixin()
      + signals.networkTransmit.asPanelMixin()
      + g.panel.timeSeries.standardOptions.withUnit('Bps'),

    bandwidthUsageStat:
      signals.bandwidthUsage.asStat()
      + commonlib.panels.generic.stat.percentage.stylize(),

    bandwidthUsed:
      commonlib.panels.generic.timeSeries.base.new('Bandwidth this billing period', targets=[])
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.queryOptions.withDatasource('prometheus', '${datasource}')
      + signals.bandwidthTransmitted.asPanelMixin()
      + signals.bandwidthReceived.asPanelMixin()
      + signals.bandwidthAllowed.asPanelMixin()
      + g.panel.timeSeries.panelOptions.withDescription('Bandwidth used in the current billing period compared with the allowance. The totals reset at the start of each billing period.'),

    gpuUtilization:
      signals.gpuUtilization.asTimeSeries()
      + commonlib.panels.generic.timeSeries.percentage.stylize(),

    gpuMemoryUsed:
      signals.gpuMemoryUsed.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    gpuTemperature:
      signals.gpuTemperature.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    gpuPower:
      signals.gpuPower.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
  },
}
