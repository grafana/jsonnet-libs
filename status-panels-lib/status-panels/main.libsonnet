local g = import '../common/g.libsonnet';
local panels = import './panels.libsonnet';
local rows = import './rows.libsonnet';
local targets = import './targets.libsonnet';
local variables = import './variables.libsonnet';
{
  new(
    title,
    type='metrics',
    statusPanelsQueryMetrics='',
    statusPanelsQueryLogs='',
    datasourceNameMetrics='',
    datasourceNameLogs='',
    showIntegrationVersion=true,
    integrationVersion='0.0.0',
    panelsHeight=2,
    panelsWidth=8,
    rowPositionY=0,
    dateTimeUnit='dateTimeFromNow',
  ): {

    local this = self,

    targets: targets(
      datasourceNameMetrics,
      datasourceNameLogs,
      statusPanelsQueryMetrics,
      statusPanelsQueryLogs,
    ),

    panels: panels(
      title,
      type,
      showIntegrationVersion,
      integrationVersion,
      this.targets.statusPanelsTargetMetrics,
      this.targets.statusPanelsTargetLogs,
      panelsHeight,
      panelsWidth,
      rowPositionY,
      dateTimeUnit,
    ),
  },

}
