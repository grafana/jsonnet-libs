function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {
      rssMemory: {
        name: 'RSS memory',
        type: 'gauge',
        unit: 'bytes',
        description: 'Total RSS memory used by process.',
        sources: {
          prometheus: {
            expr: 'discourse_rss{%(queriesSelector)s}',
            aggKeepLabels: ['pid'],
            legendCustomTemplate: 'pid: {{pid}}',
          },
        },
      },

      v8HeapSize: {
        name: 'V8 heap size',
        type: 'gauge',
        unit: 'bytes',
        description: 'Current heap size of V8 engine broken up by process type.',
        sources: {
          prometheus: {
            expr: 'discourse_v8_used_heap_size{%(queriesSelector)s}',
            aggKeepLabels: ['type'],
            legendCustomTemplate: '{{type}}',
          },
        },
      },
    },
  }
