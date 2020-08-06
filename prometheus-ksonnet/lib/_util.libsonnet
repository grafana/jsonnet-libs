{
  normalise(str):: std.foldl(
    function(acc, chr)
      std.strReplace(acc, chr, '-'),
    ['_', '.'],
    str
  ),

  emptyMixin:: {
    prometheusAlerts+:: {},
    prometheusRules+:: {},
  },
}