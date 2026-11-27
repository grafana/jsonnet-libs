function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'minio_version_info',
    },
    signals: {
      disksTotal: {
        name: 'Backend disks',
        nameShort: 'Disks',
        type: 'gauge',
        unit: 'none',
        description: 'Total number of disks in Erasure-type backends. This metric is not available for FileSystem backends.',
        sources: {
          prometheus: {
            expr: 'minio_disks_total{%(queriesSelector)s}',
            // Hide the stat for FileSystem backends, which report no disks.
            exprWrappers: [['', ' > 0']],
          },
        },
      },
      disksOffline: {
        name: 'Backend disks offline',
        nameShort: 'Offline',
        type: 'gauge',
        unit: 'none',
        description: 'Number of disks in Erasure-type backends that are offline.',
        sources: {
          prometheus: {
            expr: 'minio_disks_offline{%(queriesSelector)s}',
          },
        },
      },
      errors: {
        name: 'Errors',
        type: 'counter',
        unit: 'reqps',
        aggLevel: 'instance',
        description: 'Rate of S3 requests that returned an error.',
        sources: {
          prometheus: {
            expr: 's3_errors_total{%(queriesSelector)s}',
          },
        },
      },
    },
  }
