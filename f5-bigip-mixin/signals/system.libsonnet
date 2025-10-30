function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {

      // Cluster-level availability percentages (complex raw queries)
      nodeAvailabilityPercentage: {
        name: 'Node availability percentage',
        type: 'raw',
        description: 'The percentage of nodes available.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum by(partition, instance, job) (bigip_node_status_availability_state{%(queriesSelector)s, partition=~"$bigip_partition"})  / clamp_min(count by(partition, instance, job) (bigip_node_status_availability_state{%(queriesSelector)s, partition=~"$bigip_partition"}),1)',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      poolAvailabilityPercentage: {
        name: 'Pool availability percentage',
        type: 'raw',
        description: 'The percentage of pools available.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum by(partition, instance, job) (bigip_pool_status_availability_state{%(queriesSelector)s, partition=~"$bigip_partition"}) / clamp_min(count by(partition, instance, job)  (bigip_pool_status_availability_state{%(queriesSelector)s, partition=~"$bigip_partition"}),1)',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      virtualServerAvailabilityPercentage: {
        name: 'Virtual server availability percentage',
        type: 'raw',
        description: 'The percentage of virtual servers available.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum by(partition, instance, job) (bigip_vs_status_availability_state{%(queriesSelector)s, partition=~"$bigip_partition"}) / clamp_min(count by(partition, instance, job) (bigip_vs_status_availability_state{%(queriesSelector)s, partition=~"$bigip_partition"}),1)',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
