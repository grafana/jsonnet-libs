local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  local groupAggList = std.join(',', this.groupLabels);
  local legendCustomTemplate = '{{hbase_cluster}}';
  local groupAggListWithInstance = groupAggList + ', ' + std.join(',', this.instanceLabels);
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    legendCustomTemplate: legendCustomTemplate,
    discoveryMetric: {
      prometheus: 'server_num_region_servers',
    },
    signals: {
      masterStatusHistoryNumRegionServers: {
        name: 'Master status history number of region servers',
        type: 'gauge',
        description: 'The number of region servers for the master status history.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'max without (clusterid,deadregionservers,liveregionservers,servername,zookeeperquorum,isactivemaster) (server_num_region_servers{%(queriesSelector)s, isactivemaster="true"} * 0  + 1 )',
          },
        },
      },

      nonMasterStatusHistoryNumRegionServers: {
        name: 'Non-master status history number of region servers',
        type: 'gauge',
        description: 'The number of region servers for the non-master status history.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: '(max without (clusterid,deadregionservers,liveregionservers,servername,zookeeperquorum,isactivemaster) (server_num_region_servers{%(queriesSelector)s, isactivemaster="false"}) * 0)',
          },
        },
      },

      // Master and cluster status
      liveRegionServers: {
        name: 'Live RegionServers',
        type: 'gauge',
        description: 'Number of RegionServers that are currently live.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'server_num_region_servers{%(queriesSelector)s, isactivemaster="true"}',
          },
        },
      },

      deadRegionServers: {
        name: 'Dead RegionServers',
        type: 'gauge',
        description: 'Number of RegionServers that are currently dead.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'server_num_dead_region_servers{%(queriesSelector)s, isactivemaster="true"}',
          },
        },
      },

      // Connections
      masterConnections: {
        name: 'Master connections',
        type: 'gauge',
        description: 'Number of open connections to the master.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (master_num_open_connections{%(queriesSelector)s})',
            legendCustomTemplate: legendCustomTemplate + ' - masters',
          },
        },
      },

      regionServerConnections: {
        name: 'RegionServer connections',
        type: 'gauge',
        description: 'Number of open connections to RegionServers.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (region_server_num_open_connections{%(queriesSelector)s})',
            legendCustomTemplate: legendCustomTemplate + ' - RegionServers',
          },
        },
      },

      // Authentication
      masterAuthenticationSuccess: {
        name: 'Master authentication successes',
        type: 'raw',
        description: 'Rate of successful authentications to the master.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(master_authentication_successes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: legendCustomTemplate + ' - masters success',
          },
        },
      },

      masterAuthenticationFailure: {
        name: 'Master authentication failures',
        type: 'raw',
        description: 'Rate of failed authentications to the master.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(master_authentication_failures{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: legendCustomTemplate + ' - masters failure',
          },
        },
      },

      regionServerAuthenticationSuccess: {
        name: 'RegionServer authentication successes',
        type: 'raw',
        description: 'Rate of successful authentications to RegionServers.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(region_server_authentication_successes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: legendCustomTemplate + ' - rs success',
          },
        },
      },

      regionServerAuthenticationFailure: {
        name: 'RegionServer authentication failures',
        type: 'raw',
        description: 'Rate of failed authentications to RegionServers.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (rate(region_server_authentication_failures{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: legendCustomTemplate + ' - rs failure',
          },
        },
      },

      // Master queue metrics
      masterQueueSize: {
        name: 'Master queue size',
        type: 'gauge',
        description: 'The size of the queue of requests, operations, and tasks to be processed by the master.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'master_queue_size{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - {{instance}}',
          },
        },
      },

      masterCallsInGeneralQueue: {
        name: 'Master calls in general queue',
        type: 'gauge',
        description: 'Number of calls waiting in the general queue of the master.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (master_num_calls_in_general_queue{%(queriesSelector)s})',
            legendCustomTemplate: legendCustomTemplate + ' - general',
          },
        },
      },

      serverList: {
        name: 'Server live count',
        type: 'gauge',
        description: 'The number of live servers for the cluster.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'label_replace(server_num_region_servers{%(queriesSelector)s}, "master_instance", "$1", "instance", "(.+)")',
          },
        },
      },

      regionServerList: {
        name: 'Region server list',
        type: 'gauge',
        description: 'The list of region servers for the cluster.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'label_replace(server_num_reference_files{%(queriesSelector)s}, "region_server_instance", "$1", "instance", "(.+)")',
          },
        },
      },

      masterCallsInReplicationQueue: {
        name: 'Master calls in replication queue',
        type: 'gauge',
        description: 'Number of calls waiting in the replication queue of the master.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (master_num_calls_in_replication_queue{%(queriesSelector)s})',
            legendCustomTemplate: legendCustomTemplate + ' - replication',
          },
        },
      },

      masterCallsInReadQueue: {
        name: 'Master calls in read queue',
        type: 'gauge',
        description: 'Number of calls waiting in the read queue of the master.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (master_num_calls_in_read_queue{%(queriesSelector)s})',
            legendCustomTemplate: legendCustomTemplate + ' - read',
          },
        },
      },

      masterCallsInWriteQueue: {
        name: 'Master calls in write queue',
        type: 'gauge',
        description: 'Number of calls waiting in the write queue of the master.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (master_num_calls_in_write_queue{%(queriesSelector)s})',
            legendCustomTemplate: legendCustomTemplate + ' - write',
          },
        },
      },

      masterCallsInScanQueue: {
        name: 'Master calls in scan queue',
        type: 'gauge',
        description: 'Number of calls waiting in the scan queue of the master.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (master_num_calls_in_scan_queue{%(queriesSelector)s})',
            legendCustomTemplate: legendCustomTemplate + ' - scan',
          },
        },
      },

      masterCallsInPriorityQueue: {
        name: 'Master calls in priority queue',
        type: 'gauge',
        description: 'Number of calls waiting in the priority queue of the master.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggList + ') (master_num_calls_in_priority_queue{%(queriesSelector)s})',
            legendCustomTemplate: legendCustomTemplate + ' - priority',
          },
        },
      },

      // Regions in transition
      regionsInTransition: {
        name: 'Regions in transition',
        type: 'gauge',
        description: 'The number of regions in transition for the cluster.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'assignment_manager_rit_count{%(queriesSelector)s}',
          },
        },
      },

      oldRegionsInTransition: {
        name: 'Old regions in transition',
        type: 'gauge',
        description: 'The number of regions in transition that are over the threshold age.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'assignment_manager_rit_count_over_threshold{%(queriesSelector)s}',
            legendCustomTemplate: legendCustomTemplate + ' - old',
          },
        },
      },

      oldestRegionInTransitionAge: {
        name: 'Oldest region in transition age',
        type: 'gauge',
        description: 'The age of the longest region in transition for the master of the cluster.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'assignment_manager_rit_oldest_age{%(queriesSelector)s}',
          },
        },
      },

      // JVM memory for masters
      masterJvmHeapMemoryUsage: {
        name: 'Master JVM heap memory usage',
        type: 'raw',
        description: 'Heap memory usage for the master JVM.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'jvm_metrics_mem_heap_used_m{%(queriesSelector)s, processname=~"Master"} / clamp_min(jvm_metrics_mem_heap_committed_m{%(queriesSelector)s, processname=~"Master"}, 1)',
            legendCustomTemplate: legendCustomTemplate + ' - {{instance}}',
          },
        },
      },
    },
  }
