local g = import './g.libsonnet';
local panels = import './panels.libsonnet';

// Use g.util.grid.wrapPanels() to import into custom dashboard
{
  new(panels): {
    clusterOverviewBucket:
      [
        g.panel.row.new('Buckets'),
        panels.cluster_topBucketsByMemoryUsedPanel { gridPos+: { w: 12 } },
        panels.cluster_topBucketsByDiskUsedPanel { gridPos+: { w: 12 } },
        panels.cluster_topBucketsByOperationsPanel { gridPos+: { w: 12 } },
        panels.cluster_topBucketsByOperationsFailedPanel { gridPos+: { w: 12 } },
        panels.cluster_topBucketsByVBucketsCountPanel { gridPos+: { w: 12 } },
        panels.cluster_topBucketsByVBucketQueueMemoryPanel { gridPos+: { w: 12 } },
      ],
  },
}
