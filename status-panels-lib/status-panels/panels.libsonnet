local g = import '../common/g.libsonnet';
local utils = import '../utils.libsonnet';
local stat = g.panel.stat;
local row = g.panel.row;
function(
  title,
  type,
  showIntegrationVersion,
  integrationVersion,
  statusPanelsTargetMetrics,
  statusPanelsTargetLogs,
  panelsHeight,
  panelsWidth,
  rowPositionY,
  dateTimeUnit,
)

  {
    local this = self,
    integrationStatusInit(targets, statusType)::
      stat.new(if statusType == 'metrics' then 'Metrics' else if statusType == 'logs' then 'Logs' else '' + ' status')
      + stat.panelOptions.withDescription('Shows if ' + statusType + ' are being received for the selected time range.')
      + stat.standardOptions.withUnit('string')
      + stat.standardOptions.withNoValue('No data')
      + stat.withTargets(targets)
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor('text')
      + stat.options.reduceOptions.withCalcs('lastNotNull')
      + stat.options.withColorMode('background')
      + stat.options.withGraphMode('none')
      + stat.gridPos.withH(panelsHeight)
      + stat.gridPos.withW(panelsWidth)
      + stat.gridPos.withX(0)
      + stat.standardOptions.withMappings([
        stat.valueMapping.RangeMap.withType('range')
        + stat.valueMapping.RangeMap.options.withFrom(0)
        + stat.valueMapping.RangeMap.options.withTo(0)
        + stat.valueMapping.RangeMap.options.result.withIndex(1)
        + stat.valueMapping.RangeMap.options.result.withText('No ' + statusType + ' detected')
        + stat.valueMapping.RangeMap.options.result.withColor('light-red'),
        stat.valueMapping.RangeMap.withType('range')
        + stat.valueMapping.RangeMap.options.withFrom(0)
        + stat.valueMapping.RangeMap.options.withTo(1000000)
        + stat.valueMapping.RangeMap.options.result.withIndex(1)
        + stat.valueMapping.RangeMap.options.result.withText('Agent sending ' + statusType)
        + stat.valueMapping.RangeMap.options.result.withColor('light-green'),
      ])
      + row.gridPos.withY(rowPositionY),

    latestMetricReceivedInit(targets, statusType)::
      stat.new('Latest ' + statusType + ' received')
      + stat.panelOptions.withDescription('Shows the timestamp of the latest ' + type + ' received for this integration in the last 24 hours.')
      + stat.standardOptions.withUnit(dateTimeUnit)
      + stat.standardOptions.withNoValue('No data')
      + stat.withTargets(targets)
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor('text')
      + stat.options.reduceOptions.withCalcs('lastNotNull')
      + stat.options.reduceOptions.withFields('Time')
      + stat.options.withColorMode('background')
      + stat.options.withGraphMode('none')
      + stat.queryOptions.withTimeFrom('now-24h')
      + stat.gridPos.withH(panelsHeight)
      + stat.gridPos.withW(panelsWidth)
      + stat.gridPos.withX(0 + 1 * panelsWidth)
      + row.gridPos.withY(rowPositionY),

    integrationVersionInit(targets)::
      stat.new('Integration version')
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

    row:: self.rowInit(title),
    integrationStatusMetrics:: self.integrationStatusInit(statusPanelsTargetMetrics, 'metrics'),
    latestMetricReceivedMetrics:: self.latestMetricReceivedInit(statusPanelsTargetMetrics, 'metrics'),
    integrationStatusLogs:: self.integrationStatusInit(statusPanelsTargetLogs, 'logs'),
    latestMetricReceivedLogs:: self.latestMetricReceivedInit(statusPanelsTargetLogs, 'logs'),
    integrationVersion:: self.integrationVersionInit(integrationVersion),

    statusPanels: utils.join([
      if type == 'metrics' || type == 'both' then
        [
          self.integrationStatusMetrics,
          self.latestMetricReceivedMetrics,
        ] else [],
      if type == 'logs' || type == 'both' then
        [
          self.integrationStatusLogs,
          self.latestMetricReceivedLogs,
        ] else [],
      if showIntegrationVersion == true then
        [
          self.integrationVersion,
        ] else [],
    ]),

    statusPanelsWithRow: utils.join([
      [
        self.row,
      ],
      self.statusPanels,
    ]),
  }
