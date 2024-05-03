{
  wrapExpr(type, expr, q=0.95, aggLevel, rangeFunction):
    if type == 'counter' then
      (
        // for increase/delta/idelta - must be $__interval with negative offset for proper Total calculations, else use default from init function.
        local interval = if (rangeFunction == 'idelta' || rangeFunction == 'delta' || rangeFunction == 'increase') then '[$__interval:] offset -$__interval' else '[%(interval)s]';
        local baseExpr = rangeFunction + '(' + expr + interval + ')';
        if aggLevel == 'none' then
          baseExpr
        else
          ('%(aggFunction)s by (%(agg)s) (' + baseExpr + ')')
      )
    else if type == 'gauge' then
      (
        if aggLevel == 'none' then
          expr
        else
          ('%(aggFunction)s by (%(agg)s) (' + expr + ')')
      )
    else if type == 'histogram' then
      (
        local baseExpr = 'histogram_quantile(' + '%.2f' % q + ', sum(' + rangeFunction + '(' + expr + '[%(interval)s])) by (le,%(agg)s))';
        if aggLevel == 'none' then baseExpr
        else '%(aggFunction)s by (%(agg)s) (' + baseExpr + ')'
      )
    else expr,

  wrapLegend(legend, aggLevel, legendCustomTemplate):
    if legendCustomTemplate != null then legendCustomTemplate
    else if
      aggLevel == 'none' then legend
    else
      '%(aggLegend)s: ' + legend,

  generateUnits(type, unit, rangeFunction):
    if type == 'counter' && (rangeFunction == 'rate' || rangeFunction == 'irate') then
      (
        // some specific cases
        if unit == 'seconds' || unit == 's' then 'percent'
        else if unit == 'requests' then 'rps'
        else if unit == 'packets' then 'pps'
        else if unit == 'short' then '/s'
        else unit
      )
    else unit,

}
