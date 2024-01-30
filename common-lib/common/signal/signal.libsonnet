local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local counter = import './counter.libsonnet';
local gauge = import './gauge.libsonnet';
local histogram = import './histogram.libsonnet';
{

  init(
    datasource='DS_PROMETHEUS',
    filteringSelector=['job=integrations/agent'],
    groupLabels=['job'],
    instanceLabels=['instance'],
    interval='$__rate_interval',
    //default aggregation level
    aggLevel='none',
    aggFunction='avg',
  ): self {

    local this = self,
    datasource:: datasource,
    aggLevel:: aggLevel,
    // vars are used in templating(legend+expressions)
    vars:: {
      filteringSelector: filteringSelector,
      groupLabels: groupLabels,
      instanceLabels: instanceLabels,
      queriesSelector:
        std.join(',',
                 self.filteringSelector +
                 [utils.labelsToPromQLSelector(self.groupLabels + self.instanceLabels)]),

      //used in aggregation queries
      agg: if this.aggLevel == 'group' then std.join(',', self.groupLabels + self.instanceLabels)
      else if this.aggLevel == 'instance' then std.join(',', self.instanceLabels)
      else if this.aggLevel == 'none' then std.join(',', []),
      aggFunction: aggFunction,
      //prefix for legend when aggregation is used
      aggLegend:
        if aggLevel == 'group' then utils.labelsToPanelLegend(self.groupLabels + self.instanceLabels)
        else if aggLevel == 'instance' then utils.labelsToPanelLegend(self.instanceLabels)
        else if aggLevel == 'none' then '',
      interval: interval,
    },


    //name: metric simple name
    //type: counter, gauge, histogram, // TODO: info metric, status_map metric....
    //unit: simple unit
    //description: metric description
    //exprTemplate: expression template
    addSignal(
      name,
      type,
      unit='short',
      description,
      expr,
      aggLevel=self.aggLevel,
      datasource=self.datasource
    ):

      // validate inputs
      std.prune(
        {
          checks: [
            if (type != 'gauge' && type != 'histogram' && type != 'counter') then error "type must be one of 'gauge','histogram','counter'",
            if (aggLevel != 'none' && aggLevel != 'instance' && aggLevel != 'group') then error "aggLevel must be one of 'group','instance' or 'none'",
          ],
        }
      ) +
      if type == 'gauge' then
        gauge.new(
          name=name,
          type=type,
          unit=unit,
          description=description,
          expr=expr,
          aggLevel=aggLevel,
          datasource=datasource,
          vars=this.vars,
        )
      else if type == 'counter' then
        counter.new(
          name=name,
          type=type,
          unit=unit,
          description=description,
          expr=expr,
          aggLevel=aggLevel,
          datasource=datasource,
          vars=this.vars,
        )
      else if type == 'histogram' then
        histogram.new(
          name=name,
          type=type,
          unit=unit,
          description=description,
          expr=expr,
          aggLevel=aggLevel,
          datasource=datasource,
          vars=this.vars,
        ),
  },

}
