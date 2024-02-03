{
  wrapExpr(type, expr, q=0.95, aggLevel):
    if type == 'counter' then
      (
        local baseExpr = 'rate(' + expr + '[%(interval)s])';
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
        local baseExpr = 'histogram_quantile(' + '%.2f' % q + ', sum(rate(' + expr + '[%(interval)s])) by (le,%(agg)s))';
        if aggLevel == 'none' then baseExpr
        else '%(aggFunction)s by (%(agg)s) (' + baseExpr + ')'
      )
    else if type == 'info' || type == 'info' then
      expr,


  wrapLegend(legend, aggLevel):
    if aggLevel == 'none' then '%(legendPrefix)s' + legend
    else
      '%(aggLegend)s%(legendPrefix)s: ' + legend,

  generateUnits(type, unit):
    if type == 'gauge' || type == 'histogram' || type == 'info' then unit
    else if type == 'counter' then
      (
        // some specific cases
        if unit == 'seconds' then 'percent'
        else if unit == 'requests' then 'rps'
        else if unit == 'short' then '/s'
        else unit[0] + 'ps'
      ),

}
