function(this)
  local legendCustomTemplate =
    std.join(' - ', std.map(
      function(label) '{{' + label + '}}',
      std.filter(
        function(label) !(label == 'job' || label == 'cluster'),
        this.groupLabels + this.instanceLabels
      )
    ));
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
    aggFunction: 'avg',
    aggLevel: 'none',
    discoveryMetric: {
      prometheus: 'hadoop_nodemanager_applicationsrunning',
    },
    signals: {
      applicationsRunning: {
        name: 'Applications running',
        nameShort: 'Running apps',
        type: 'gauge',
        description: 'Number of applications currently running on the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_applicationsrunning{%(queriesSelector)s}',
          },
        },
      },

      allocatedContainers: {
        name: 'Allocated containers',
        nameShort: 'Containers',
        type: 'gauge',
        description: 'Number of containers allocated by the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_allocatedcontainers{%(queriesSelector)s}',
          },
        },
      },

      localizationDuration: {
        name: 'Localization duration',
        nameShort: 'Localization',
        type: 'gauge',
        description: 'Average time taken for localization operations.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_localizationdurationmillisavgtime{%(queriesSelector)s}',
          },
        },
      },

      containersLaunchDuration: {
        name: 'Container launch duration',
        nameShort: 'Launch time',
        type: 'gauge',
        description: 'Average time taken to launch containers.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containerlaunchdurationavgtime{%(queriesSelector)s}',
          },
        },
      },

      // ==========================
      // NodeManager JVM Panels
      // ==========================

      heapMemoryUsage: {
        name: 'Heap memory usage',
        nameShort: 'Heap memory',
        type: 'gauge',
        description: 'JVM heap memory usage of the NodeManager.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_memheapusedm{name="JvmMetrics", %(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - heap',
          },
        },
      },

      nonHeapMemoryUsage: {
        name: 'Non-heap memory usage',
        nameShort: 'Non-heap memory',
        type: 'gauge',
        description: 'JVM non-heap memory usage of the NodeManager.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_memnonheapusedm{name="JvmMetrics", %(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - nonheap',
          },
        },
      },

      heapMemoryCommitted: {
        name: 'Heap memory committed',
        nameShort: 'Heap memory committed',
        type: 'gauge',
        description: 'JVM heap memory committed of the NodeManager.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_memheapcommittedm{name="JvmMetrics", %(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - heap',
          },
        },
      },

      nonHeapMemoryCommitted: {
        name: 'Non-heap memory committed',
        nameShort: 'Non-heap memory committed',
        type: 'gauge',
        description: 'JVM non-heap memory committed of the NodeManager.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_memnonheapcommittedm{name="JvmMetrics", %(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - nonheap',
          },
        },
      },

      gcCount: {
        name: 'GC count',
        nameShort: 'GC count',
        type: 'counter',
        description: 'Rate of garbage collection events.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_gccount{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },

      gcTime: {
        name: 'GC time per collection',
        nameShort: 'GC time',
        type: 'raw',
        description: 'Average time per garbage collection event.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'increase(hadoop_nodemanager_gctimemillis{%(queriesSelector)s}[$__interval:] offset -$__interval) / clamp_min(increase(hadoop_nodemanager_gccount{%(queriesSelector)s}[$__interval:] offset -$__interval), 1)',
            rangeFunction: 'increase',
          },
        },
      },

      nodeHeapMemoryUsage: {
        name: 'Node heap memory usage',
        nameShort: 'Node heap memory usage',
        type: 'gauge',
        description: 'Heap memory usage of the NodeManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_memheapusedm{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - heap',
          },
        },
      },

      nodeNonHeapMemoryUsage: {
        name: 'Node non-heap memory usage',
        nameShort: 'Node non-heap memory usage',
        type: 'gauge',
        description: 'Non-heap memory usage of the NodeManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_memnonheapusedm{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - nonheap',
          },
        },
      },

      nodeHeapMemoryCommitted: {
        name: 'Node heap memory committed',
        nameShort: 'Node heap memory committed',
        type: 'gauge',
        description: 'Heap memory committed of the NodeManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_memheapcommittedm{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - heap',
          },
        },
      },

      nodeNonHeapMemoryCommitted: {
        name: 'Node non-heap memory committed',
        nameShort: 'Node non-heap memory committed',
        type: 'gauge',
        description: 'Non-heap memory committed of the NodeManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_memnonheapcommittedm{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - nonheap',
          },
        },
      },

      nodeCPUUtilization: {
        name: 'Node CPU utilization',
        nameShort: 'Node CPU utilization',
        type: 'raw',
        description: 'CPU utilization of the NodeManager.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * hadoop_nodemanager_nodecpuutilization{%(queriesSelector)s}',
          },
        },
      },

      nodeGPUUtilization: {
        name: 'GPU utilization',
        nameShort: 'GPU utilization',
        type: 'raw',
        description: 'GPU utilization of the NodeManager.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * hadoop_nodemanager_nodegpuutilization{%(queriesSelector)s}',
          },
        },
      },

      // ==========================
      // NodeManager Container Panels
      // ==========================

      containerStatePaused: {
        name: 'Container state paused',
        nameShort: 'Container state paused',
        type: 'gauge',
        description: 'Number of containers in paused state of the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containerspaused{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - paused',
          },
        },
      },

      containerStateLaunched: {
        name: 'Container state launched',
        nameShort: 'Container state launched',
        type: 'gauge',
        description: 'Number of containers in launched state of the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containerslaunched{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - launched',
          },
        },
      },

      containerStateCompleted: {
        name: 'Container state completed',
        nameShort: 'Container state completed',
        type: 'gauge',
        description: 'Number of containers in completed state of the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containerscompleted{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - completed',
          },
        },
      },


      containerStateFailed: {
        name: 'Container state failed',
        nameShort: 'Container state failed',
        type: 'gauge',
        description: 'Number of containers in failed state of the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containersfailed{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - failed',
          },
        },
      },

      containerStateKilled: {
        name: 'Container state killed',
        nameShort: 'Container state killed',
        type: 'gauge',
        description: 'Number of containers in killed state of the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containerskilled{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - killed',
          },
        },
      },

      containerStateIniting: {
        name: 'Container state initing',
        nameShort: 'Container state initing',
        type: 'gauge',
        description: 'Number of containers in initing state of the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containersiniting{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - initing',
          },
        },
      },

      containerStateReiniting: {
        name: 'Container state reiniting',
        nameShort: 'Container state reiniting',
        type: 'gauge',
        description: 'Number of containers in reiniting state of the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containersreiniting{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - reiniting',
          },
        },
      },

      containerUsedMemory: {
        name: 'Containers used memory',
        nameShort: 'Containers used memory',
        type: 'gauge',
        description: 'Used memory of the containers of the NodeManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containerusedmemgb{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - used memory',
          },
        },
      },

      containerUsedVirtualMemory: {
        name: 'Containers used virtual memory',
        nameShort: 'Containers used virtual memory',
        type: 'gauge',
        description: 'Used virtual memory of the containers of the NodeManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_containerusedvmemgb{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - used virtual memory',
          },
        },
      },

      containersAvailableMemory: {
        name: 'Containers available memory',
        nameShort: 'Containers available memory',
        type: 'gauge',
        description: 'Available memory of the containers of the NodeManager.',
        unit: 'decgbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_availablegb{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - available memory',
          },
        },
      },

      containersAllocatedMemory: {
        name: 'Containers allocated memory',
        nameShort: 'Containers allocated memory',
        type: 'gauge',
        description: 'Allocated memory of the containers of the NodeManager.',
        unit: 'decgbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_allocatedgb{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - allocated memory',
          },
        },
      },

      containersAvailableVCores: {
        name: 'Containers available vCores',
        nameShort: 'Containers available vCores',
        type: 'gauge',
        description: 'Available vCores of the containers of the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_availablevcores{name="NodeManagerMetrics", %(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - available',
          },
        },
      },

      containersAllocatedVCores: {
        name: 'Containers allocated vCores',
        nameShort: 'Containers allocated vCores',
        type: 'gauge',
        description: 'Allocated vCores of the containers of the NodeManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_nodemanager_allocatedvcores{name="NodeManagerMetrics", %(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - allocated',
          },
        },
      },
    },
  }
