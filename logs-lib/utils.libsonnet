{
  local this = self,

  labelsToURLvars(labels, prefix)::
    std.join('&', ['var-%s=${%s%s}' % [label, prefix, label] for label in labels]),

  // For PromQL or LogQL
  labelsToPromQLSelector(labels): std.join(',', ['%s=~"$%s"' % [label, label] for label in labels]),
  labelsToLogQLSelector: self.labelsToPromQLSelector,

  labelsToPanelLegend(labels): std.join('/', ['{{%s}}' % [label] for label in labels]),

  // Generate a chain of labels. Useful to create chained variables
  chainLabels(labels, additionalFilters=[]):
    local last(arr) = std.reverse(arr)[0];
    local chainSelector(chain) =
      std.join(
        ',',
        additionalFilters
        + (if std.length(chain) > 0
           then [this.labelsToPromQLSelector(chain)]
           else [])
      );
    std.foldl(
      function(prev, label)
        prev
        + [{
          label: label,
          chainSelector: chainSelector(self.chain),
          chain::
            if std.length(prev) > 0
            then last(prev).chain + [last(prev).label]
            else [],
        }],
      labels,
      []
    ),
}
