local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals.operations,
    local overviewSignals = this.signals.overview,

    // Overview stat panels
    indexesCountStat:
      overviewSignals.indexesCount.asStat()
      + commonlib.panels.generic.stat.info.stylize(),

    totalRecordsStat:
      overviewSignals.totalRecords.asStat()
      + commonlib.panels.generic.stat.info.stylize(),

    totalStorageStat:
      overviewSignals.totalStorage.asStat()
      + commonlib.panels.generic.stat.info.stylize(),

    // Overview aggregate time series panels
    totalOperationsPerSec:
      overviewSignals.totalOperationsPerSec.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.color.withMode('fixed')
      + g.panel.timeSeries.standardOptions.color.withFixedColor('light-purple')
      + g.panel.timeSeries.panelOptions.withDescription('Total operations per second across all indexes (read + write).'),

    totalReadWriteOperations:
      commonlib.panels.generic.timeSeries.base.new('Read vs Write Operations', targets=[])
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.queryOptions.withDatasource('prometheus', '${datasource}')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + overviewSignals.totalReadOperationsPerSec.asPanelMixin()
      + overviewSignals.totalWriteOperationsPerSec.asPanelMixin()
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel('write(-) | read(+)')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisCenteredZero(true)
      + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'none' })
      + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('line')
      + g.panel.timeSeries.standardOptions.withOverrides(
        g.panel.timeSeries.fieldOverride.byRegexp.new('/Write|write/')
        + g.panel.timeSeries.fieldOverride.byRegexp.withPropertiesFromOptions(
          g.panel.timeSeries.fieldConfig.defaults.custom.withTransform('negative-Y')
        )
      )
      + g.panel.timeSeries.panelOptions.withDescription('Total read and write operations per second across all indexes. Writes are shown on the negative y-axis, reads on the positive y-axis.'),

    // Overview table panel showing all indexes
    indexesTable:
      commonlib.panels.generic.table.base.new(
        'Indexes Overview',
        targets=[
          signals.recordTotal.asTableTarget(),
          signals.storageSizeBytes.asTableTarget(),
        ],
        description='Overview of all indexes showing total records and storage size per index.',
      )
      + g.panel.table.queryOptions.withTransformations([
        // Filter to include only needed columns
        g.panel.table.queryOptions.transformation.withId('filterFieldsByName')
        + g.panel.table.queryOptions.transformation.withOptions({
          include: {
            names: [
              'index_name',
              'instance',
              'Value #Total records',
              'Value #Storage size',
            ],
          },
        }),
        // Merge the two queries
        g.panel.table.queryOptions.transformation.withId('merge')
        + g.panel.table.queryOptions.transformation.withOptions({}),
        // Organize and rename columns
        g.panel.table.queryOptions.transformation.withId('organize')
        + g.panel.table.queryOptions.transformation.withOptions({
          excludeByName: {},
          indexByName: {},
          renameByName: {
            index_name: 'Index Name',
            instance: 'Instance',
            'Value #Total records': 'Total Records',
            'Value #Storage size': 'Storage Size',
          },
          includeByName: {},
        }),
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        // Configure Total Records column
        g.panel.table.fieldOverride.byName.new('Total Records')
        + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withUnit('short')
        ),
        // Configure Storage Size column
        g.panel.table.fieldOverride.byName.new('Storage Size')
        + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
          g.panel.table.standardOptions.withUnit('decbytes')
        ),
      ]),

    // Write operation panels
    upsertTotal:
      signals.upsertTotal.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlPu')
      + g.panel.timeSeries.panelOptions.withDescription('Rate of upsert requests per index.'),

    upsertDuration:
      signals.upsertDuration.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlPu')
      + g.panel.timeSeries.panelOptions.withDescription('Average upsert operation duration per index.'),

    // Read operation panels
    queryTotal:
      signals.queryTotal.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.color.withMode('palette-classic-by-name')
      + g.panel.timeSeries.panelOptions.withDescription('Rate of query requests per index.'),

    queryDuration:
      signals.queryDuration.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.color.withMode('palette-classic-by-name')
      + g.panel.timeSeries.panelOptions.withDescription('Average query operation duration per index.'),

    // Fetch
    fetchTotal:
      signals.fetchTotal.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlPu')
      + g.panel.timeSeries.panelOptions.withDescription('Rate of fetch requests per index.'),

    fetchDuration:
      signals.fetchDuration.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlPu')
      + g.panel.timeSeries.panelOptions.withDescription('Average fetch operation duration per index.'),

    // Delete
    deleteTotal:
      signals.deleteTotal.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.color.withMode('palette-classic-by-name')
      + g.panel.timeSeries.panelOptions.withDescription('Rate of delete requests per index.'),

    deleteDuration:
      signals.deleteDuration.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.standardOptions.color.withMode('palette-classic-by-name')
      + g.panel.timeSeries.panelOptions.withDescription('Average delete operation duration per index.'),

    // Resource usage panels
    writeUnitsTotal:
      signals.writeUnitsTotal.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.color.withMode('continuous-BlPu')
      + g.panel.timeSeries.panelOptions.withDescription('Write units consumed per index over time.'),

    readUnitsTotal:
      signals.readUnitsTotal.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.color.withMode('palette-classic-by-name')
      + g.panel.timeSeries.panelOptions.withDescription('Read units consumed per index over time.'),
  },
}
