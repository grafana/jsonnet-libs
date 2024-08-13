local g = import '../g.libsonnet';
local utils = import '../utils.libsonnet';
local variables = import '../variables/variables.libsonnet';
local counter = import './counter.libsonnet';
local gauge = import './gauge.libsonnet';
local histogram = import './histogram.libsonnet';
local info = import './info.libsonnet';
local raw = import './raw.libsonnet';
local stub = import './stub.libsonnet';
{
  //Expected signalsJson format:
  // {
  //   filteringSelector: 'job!=""',
  //   groupLabels: ['job'],
  //   instanceLabels: ['instance'],
  //   discoveryMetric: 'up',
  //   aggLevel: 'group' or 'instance' or 'none',
  //   aggFunction: 'avg',
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
  unmarshallJson(signalsJson):
    self.init(
      datasource=std.get(signalsJson, 'datasource', 'datasource'),
      datasourceLabel=std.get(signalsJson, 'datasourceLabel', 'Data source'),
      filteringSelector=[signalsJson.filteringSelector],
      groupLabels=signalsJson.groupLabels,
      instanceLabels=signalsJson.instanceLabels,
      interval=std.get(signalsJson, 'interval', '$__rate_interval'),
      alertsInterval=std.get(signalsJson, 'alertsInterval', '5m'),
      varMetric=std.get(signalsJson, 'discoveryMetric', 'up'),
      aggLevel=std.get(signalsJson, 'aggLevel', 'none'),
      aggFunction=std.get(signalsJson, 'aggFunction', 'avg'),
      aggKeepLabels=std.get(signalsJson, 'aggKeepLabels', []),
      legendCustomTemplate=std.get(signalsJson, 'legendCustomTemplate', null),
      rangeFunction=std.get(signalsJson, 'rangeFunction', 'rate'),  // rate, irate , delta, increase, idelta...
    )
    +
    {
      [s]: super.addSignal(
        name=std.get(signalsJson.signals[s], 'name', error 'Must provide name'),
        type=std.get(signalsJson.signals[s], 'type', error 'Must provide type for signal %s' % signalsJson.signals[s].name),
        unit=std.get(signalsJson.signals[s], 'unit', ''),
        description=std.get(signalsJson.signals[s], 'description', ''),
        expr=std.get(signalsJson.signals[s], 'expr', error 'Must provide expression "expr" for signal %s' % signalsJson.signals[s].name),
        exprWrappers=std.get(signalsJson.signals[s], 'exprWrappers', []),
        aggLevel=std.get(signalsJson.signals[s], 'aggLevel', signalsJson.aggLevel),
        aggFunction=std.get(signalsJson.signals[s], 'aggFunction', std.get(signalsJson, 'aggFunction', 'avg')),
        aggKeepLabels=std.get(signalsJson.signals[s], 'aggKeepLabels', std.get(signalsJson, 'aggKeepLabels', [])),
        infoLabel=std.get(signalsJson.signals[s], 'infoLabel', null),
        valueMappings=std.get(signalsJson.signals[s], 'valueMappings', []),
        legendCustomTemplate=std.get(signalsJson.signals[s], 'legendCustomTemplate', std.get(signalsJson, 'legendCustomTemplate', null)),
        rangeFunction=std.get(signalsJson.signals[s], 'rangeFunction', std.get(signalsJson, 'rangeFunction', 'rate')),  // rate, irate , delta, increase, idelta...
      )
      for s in std.objectFieldsAll(signalsJson.signals)
    },

  unmarshallJsonMulti(signalsJson, type='prometheus'):

    self.init(
      datasource=std.get(signalsJson, 'datasource', 'datasource'),
      datasourceLabel=std.get(signalsJson, 'datasourceLabel', 'Data source'),
      filteringSelector=[signalsJson.filteringSelector],
      groupLabels=signalsJson.groupLabels,
      instanceLabels=signalsJson.instanceLabels,
      interval=std.get(signalsJson, 'interval', '$__rate_interval'),
      alertsInterval=std.get(signalsJson, 'alertsInterval', '5m'),
      varMetric=if std.objectHas(signalsJson, 'discoveryMetric') then std.get(signalsJson.discoveryMetric, type, 'up') else 'up',
      aggLevel=std.get(signalsJson, 'aggLevel', 'none'),
      aggFunction=std.get(signalsJson, 'aggFunction', 'avg'),
      aggKeepLabels=std.get(signalsJson, 'aggKeepLabels', []),
      legendCustomTemplate=std.get(signalsJson, 'legendCustomTemplate', null),
      rangeFunction=std.get(signalsJson, 'rangeFunction', std.get(signalsJson, 'rangeFunction', 'rate')),  // rate, irate , delta, increase, idelta...
    )
    +
    {
      [s]:
        //validate name:
        (if !std.objectHas(signalsJson.signals[s], 'name') then error ('Must provide name') else {}) +
        if std.objectHas(signalsJson.signals[s], 'sources') && std.objectHas(signalsJson.signals[s].sources, type) then
          super.addSignal(
            name=std.get(signalsJson.signals[s], 'name', error 'Must provide name'),
            type=std.get(signalsJson.signals[s], 'type', error 'Must provide type for signal %s' % signalsJson.signals[s].name),
            unit=std.get(signalsJson.signals[s], 'unit', ''),
            description=std.get(signalsJson.signals[s], 'description', ''),
            expr=std.get(signalsJson.signals[s].sources[type], 'expr', error 'Must provide expression "expr" for signal %s and type=%s' % [signalsJson.signals[s].name, type]),
            exprWrappers=std.get(signalsJson.signals[s].sources[type], 'exprWrappers', []),
            aggLevel=std.get(signalsJson.signals[s], 'aggLevel', signalsJson.aggLevel),
            aggFunction=std.get(signalsJson.signals[s], 'aggFunction', std.get(signalsJson, 'aggFunction', 'avg')),
            aggKeepLabels=std.get(signalsJson.signals[s].sources[type], 'aggKeepLabels', std.get(signalsJson, 'aggKeepLabels', [])),
            infoLabel=std.get(signalsJson.signals[s].sources[type], 'infoLabel', null),
            valueMappings=std.get(signalsJson.signals[s].sources[type], 'valueMappings', []),
            legendCustomTemplate=std.get(signalsJson.signals[s].sources[type], 'legendCustomTemplate', std.get(signalsJson, 'legendCustomTemplate', null)),
            rangeFunction=std.get(signalsJson.signals[s].sources[type], 'rangeFunction', std.get(signalsJson, 'rangeFunction', 'rate')),
          )
        else if std.get(signalsJson.signals[s], 'optional', false) == false then error 'must provide source for signal %s of type=%s' % [signalsJson.signals[s].name, type] else
          //maybe add stub signal?
          super.addSignal(
            name=std.get(signalsJson.signals[s], 'name', error 'Must provide name'),
            type='stub',
            expr='',
            description=std.get(signalsJson.signals[s], 'description', ''),
          )

      for s in std.objectFieldsAll(signalsJson.signals)
    },

  init(
    datasource='datasource',
    datasourceLabel='Data source',
    filteringSelector=['job!=""'],
    groupLabels=['job'],
    instanceLabels=['instance'],
    interval='$__rate_interval',
    // interval used in alert expressions
    alertsInterval='5m',
    //default aggregation level
    aggLevel='none',
    aggKeepLabels=[],
    aggFunction='avg',
    //metric used in variables discovery by default
    varMetric='up',
    legendCustomTemplate=null,
    rangeFunction='rate'
  ): self {

    local this = self,
    datasource:: datasource,
    aggLevel:: aggLevel,
    aggKeepLabels:: aggKeepLabels,
    aggFunction:: aggFunction,

    // vars used in dashboards' variables
    local grafanaVariables = variables.new(
      filteringSelector[0],
      groupLabels,
      instanceLabels,
      varMetric=varMetric,
      prometheusDatasourceName=datasource,
      prometheusDatasourceLabel=datasourceLabel,
    ),
    // vars are used in templating(legend+expressions)
    templatingVariables: {
      filteringSelector: filteringSelector,
      groupLabels: groupLabels,
      instanceLabels: instanceLabels,
      queriesSelector: grafanaVariables.queriesSelector,
      interval: interval,
      alertsInterval: alertsInterval,
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
      exprWrappers=[],
      aggLevel=self.aggLevel,
      aggFunction=self.aggFunction,
      aggKeepLabels=self.aggKeepLabels,
      infoLabel=null,
      valueMappings=[],
      legendCustomTemplate=null,
      rangeFunction='rate'
    ):

      // validate inputs
      std.prune(
        {
          checks: [
            if (type != 'gauge' && type != 'histogram' && type != 'counter' && type != 'raw' && type != 'info' && type != 'stub') then error "type must be one of 'gauge','histogram','counter','raw','info' Got %s for %s" % [type, name],
            if (aggLevel != 'none' && aggLevel != 'instance' && aggLevel != 'group') then error "aggLevel must be one of 'group','instance' or 'none'",
            if (exprWrappers != null && !std.isArray(exprWrappers)) then error 'exprWrappers must be an array.',
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
          exprWrappers=exprWrappers,
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          aggKeepLabels=aggKeepLabels,
          datasource=datasource,
          vars=this.templatingVariables,
          valueMappings=valueMappings,
          legendCustomTemplate=legendCustomTemplate,
        )
      else if type == 'raw' then
        raw.new(
          name=name,
          type=type,
          unit=unit,
          description=description,
          expr=expr,
          exprWrappers=exprWrappers,
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          aggKeepLabels=aggKeepLabels,
          datasource=datasource,
          vars=this.templatingVariables,
          valueMappings=valueMappings,
          legendCustomTemplate=legendCustomTemplate,
          rangeFunction=rangeFunction,
        )
      else if type == 'counter' then
        counter.new(
          name=name,
          type=type,
          unit=unit,
          description=description,
          expr=expr,
          exprWrappers=exprWrappers,
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          aggKeepLabels=aggKeepLabels,
          datasource=datasource,
          vars=this.templatingVariables,
          valueMappings=valueMappings,
          legendCustomTemplate=legendCustomTemplate,
          rangeFunction=rangeFunction,
        )
      else if type == 'histogram' then
        histogram.new(
          name=name,
          type=type,
          unit=unit,
          description=description,
          expr=expr,
          exprWrappers=exprWrappers,
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          aggKeepLabels=aggKeepLabels,
          datasource=datasource,
          vars=this.templatingVariables,
          valueMappings=valueMappings,
          legendCustomTemplate=legendCustomTemplate,
          rangeFunction=rangeFunction,
        )
      else if type == 'info' then
        info.new(
          name=name,
          type=type,
          infoLabel=infoLabel,
          description=description,
          expr=expr,
          exprWrappers=exprWrappers,
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          aggKeepLabels=aggKeepLabels,
          datasource=datasource,
          vars=this.templatingVariables,
          valueMappings=valueMappings,
          legendCustomTemplate=legendCustomTemplate,
        )
      else if type == 'stub' then
        stub.new(
          signalName=name,
          type=type,
        ),
  },
}
