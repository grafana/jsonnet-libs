local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this): {
    // Azure ElasticPool
    _aep_tableCommon()::
      g.panel.table.queryOptions.withTransformations([
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            pattern: 'resourceName.*|Value.*',
          },
        }),
        g.panel.table.queryOptions.transformation.withId('joinByField')
        + g.panel.table.queryOptions.transformation.withOptions({
          byField: 'resourceName',
          mode: 'outer',
        }),
      ])
      + g.panel.table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'resourceName',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Elastic pool',
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
            options: 'Value #Allocated',
          },
          properties: [
            {
              id: 'displayName',
              value: 'Allocated',
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

    aep_storage:
      this.signals.azureelasticpool.storageAllocTbl.common
      + commonlib.panels.generic.table.base.new(
        'Elastic pool storage',
        [
          this.signals.azureelasticpool.storageAllocTbl.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),

          this.signals.azureelasticpool.storageUsedTbl.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),

          this.signals.azureelasticpool.storageLimitTbl.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ],
        'Storage overview per elasticpool.'
      ) + self._aep_tableCommon(),

    aep_cpu:
      this.signals.azureelasticpool.cpu.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    aep_mem:
      this.signals.azureelasticpool.memory.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    aep_dtu:
      this.signals.azureelasticpool.edtu.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    aep_session:
      this.signals.azureelasticpool.session.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
  },
}
