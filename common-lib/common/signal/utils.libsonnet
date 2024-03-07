{
  wrapExpr(type, expr, q=0.95, aggLevel, rangeFunction):
    if type == 'counter' then
      (
        local baseExpr = rangeFunction + '(' + expr + '[%(interval)s])';
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
    else if type == 'info' || type == 'info' then
      expr,


  wrapLegend(legend, aggLevel, legendCustomTemplate):
    if legendCustomTemplate != null then legendCustomTemplate
    else if
      aggLevel == 'none' then legend
    else
      '%(aggLegend)s: ' + legend,

  generateUnits(type, unit):
    if type == 'gauge' || type == 'histogram' || type == 'info' then unit
    else if type == 'counter' then
      (
        // some specific cases
        if unit == 'seconds' || unit == 's' then 'percent'
        else if unit == 'requests' then 'rps'
        else if unit == 'packets' then 'pps'
        else if unit == 'short' then '/s'
        else unit
      ),

}
