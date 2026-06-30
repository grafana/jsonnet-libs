// Datastore signals (shown in the overview dashboard's datastores table).
local selectors = import './selectors.libsonnet';

function(this)
  local s = selectors(this);
  local datastoreSumBy = 'sum by (job, vcenter_datacenter_name, vcenter_datastore_name)';
  local raw(name, expr, unit, description, legend='') = {
    name: name,
    type: 'raw',
    unit: unit,
    description: description,
    sources: {
      prometheus: {
        expr: expr,
        legendCustomTemplate: legend,
      },
    },
  };
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      datastoreDiskTotal: raw(
        'Disk total',
        datastoreSumBy + ' (vcenter_datastore_disk_usage_bytes{' + s.queriesSelector + '})',
        'bytes',
        'The total disk space of the datastore.'
      ),
      datastoreDiskUtilization: raw(
        'Disk utilization',
        'vcenter_datastore_disk_utilization_percent{' + s.queriesSelector + '}',
        'percent',
        'The disk utilization percentage of the datastore.'
      ),
      datastoreDiskAvailable: raw(
        'Disk free',
        'vcenter_datastore_disk_usage_bytes{disk_state="available",' + s.queriesSelector + '}',
        'bytes',
        'The available disk space of the datastore.'
      ),
    },
  }
