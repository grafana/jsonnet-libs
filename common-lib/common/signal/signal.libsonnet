local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local variables = import '../variables/variables.libsonnet';
local counter = import './counter.libsonnet';
local gauge = import './gauge.libsonnet';
local histogram = import './histogram.libsonnet';
local info = import './info.libsonnet';
local stub = import './stub.libsonnet';
{
  //Expected signalsJson format:
  // {
  //   filteringSelector: 'job!=""',
  //   groupLabels: ['job'],
  //   instanceLabels: ['instance'],
  //   discoveryMetric: 'up',
  //   aggLevel: 'group' or 'instance' or 'none'
  //   signals: {
  //     signal1: {
  //       name: 'Golang version',
  //       type: 'info',
  //       description: 'Golang version used.',
  //       expr: 'go_info{%(queriesSelector)s}',
  //       infoLabel: 'version',
  //     },
  //     signal2:...,
  //     signal3:....
  //   }
  // }
  marshallSignalsJson(signalsJson):
    self.init(
      datasource='$datasource',
      filteringSelector=[signalsJson.filteringSelector],
      groupLabels=signalsJson.groupLabels,
      instanceLabels=signalsJson.instanceLabels,
      varMetric=signalsJson.discoveryMetric,
      aggLevel=signalsJson.aggLevel,
    )
    +
    {
      [s]: super.addSignal(
        name=std.get(signalsJson.signals[s], 'name', error 'Must provide name'),
        type=std.get(signalsJson.signals[s], 'type', error 'Must provide type for signal %s' % signalsJson.signals[s].name),
        unit=std.get(signalsJson.signals[s], 'unit', ''),
        description=std.get(signalsJson.signals[s], 'description', ''),
        expr=std.get(signalsJson.signals[s], 'expr', error 'Must provide expression "expr" for signal %s' % signalsJson.signals[s].name),
        aggLevel=std.get(signalsJson.signals[s], 'aggLevel', 'none'),
        infoLabel=std.get(signalsJson.signals[s], 'infoLabel', null),
      )
      for s in std.objectFieldsAll(signalsJson.signals)
    },

  init(
    datasource='DS_PROMETHEUS',
    filteringSelector=['job=integrations/agent'],
    groupLabels=['job'],
    instanceLabels=['instance'],
    interval='$__rate_interval',
    //default aggregation level
    aggLevel='none',
    aggFunction='avg',
    //metric used in variables discovery by default
    varMetric='up',
    //extra prefix for legend
    legendPrefix=''
  ): self {

    local this = self,
    datasource:: datasource,
    aggLevel:: aggLevel,

    // vars used in dashboards' variables
    local grafanaVariables = variables.new(
      filteringSelector[0],
      groupLabels,
      instanceLabels,
      varMetric=varMetric,
    ),
    // vars are used in templating(legend+expressions)
    templatingVariables: {
      filteringSelector: filteringSelector,
      groupLabels: groupLabels,
      instanceLabels: instanceLabels,
      queriesSelector: grafanaVariables.queriesSelector,
      //used in aggregation queries
      agg: if this.aggLevel == 'group' then std.join(',', self.groupLabels)
      else if this.aggLevel == 'instance' then std.join(',', self.groupLabels + self.instanceLabels)
      else if this.aggLevel == 'none' then std.join(',', []),
      aggFunction: aggFunction,
      //prefix for legend when aggregation is used
      aggLegend:
        if aggLevel == 'group' then utils.labelsToPanelLegend(self.groupLabels)
        else if aggLevel == 'instance' then utils.labelsToPanelLegend(self.groupLabels + self.instanceLabels)
        else if aggLevel == 'none' then '',
      interval: interval,
      //extra prefix for legend
      legendPrefix: legendPrefix,
    },
    //get Grafana Variables
    //allow multiple instance selection
    getVariablesSingleChoice()::
      grafanaVariables.singleInstance,
    //only single instance selection allowed
    getVariablesMultiChoice()::
      grafanaVariables.multiInstance,
    getVariablesDatasource(type='prometheus'):
      grafanaVariables.datasources[type],

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
      infoLabel=null,
    ):

      // validate inputs
      std.prune(
        {
          checks:: [
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
          vars=this.templatingVariables,
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
          vars=this.templatingVariables,
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
          vars=this.templatingVariables,
        )
      else if type == 'info' then
        info.new(
          name=name,
          type=type,
          infoLabel=infoLabel,
          description=description,
          expr=expr,
          aggLevel=aggLevel,
          datasource=datasource,
          vars=this.templatingVariables,
        )
      else if type == 'stub' then
        stub.new(
          name=name,
          type=type,
        ),
  },

}
