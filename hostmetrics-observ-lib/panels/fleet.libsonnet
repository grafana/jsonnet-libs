local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this, common): {
    local signals = this.signals,
    local instanceLabel = std.reverse(this.config.instanceLabels)[0],
    local column(signal) = commonlib.utils.toSentenceCase(signal.nameShort),
    local alertSignals = common.alertsOverview.signals.alerts,

    fleetOverviewTable:
      signals.host.uptime.asTable(name='Fleet overview', format='table')
      + signals.host.hostname.asTableColumn(format='table')
      + signals.host.osName.asTableColumn(format='table')
      + signals.cpu.loadAverage1m.asTableColumn(format='table')
      + signals.host.cpuCount.asTableColumn(format='table')
      + signals.cpu.cpuUsage.asTableColumn(format='table')
      + signals.memory.memoryTotal.asTableColumn(format='table')
      + signals.memory.memoryUsagePercent.asTableColumn(format='table')
      + signals.filesystem.rootFilesystemSize.asTableColumn(format='table')
      + signals.filesystem.rootFilesystemUsagePercent.asTableColumn(format='table')
      + alertSignals.alertsCritical.asTableColumn(format='table')
      + alertSignals.alertsWarning.asTableColumn(format='table')
      + commonlib.panels.system.table.uptime.stylizeByName('Uptime')
      + commonlib.panels.generic.table.percentage.stylizeByName(column(signals.cpu.cpuUsage))
      + commonlib.panels.generic.table.percentage.stylizeByName(column(signals.memory.memoryUsagePercent))
      + commonlib.panels.generic.table.percentage.stylizeByName(column(signals.filesystem.rootFilesystemUsagePercent))
      + g.panel.table.panelOptions.withDescription('One row per host.')
      + g.panel.table.options.withFooter({
        show: true,
        reducer: ['sum'],
        // The footer matches the queries' field names, from before the table renames them.
        fields: [
          'Value #' + s.signalName
          for s in [signals.cpu.loadAverage1m, signals.host.cpuCount, signals.memory.memoryTotal, signals.filesystem.rootFilesystemSize]
        ],
      })
      // The host first, then its group labels and OS, then the values.
      + {
        local columnOrder =
          { [label]: 0 for label in this.config.instanceLabels }
          + { [label]: 2 for label in this.config.groupLabels }
          + { host_name: 1, os_name: 3 },
        transformations: [
          if t.id == 'organize' then t { options+: { indexByName: columnOrder } } else t
          for t in super.transformations
        ],
      }
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new(column(signals.cpu.loadAverage1m))
        + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Load 1m'),
        g.panel.table.fieldOverride.byRegexp.new('^(%s|%s)$' % [column(alertSignals.alertsCritical), column(alertSignals.alertsWarning)])
        + g.panel.table.fieldOverride.byRegexp.withProperty('noValue', '0'),
        g.panel.table.fieldOverride.byRegexp.new(
          '^(%s)$' % std.join('|', [commonlib.utils.toSentenceCase(label) for label in this.config.instanceLabels + this.config.groupLabels] + [column(signals.host.hostname)])
        )
        + g.panel.table.fieldOverride.byRegexp.withProperty('custom.filterable', true),
        g.panel.table.fieldOverride.byName.new(commonlib.utils.toSentenceCase(instanceLabel))
        + g.panel.table.fieldOverride.byName.withProperty('links', [
          {
            targetBlank: false,
            title: 'Drill down to ${__value.text}',
            url: '/d/%s?%s&${__url_time_range}&${%s:queryparam}' % [
              common.overviewUid,
              std.join('&', ['var-%s=${__data.fields.%s}' % [label, label] for label in this.config.instanceLabels]),
              common.datasourceVariable,
            ],
          },
        ]),
      ]),
  },
}
