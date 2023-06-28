{
  local this = self,

  labelsToURLvars(labels, prefix)::
    std.join('&', ['var-%s=${%s%s}' % [label, prefix, label] for label in labels]),

  // For PromQL or LogQL
  labelsToPromQLSelector(labels): std.join(',', ['%s=~"$%s"' % [label, label] for label in labels]),
  labelsToLogQLSelector: self.labelsToPromQLSelector,

  labelsToPanelLegend(labels): std.join('/', ['{{%s}}' % [label] for label in labels]),

  local chainLabelsfold(prev, label) = {
    chain:
      if std.length(prev) > 0
      then
        [[label] + prev.chain[0]] + prev.chain
      else
        [[label]],
  },
  // Generate a chain of labels. Useful to create chained variables
  chainLabels(labels):
    [
      {
        label: l[0:1][0],
        chainSelector: this.labelsToPromQLSelector(std.reverse(l[1:])),
      }
      for l in std.reverse(std.foldl(chainLabelsfold, labels, init={}).chain)
    ],
}
