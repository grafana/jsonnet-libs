// Datastore signals (shown in the overview dashboard's datastores table).
local selectors = import './selectors.libsonnet';

function(this)
  local s = selectors(this);
  local datastoreSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_datastore_name)';
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      datastoreDiskTotal: {
        name: 'Disk total',
        description: 'The total disk space of the datastore.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: datastoreSumBy + ' (vcenter_datastore_disk_usage_bytes{' + s.queriesSelector + '})',
            legendCustomTemplate: '',
          },
        },
      },
      datastoreDiskUtilization: {
        name: 'Disk utilization',
        description: 'The disk utilization percentage of the datastore.',
        type: 'raw',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'vcenter_datastore_disk_utilization_percent{' + s.queriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
      datastoreDiskAvailable: {
        name: 'Disk free',
        description: 'The available disk space of the datastore.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'vcenter_datastore_disk_usage_bytes{disk_state="available",' + s.queriesSelector + '}',
            legendCustomTemplate: '',
          },
        },
      },
    },
  }
