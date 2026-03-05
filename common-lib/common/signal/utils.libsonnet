{
  wrapExpr(type, expr, exprWrappers=[], q=0.95, aggLevel, rangeFunction, alertRule, interval): {

    // additional templates to wrap base expression
    functionTemplates::
      (
        if aggLevel != 'none' && (type == 'counter' || type == 'gauge' || type == 'info')
        then
          [
            ['%(aggFunction)s by (%(agg)s) (', ')'],
          ]
        else []
      )
      + exprWrappers,

    withFuncTemplate(funcTemplate):: self {
      functionTemplates+: [funcTemplate],
    },
    runTemplate(expr, funcTemplate):: funcTemplate[0] + '\n  ' + expr + '\n' + funcTemplate[1],
    applyFunctions():: std.foldl(self.runTemplate, self.functionTemplates, self.expr),

    expr: if type == 'counter' then
      (
        // for increase/delta/idelta - must be $__interval with negative offset for proper Total calculations, else use default from init function.
        // if $__range is used in increase/delta/idelta then offset must also be $__range (for table aggregations).
        local _interval =
          if (rangeFunction == 'idelta' || rangeFunction == 'delta' || rangeFunction == 'increase') then
            (
              if alertRule then '[%(interval)s:] offset -%(interval)s'
              else if interval == '$__range' then '[$__range:] offset -$__interval'
              else '[$__interval:] offset -$__interval'
            )
          else '[%(interval)s]';
        local baseExpr = rangeFunction + '(' + expr + _interval + ')';
        baseExpr
      )
    else if type == 'gauge' then
      (
        expr
      )
    else if type == 'histogram' then
      (
        local baseExpr = 'histogram_quantile(' + '%.2f' % q + ', sum(' + rangeFunction + '(' + expr + '[%(interval)s])) by (le,%(agg)s))';
        baseExpr
      )
    else expr,
  },


  wrapLegend(legend, aggLevel, legendCustomTemplate, aggKeepLabels=[]):
    local _suffix = if std.length(aggKeepLabels) > 0 then ' (%(keepLabelsLegend)s)' else '';
    local _prefix =
      if aggLevel == 'aggKeepLabels'
      then ''
      else '%(aggLegend)s';
    if legendCustomTemplate != null then legendCustomTemplate
    else if std.length(legend) > 0 then
      std.lstripChars(_prefix + ': ' + legend + _suffix, ': ')
    else
      std.lstripChars(_prefix + _suffix, ': '),
  generateUnits(type, unit, rangeFunction):
    if type == 'counter' && (rangeFunction == 'rate' || rangeFunction == 'irate') then
      (
        // some specific cases
        if unit == 'seconds' || unit == 's' then 'percent'
        else if unit == 'requests' then 'rps'
        else if unit == 'packets' then 'pps'
        else unit
      )
    else unit,

}
