local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local stat = g.panel.stat;
local row = g.panel.row;
function(
  type,
  title,
  showIntegrationVersion,
  integrationVersion,
  statusPanelsTarget,
  panelsHeight,
  panelsWidth,
  rowPositionY,
)

  {
    local this = self,

    integrationStatusInit(targets, title='Integration Status')::
      stat.new(title)
      + stat.panelOptions.withDescription('Shows the status of this integration.')
      + stat.standardOptions.withUnit('string')
      + stat.standardOptions.withNoValue('No data')
      + stat.withTargets(targets)
      + stat.standardOptions.color.withMode('thresholds')
      + stat.options.reduceOptions.withCalcs('lastNotNull')
      + stat.options.withColorMode('background')
      + stat.options.withGraphMode('none')
      + stat.queryOptions.withTimeFrom('now/d')
      + stat.gridPos.withH(panelsHeight)
      + stat.gridPos.withW(panelsWidth)
      + stat.gridPos.withX(0)
      + stat.standardOptions.withMappings([
        stat.valueMapping.RangeMap.withType('range')
        + stat.valueMapping.RangeMap.options.withFrom(0)
        + stat.valueMapping.RangeMap.options.withTo(0)
        + stat.valueMapping.RangeMap.options.result.withIndex(1)
        + stat.valueMapping.RangeMap.options.result.withText('No metrics detected')
        + stat.valueMapping.RangeMap.options.result.withColor('red'),
        stat.valueMapping.RangeMap.withType('range')
        + stat.valueMapping.RangeMap.options.withFrom(0)
        + stat.valueMapping.RangeMap.options.withTo(1000000)
        + stat.valueMapping.RangeMap.options.result.withIndex(1)
        + stat.valueMapping.RangeMap.options.result.withText('Agent sending metrics')
        + stat.valueMapping.RangeMap.options.result.withColor('green'),
      ])
      + row.gridPos.withY(rowPositionY),

    latestMetricReceivedInit(targets, title='Latest Metric Received')::
      stat.new(title)
      + stat.panelOptions.withDescription('Shows the timestamp of the latest metric received for this integration.')
      + stat.standardOptions.withUnit('dateTimeAsIso')
      + stat.standardOptions.withNoValue('No data')
      + stat.withTargets(targets)
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor('text')
      + stat.options.reduceOptions.withCalcs('lastNotNull')
      + stat.options.reduceOptions.withFields('Time')
      + stat.options.withColorMode('background')
      + stat.options.withGraphMode('none')
      + stat.queryOptions.withTimeFrom('now/d')
      + stat.gridPos.withH(panelsHeight)
      + stat.gridPos.withW(panelsWidth)
      + stat.gridPos.withX(0 + 1 * panelsWidth)
      + row.gridPos.withY(rowPositionY),

    integrationVersionInit(targets, title='Integration Version')::
      stat.new(title)
      + stat.panelOptions.withDescription('Shows the installed version of this integration.')
      + stat.standardOptions.withUnit('string')
      + stat.standardOptions.withNoValue(integrationVersion)
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor('text')
      + stat.gridPos.withH(panelsHeight)
      + stat.gridPos.withW(panelsWidth)
      + stat.gridPos.withX(0 + 2 * panelsWidth)
      + row.gridPos.withY(rowPositionY),

    rowInit(title)::
      row.new(title)
      + row.gridPos.withY(rowPositionY),

    integrationStatusPanel: self.integrationStatusInit(statusPanelsTarget),
    latestMetricReceivedPanel: self.latestMetricReceivedInit(statusPanelsTarget),
    integrationVersionPanel: self.integrationVersionInit(statusPanelsTarget),
    row: self.rowInit(title),

    statusPanelsRow: [
      self.row,
      self.integrationStatusPanel,
      self.latestMetricReceivedPanel,
      if showIntegrationVersion then
        self.integrationVersionPanel,
    ],

  }
