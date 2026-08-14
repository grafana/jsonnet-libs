function(this) {
  // Left empty so panel queries are driven by the $job/$instance variables alone.
  // The static filteringSelector still constrains the dashboard variable queries.
  filteringSelector: '',
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'openstack_glance_up',
  },
  signals: {
    glance_up: {
      name: 'Glance status',
      description: 'Reports the status of the Glance image service.',
      type: 'gauge',
      unit: 'string',
      sources: {
        prometheus: {
          expr: 'openstack_glance_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    glance_images: {
      name: 'Image count',
      description: 'The number of images present in Glance.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_glance_images{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    glance_image_bytes: {
      name: 'Image size',
      description: 'The size of individual images in Glance in bytes.',
      type: 'gauge',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'openstack_glance_image_bytes{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{name}}',
        },
      },
    },
  },
}
