local commonlib = import 'common-lib/common/main.libsonnet';

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
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'hadoop_resourcemanager_numactivenms',
    },
    signals: {
      activeNodeManagers: {
        name: 'Active NodeManagers',
        nameShort: 'Active NodeManagers',
        type: 'gauge',
        description: 'Number of active NodeManagers.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_numactivenms{%(queriesSelector)s, name="ClusterMetrics"}',
            legendCustomTemplate: 'active',
          },
        },
      },

      decommissionedNodeManagers: {
        name: 'Decommissioned NodeManagers',
        nameShort: 'Decommissioned NodeManagers',
        type: 'gauge',
        description: 'Number of decommissioned NodeManagers.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_numdecommissionednms{%(queriesSelector)s, name="ClusterMetrics"}',
            legendCustomTemplate: 'decommissioned',
          },
        },
      },

      lostNodeManagers: {
        name: 'Lost NodeManagers',
        nameShort: 'Lost NodeManagers',
        type: 'gauge',
        description: 'Number of lost NodeManagers.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_numlostnms{%(queriesSelector)s, name="ClusterMetrics"}',
            legendCustomTemplate: 'lost',
          },
        },
      },

      unhealthyNodeManagers: {
        name: 'Unhealthy NodeManagers',
        nameShort: 'Unhealthy NodeManagers',
        type: 'gauge',
        description: 'Number of unhealthy NodeManagers.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_numunhealthynms{%(queriesSelector)s, name="ClusterMetrics"}',
            legendCustomTemplate: 'unhealthy',
          },
        },
      },

      rebootedNodeManagers: {
        name: 'Rebooted NodeManagers',
        nameShort: 'Rebooted NodeManagers',
        type: 'gauge',
        description: 'Number of rebooted NodeManagers.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_numrebootednms{%(queriesSelector)s, name="ClusterMetrics"}',
            legendCustomTemplate: 'rebooted',
          },
        },
      },

      shutdownNodeManagers: {
        name: 'Shutdown NodeManagers',
        nameShort: 'Shutdown NodeManagers',
        type: 'gauge',
        description: 'Number of shutdown NodeManagers.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_numshutdownnms{%(queriesSelector)s, name="ClusterMetrics"}',
            legendCustomTemplate: 'shutdown',
          },
        },
      },

      applicationsRunning: {
        name: 'Applications running',
        nameShort: 'Running',
        type: 'gauge',
        description: 'Number of applications currently running.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_appsrunning{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'running',
          },
        },
      },

      applicationsPending: {
        name: 'Applications pending',
        nameShort: 'Pending',
        type: 'gauge',
        description: 'Number of applications pending execution.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_appspending{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'pending',
          },
        },
      },

      applicationsKilled: {
        name: 'Applications killed',
        nameShort: 'Killed',
        type: 'gauge',
        description: 'Number of applications that have been killed.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_appskilled{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'killed',
          },
        },
      },

      applicationsSubmitted: {
        name: 'Applications submitted',
        nameShort: 'Submitted',
        type: 'gauge',
        description: 'Number of applications submitted.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_appssubmitted{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'submitted',
          },
        },
      },

      applicationsCompleted: {
        name: 'Applications completed',
        nameShort: 'Completed',
        type: 'gauge',
        description: 'Number of applications that have been completed.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_appscompleted{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'completed',
          },
        },
      },

      applicationsFailed: {
        name: 'Applications failed',
        nameShort: 'Failed',
        type: 'gauge',
        description: 'Number of applications that have been failed.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_appsfailed{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'failed',
          },
        },
      },

      allocatedMemory: {
        name: 'Allocated memory',
        nameShort: 'Allocated MB',
        type: 'gauge',
        description: 'Amount of memory allocated by the ResourceManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_allocatedmb{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'allocated',
          },
        },
      },

      availableMemory: {
        name: 'Available memory',
        nameShort: 'Available MB',
        type: 'gauge',
        description: 'Amount of memory available in the ResourceManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_availablemb{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'available',
          },
        },
      },

      allocatedVCores: {
        name: 'Allocated virtual cores',
        nameShort: 'Allocated vCores',
        type: 'gauge',
        description: 'Number of virtual cores allocated by the ResourceManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_allocatedvcores{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'allocated',
          },
        },
      },

      availableVCores: {
        name: 'Available virtual cores',
        nameShort: 'Available vCores',
        type: 'gauge',
        description: 'Number of virtual cores available in the ResourceManager.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_availablevcores{%(queriesSelector)s, name="QueueMetrics", q0="root", q1="default"}',
            legendCustomTemplate: 'available',
          },
        },
      },

      heapMemoryUsed: {
        name: 'Heap memory used',
        nameShort: 'Heap memory used',
        type: 'gauge',
        description: 'Amount of heap memory used by the ResourceManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_memheapusedm{name="JvmMetrics", %(queriesSelector)s}',
            legendCustomTemplate: 'heap',
          },
        },
      },

      nonHeapMemoryUsed: {
        name: 'Non-heap memory used',
        nameShort: 'Non-heap memory used',
        type: 'gauge',
        description: 'Amount of non-heap memory used by the ResourceManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_memnonheapusedm{name="JvmMetrics", %(queriesSelector)s}',
            legendCustomTemplate: 'nonheap',
          },
        },
      },

      heapMemoryCommitted: {
        name: 'Heap memory committed',
        nameShort: 'Heap memory committed',
        type: 'gauge',
        description: 'Amount of heap memory committed by the ResourceManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_memheapcommittedm{name="JvmMetrics", %(queriesSelector)s}',
            legendCustomTemplate: 'heap',
          },
        },
      },

      nonHeapMemoryCommitted: {
        name: 'Non-heap memory committed',
        nameShort: 'Non-heap memory committed',
        type: 'gauge',
        description: 'Amount of non-heap memory committed by the ResourceManager.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_memnonheapcommittedm{name="JvmMetrics", %(queriesSelector)s}',
            legendCustomTemplate: 'nonheap',
          },
        },
      },

      gcCount: {
        name: 'Garbage collection count',
        nameShort: 'GC count',
        type: 'counter',
        description: 'Number of garbage collections.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'hadoop_resourcemanager_gccount{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },

      averageGCCTime: {
        name: 'Average garbage collection time',
        nameShort: 'Average GC time',
        type: 'raw',
        description: 'The average duration for each garbage collection operation in the ResourceManager JVM.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'increase(hadoop_resourcemanager_gctimemillis{%(queriesSelector)s}[$__interval:] offset $__interval) / clamp_min(increase(hadoop_resourcemanager_gccount{%(queriesSelector)s}[$__interval:] offset $__interval), 1)',
          },
        },
      },
    },
  }
