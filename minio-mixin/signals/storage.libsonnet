// Per-disk storage. `disk` is an instance label here so the dashboard gets a disk variable
// and every query and alert keeps it.
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + ['disk'],
    // Nodes usually mount the same disk paths, so the legend needs every instance label.
    legendCustomTemplate: std.join(' ', ['{{%s}}' % l for l in self.instanceLabels]),
    aggLevel: 'instance',
    aggFunction: 'max',
    discoveryMetric: {
      prometheus: 'disk_storage_available',
    },
    signals: {
      used: {
        name: 'Storage used',
        nameShort: 'Used',
        type: 'gauge',
        unit: 'bytes',
        description: 'Storage used on each disk.',
        sources: {
          prometheus: {
            expr: 'disk_storage_used{%(queriesSelector)s}',
          },
        },
      },
      available: {
        name: 'Storage available',
        nameShort: 'Available',
        type: 'gauge',
        unit: 'bytes',
        description: 'Storage available on each disk.',
        sources: {
          prometheus: {
            expr: 'disk_storage_available{%(queriesSelector)s}',
          },
        },
      },
      total: {
        name: 'Storage total',
        nameShort: 'Total',
        type: 'gauge',
        unit: 'bytes',
        description: 'Total storage capacity of each disk.',
        sources: {
          prometheus: {
            expr: 'disk_storage_total{%(queriesSelector)s}',
          },
        },
      },
      usedRatio: {
        name: 'Storage used ratio',
        nameShort: 'Used',
        type: 'raw',
        unit: 'percentunit',
        description: "Share of each disk's capacity that is used.",
        sources: {
          // Ratio of sums: `sum` is intentional; the by-clause must stay %(agg)s.
          prometheus: {
            expr: |||
              sum by (%(agg)s) (disk_storage_used{%(queriesSelector)s})
              /
              sum by (%(agg)s) (disk_storage_total{%(queriesSelector)s})
            |||,
          },
        },
      },
    },
  }
