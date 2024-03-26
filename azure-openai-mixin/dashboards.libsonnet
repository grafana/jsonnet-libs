local g = import './g.libsonnet';
local logslib = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(this):
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local panels = this.grafana.panels;
    local stat = g.panel.stat;
    {
      'azure-openai-overview.json':
        g.dashboard.new(prefix + 'Overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              g.panel.row.new('Overview'),
              panels.totalCalls,
              panels.successCalls,
              panels.successRate,
              panels.totalErrors,
              panels.errorsRate,
              g.panel.row.new('Tokens overview'),
              panels.generatedTokens,
              panels.tokenTransactions,
              panels.processedPromptTokens,
              panels.processedInferenceTokens,
              g.panel.row.new('Troubleshooting'),
              panels.rateLimitedCalls,
              panels.blockedCalls,
              panels.clientErrors,
              panels.fineTunedTrainingHours,
              panels.dataIn,
              panels.dataOut,
            ], 4, 3
          )
        )
        + root.applyCommon(vars.singleInstance, uid + '-overview', tags, links { backToOverview+:: {} }, annotations, timezone, refresh, period),
    },
  //Apply common options(uids, tags, annotations etc..) to all dashboards above
  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),

}
