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
  // DEPRECATED. Use unmarshallJsonMulti instead.
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
        aggLevel=std.get(signalsJson.signals[s], 'aggLevel', signalsJson.aggLevel),
        aggFunction=std.get(signalsJson.signals[s], 'aggFunction', std.get(signalsJson, 'aggFunction', 'avg')),
        sourceMaps=[
          {
            expr: std.get(signalsJson.signals[s], 'expr', error 'Must provide expression "expr" for signal %s' % signalsJson.signals[s].name),
            exprWrappers: std.get(signalsJson.signals[s], 'exprWrappers', []),
            rangeFunction: std.get(signalsJson.signals[s], 'rangeFunction', std.get(signalsJson, 'rangeFunction', 'rate')),  // rate, irate , delta, increase, idelta...
            aggFunction: std.get(signalsJson.signals[s], 'aggFunction', std.get(signalsJson, 'aggFunction', 'avg')),
            aggKeepLabels: std.get(signalsJson.signals[s], 'aggKeepLabels', std.get(signalsJson, 'aggKeepLabels', [])),
            infoLabel: std.get(signalsJson.signals[s], 'infoLabel', null),
            type: std.get(signalsJson.signals[s], 'type', error 'Must provide type for signal %s' % signalsJson.signals[s].name),
            legendCustomTemplate: std.get(signalsJson.signals[s], 'legendCustomTemplate', std.get(signalsJson, 'legendCustomTemplate', null)),
            valueMappings: std.get(signalsJson.signals[s], 'valueMappings', []),
          },
        ],
      )
      for s in std.objectFieldsAll(signalsJson.signals)
    },

  unmarshallJsonMulti(signalsJson, type='prometheus'):

    local typeArr =
      (
        if std.type(type) == 'string' then
          [type]
        else  //array
          type
      );

    self.init(
      datasource=std.get(signalsJson, 'datasource', 'datasource'),
      datasourceLabel=std.get(signalsJson, 'datasourceLabel', 'Data source'),
      filteringSelector=[signalsJson.filteringSelector],
      groupLabels=signalsJson.groupLabels,
      instanceLabels=signalsJson.instanceLabels,
      interval=std.get(signalsJson, 'interval', '$__rate_interval'),
      alertsInterval=std.get(signalsJson, 'alertsInterval', '5m'),
      varMetric=self.getVarMetric(signalsJson, type),
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
        if std.objectHas(signalsJson.signals[s], 'sources') && std.length(signalsJson.signals[s]) > 0 then
          local name = std.get(signalsJson.signals[s], 'name', error 'Must provide name');
          local metricType = std.get(signalsJson.signals[s], 'type', error 'Must provide type for signal %s' % s);
          local validatedArr = [
            if
              std.get(signalsJson.signals[s], 'optional', false) == false
              &&
              !std.objectHas(signalsJson.signals[s].sources, sourceName)
            then error 'must provide source for signal %s of type=%s' % [s, sourceName]
            else sourceName
            for sourceName in typeArr
          ];
          local sourceMaps =
            [
              {
                expr: std.get(source.value, 'expr', error 'Must provide expression "expr" for signal %s and type=%s' % [s, source.key]),
                exprWrappers: std.get(source.value, 'exprWrappers', []),
                rangeFunction: std.get(source.value, 'rangeFunction', std.get(signalsJson, 'rangeFunction', 'rate')),
                aggFunction: std.get(source.value, 'aggFunction', std.get(signalsJson, 'aggFunction', 'avg')),
                aggKeepLabels: std.get(source.value, 'aggKeepLabels', std.get(signalsJson, 'aggKeepLabels', [])),
                infoLabel: std.get(source.value, 'infoLabel', null),
                legendCustomTemplate: std.get(source.value, 'legendCustomTemplate', std.get(signalsJson, 'legendCustomTemplate', null)),
                valueMappings: std.get(source.value, 'valueMappings', []),
              }
              for source in std.objectKeysValues(signalsJson.signals[s].sources)
              if std.member(validatedArr, source.key)
            ];

          (if std.length(sourceMaps) > 0 then

             super.addSignal(
               name=name,
               type=metricType,
               unit=std.get(signalsJson.signals[s], 'unit', ''),
               description=std.get(signalsJson.signals[s], 'description', ''),
               aggLevel=std.get(signalsJson.signals[s], 'aggLevel', signalsJson.aggLevel),
               aggFunction=std.get(signalsJson.signals[s], 'aggFunction', std.get(signalsJson, 'aggFunction', 'avg')),
               sourceMaps=sourceMaps
             )
           else
             super.addSignal(
               name=std.get(signalsJson.signals[s], 'name', error 'Must provide name'),
               type='stub',
               description=std.get(signalsJson.signals[s], 'description', ''),
             ))

        else error 'please provide sources for %s' % s

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
      aggLevel=self.aggLevel,
      aggFunction=self.aggFunction,
      sourceMaps=[
        {
          expr: error 'must define expression',
          exprWrappers: [],
          rangeFunction: 'rate',
          aggFunction: aggFunction,
          aggKeepLabels: self.aggKeepLabels,
          infoLabel: null,
          type: type,
          legendCustomTemplate: null,
          valueMappings: [],
        },
      ],
    ):
      // validate inputs
      std.prune(
        {
          checks: [
            if (type != 'gauge' && type != 'histogram' && type != 'counter' && type != 'raw' && type != 'info' && type != 'stub') then error "type must be one of 'gauge','histogram','counter','raw','info' Got %s for %s" % [type, name],
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
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          datasource=datasource,
          vars=this.templatingVariables,
          sourceMaps=sourceMaps,
        )
      else if type == 'raw' then
        raw.new(
          name=name,
          type=type,
          unit=unit,
          description=description,
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          datasource=datasource,
          vars=this.templatingVariables,
          sourceMaps=sourceMaps,
        )
      else if type == 'counter' then
        counter.new(
          name=name,
          type=type,
          unit=unit,
          description=description,
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          datasource=datasource,
          vars=this.templatingVariables,
          sourceMaps=sourceMaps,
        )
      else if type == 'histogram' then
        histogram.new(
          name=name,
          type=type,
          unit=unit,
          description=description,
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          datasource=datasource,
          vars=this.templatingVariables,
          sourceMaps=sourceMaps,
        )
      else if type == 'info' then
        info.new(
          name=name,
          type=type,
          description=description,
          aggLevel=aggLevel,
          aggFunction=aggFunction,
          datasource=datasource,
          vars=this.templatingVariables,
          sourceMaps=sourceMaps,
        )
      else if type == 'stub' then
        stub.new(
          signalName=name,
          type=type,
        ),
  },

  getVarMetric(signalsJson, type):
    if std.objectHas(signalsJson, 'discoveryMetric')
    then
      if std.type(type) == 'array' then
        std.prune(
          [std.get(signalsJson.discoveryMetric, t, null) for t in type]
        )
      else
        std.get(signalsJson.discoveryMetric, type, 'up')
    else 'up',
}
