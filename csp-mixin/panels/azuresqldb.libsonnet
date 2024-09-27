local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    // Azure SQL Database
    _asql_tableCommon()::
      g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            pattern: 'database.*|Value.*',
          },
        }),
        g.panel.table.queryOptions.transformation.withId('joinByField')
        + g.panel.table.queryOptions.transformation.withOptions({
          byField: 'database',
          mode: 'outer',
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'database',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Database',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Used',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Used',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Percent of limit',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Percent of limit',
            },
          ],
        },
        {
          matcher: {
            id: 'byName',
            options: 'Value #Limit',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Limit',
            },
          ],
        },
      ]),
    asql_conns:
      this.signals.azuresqldb.successfulConns.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_deadlocks:
      this.signals.azuresqldb.deadlocks.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_sessions:
      this.signals.azuresqldb.sessions.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_cpu:
      this.signals.azuresqldb.cpuPercent.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + this.signals.azuresqldb.vCoreCpuPercent.asPanelMixin(),

    asql_storagebytes:
      this.signals.azuresqldb.storageBytes.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    asql_storagepercent:
      this.signals.azuresqldb.storagePercent.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_dtuts:
      this.signals.azuresqldb.dtuUsed.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    asql_dtutbl:
      this.signals.azuresqldb.dtuUsed.common
      + commonlib.panels.generic.table.base.new(
        'DTU utilization and limits by database',
        [
          this.signals.azuresqldb.dtuUsed.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),

          this.signals.azuresqldb.dtuPercent.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),

          this.signals.azuresqldb.dtuLimit.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'DTU utilization and limits by database'
      ) + self._asql_tableCommon(),
  },
}
