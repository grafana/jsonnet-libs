local common = import './common.libsonnet';

function(this)
  local fsSources(expr, extra={}) =
    common.sources(std.strReplace(expr, '%(queriesSelector)s', '%(queriesSelector)s, ' + this.filesystemSelector + ', ' + this.filesystemMountpointSelector), extra);
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: common.discoveryMetric,
    signals: {
      filesystemUsagePercent: {
        name: 'Disk space usage',
        nameShort: 'Used',
        type: 'gauge',
        aggFunction: 'max',
        description: 'Share of each filesystem in use.',
        unit: 'percent',
        sources: fsSources(
          'system_filesystem_utilization{%(queriesSelector)s, mode!="ro"}',
          { aggKeepLabels: ['mountpoint'], legendCustomTemplate: '%(aggLegend)s {{mountpoint}}', exprWrappers: [['100 * (', ')']] },
        ),
      },
      filesystemAvailable: {
        name: 'Filesystem space available',
        nameShort: 'Available',
        type: 'gauge',
        description: 'Free bytes per filesystem.',
        unit: 'bytes',
        sources: fsSources('system_filesystem_usage{%(queriesSelector)s, state="free"}', { aggKeepLabels: ['mountpoint'] }),
      },
      filesystemUsageByState: {
        name: 'Filesystem space by state',
        nameShort: 'Space',
        type: 'gauge',
        description: 'Used, free and reserved bytes per filesystem.',
        unit: 'bytes',
        sources: fsSources('system_filesystem_usage{%(queriesSelector)s}', { aggKeepLabels: ['mountpoint', 'state'] }),
      },
      rootFilesystemSize: {
        name: 'Root mount size',
        nameShort: 'Root FS size',
        type: 'gauge',
        description: 'Size of the root filesystem.',
        unit: 'bytes',
        sources: fsSources('system_filesystem_usage{%(queriesSelector)s, mountpoint="/"}'),
      },
      rootFilesystemUsagePercent: {
        name: 'Root mount usage',
        nameShort: 'Root FS used',
        type: 'gauge',
        aggFunction: 'max',
        description: 'Share of the root filesystem in use.',
        unit: 'percent',
        sources: fsSources(
          'system_filesystem_utilization{%(queriesSelector)s, mountpoint="/"}',
          { legendCustomTemplate: '%(aggLegend)s', exprWrappers: [['100 * (', ')']] },
        ),
      },
      inodesFree: {
        name: 'Free inodes',
        nameShort: 'Free',
        type: 'gauge',
        description: 'Free inodes per filesystem.',
        unit: 'short',
        sources: fsSources('system_filesystem_inodes_usage{%(queriesSelector)s, state="free"}', { aggKeepLabels: ['mountpoint'] }),
      },
      inodesTotal: {
        name: 'Total inodes',
        nameShort: 'Total',
        type: 'gauge',
        description: 'Inodes used and free per filesystem.',
        unit: 'short',
        sources: fsSources('system_filesystem_inodes_usage{%(queriesSelector)s}', { aggKeepLabels: ['mountpoint'] }),
      },
      // Raw: used inodes over the total of all states, per filesystem.
      inodesUsagePercent: {
        name: 'Inode usage',
        nameShort: 'Inodes used',
        type: 'raw',
        description: 'Share of inodes in use per filesystem.',
        unit: 'percent',
        sources: fsSources(
          '100 * max by (%(agg)s, mountpoint) (system_filesystem_inodes_usage{%(queriesSelector)s, state="used", mode!="ro"} / ignoring(state) sum without (state) (system_filesystem_inodes_usage{%(queriesSelector)s, mode!="ro"}))',
          { legendCustomTemplate: '%(aggLegend)s {{mountpoint}}' },
        ),
      },
    },
  }
