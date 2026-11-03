// Every node reports the same bucket stats, so they are reduced with max.
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'max',
    discoveryMetric: {
      prometheus: 'minio_version_info',
    },
    signals: {
      size: {
        name: 'Total size',
        nameShort: 'Size',
        type: 'gauge',
        unit: 'bytes',
        description: 'Total size of the objects in each bucket.',
        sources: {
          prometheus: {
            expr: 'bucket_usage_size{%(queriesSelector)s}',
            aggKeepLabels: ['bucket'],
            legendCustomTemplate: '{{bucket}}',
          },
        },
      },
      objects: {
        name: 'Object count',
        nameShort: 'Objects',
        type: 'gauge',
        unit: 'short',
        description: 'Number of objects in each bucket.',
        sources: {
          prometheus: {
            expr: 'bucket_objects_count{%(queriesSelector)s}',
            aggKeepLabels: ['bucket'],
            legendCustomTemplate: '{{bucket}}',
          },
        },
      },
      objectsBySize: {
        name: 'Object counts per size',
        nameShort: 'Objects',
        type: 'gauge',
        unit: 'short',
        description: 'Number of objects in each bucket, by object size range.',
        sources: {
          prometheus: {
            expr: 'bucket_objects_histogram{%(queriesSelector)s}',
            aggKeepLabels: ['bucket', 'object_size'],
            legendCustomTemplate: '{{bucket}}-{{object_size}}',
          },
        },
      },
    },
  }
