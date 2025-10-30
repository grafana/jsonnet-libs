function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {

      memoryResident: {
        name: 'Memory resident (RAM)',
        type: 'gauge',
        description: 'Resident memory (RAM) usage.',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'mongodb_mem_resident{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - RAM',
          },
        },
      },

      memoryVirtual: {
        name: 'Memory virtual',
        type: 'gauge',
        description: 'Virtual memory usage.',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'mongodb_mem_virtual{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{cl_name}} - virtual',
          },
        },
      },

      memoryResidentByInstance: {
        name: 'Memory resident by instance',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Resident memory (RAM) usage per instance.',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'mongodb_mem_resident{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - RAM',
          },
        },
      },

      memoryVirtualByInstance: {
        name: 'Memory virtual by instance',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Virtual memory usage per instance.',
        unit: 'mbytes',
        sources: {
          prometheus: {
            expr: 'mongodb_mem_virtual{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - virtual',
          },
        },
      },
    },
  }
