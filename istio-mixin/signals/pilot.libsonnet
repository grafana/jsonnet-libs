local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      pilotBuild: {
        name: 'Pilot version',
        nameShort: 'Pilot version',
        type: 'raw',
        description: 'Istio pilot build info, labeled by version tag.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(tag) (istio_build{component="pilot", %(queriesSelector)s})',
          },
        },
      },

      pilotXdsPushes: {
        name: 'Pilot XDS pushes',
        nameShort: 'XDS pushes',
        type: 'counter',
        description: 'Rate of XDS configuration pushes from Pilot, by type.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'pilot_xds_pushes{%(queriesSelector)s}',
          },
        },
      },

      pilotXdsEndpoints: {
        name: 'XDS connected endpoints',
        nameShort: 'XDS endpoints',
        type: 'gauge',
        description: 'Number of endpoints connected to Pilot using xDS.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_xds{%(queriesSelector)s}',
          },
        },
      },

      pilotDestruleSubsets: {
        name: 'Duplicate DestinationRule subsets',
        nameShort: 'Dup DR subsets',
        type: 'gauge',
        description: 'Number of duplicate subsets across DestinationRules for the same host.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_destrule_subsets{%(queriesSelector)s}',
          },
        },
      },

      pilotDuplicateEnvoyClusters: {
        name: 'Duplicate Envoy clusters',
        nameShort: 'Dup clusters',
        type: 'gauge',
        description: 'Number of duplicate Envoy clusters caused by ServiceEntries with the same hostname.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_duplicate_envoy_clusters{%(queriesSelector)s}',
          },
        },
      },

      pilotInboundUpdates: {
        name: 'Pilot inbound updates',
        nameShort: 'Updates',
        type: 'counter',
        description: 'Total number of updates received by Pilot, by type.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'pilot_inbound_updates{%(queriesSelector)s}',
          },
        },
      },

      pilotServices: {
        name: 'Services known to Pilot',
        nameShort: 'Services',
        type: 'gauge',
        description: 'Total number of services known to Pilot.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_services{%(queriesSelector)s}',
          },
        },
      },

      pilotVirtServices: {
        name: 'Virtual services known to Pilot',
        nameShort: 'Virtual services',
        type: 'gauge',
        description: 'Total number of virtual services known to Pilot.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_virt_services{%(queriesSelector)s}',
          },
        },
      },

      pilotVserviceDupDomain: {
        name: 'Virtual services with duplicate domains',
        nameShort: 'Dup VS domains',
        type: 'gauge',
        description: 'Number of virtual services with duplicate domains.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_vservice_dup_domain{%(queriesSelector)s}',
          },
        },
      },

      pilotProxyConvergenceTimeBucket: {
        name: 'Proxy convergence time',
        nameShort: 'Convergence time',
        type: 'raw',
        description: 'Histogram of delay between config change and a proxy receiving all required configuration.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'pilot_proxy_convergence_time_bucket{%(queriesSelector)s}',
          },
        },
      },

      pilotConflictInboundListener: {
        name: 'Conflicting inbound listeners',
        nameShort: 'Inbound conflicts',
        type: 'gauge',
        description: 'Number of conflicting inbound listeners.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_conflict_inbound_listener{%(queriesSelector)s}',
          },
        },
      },

      pilotConflictOutboundListenerHttpOverTcp: {
        name: 'Conflicting outbound listeners (HTTP over TCP)',
        nameShort: 'HTTP over TCP',
        type: 'gauge',
        description: 'Number of conflicting wildcard HTTP outbound listeners with current wildcard TCP listener.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_conflict_outbound_listener_http_over_current_tcp{%(queriesSelector)s}',
          },
        },
      },

      pilotConflictOutboundListenerTcpOverTcp: {
        name: 'Conflicting outbound listeners (TCP over TCP)',
        nameShort: 'TCP over TCP',
        type: 'gauge',
        description: 'Number of conflicting wildcard TCP outbound listeners with current wildcard TCP listener.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_conflict_outbound_listener_tcp_over_current_tcp{%(queriesSelector)s}',
          },
        },
      },

      pilotConflictOutboundListenerTcpOverHttp: {
        name: 'Conflicting outbound listeners (TCP over HTTP)',
        nameShort: 'TCP over HTTP',
        type: 'gauge',
        description: 'Number of conflicting TCP outbound listeners with current HTTP listener.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_conflict_outbound_listener_tcp_over_current_http{%(queriesSelector)s}',
          },
        },
      },

      pilotK8sRegEvents: {
        name: 'k8s registry events',
        nameShort: 'Registry events',
        type: 'counter',
        description: 'Events from the k8s service registry, by event type.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'pilot_k8s_reg_events{%(queriesSelector)s}',
          },
        },
      },

      pilotK8sCfgEvents: {
        name: 'k8s config events',
        nameShort: 'Config events',
        type: 'counter',
        description: 'Events from the k8s config registry (VirtualService, DestinationRule, etc.), by type and event.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'pilot_k8s_cfg_events{%(queriesSelector)s}',
          },
        },
      },

      pilotNoIp: {
        name: 'Pods not found in endpoint table',
        nameShort: 'Missing pods',
        type: 'gauge',
        description: 'Number of pods not found in the endpoint table, possibly invalid.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'pilot_no_ip{%(queriesSelector)s}',
          },
        },
      },

      pilotXdsPushTimeSum: {
        name: 'Pilot XDS push time',
        nameShort: 'Push time',
        type: 'raw',
        description: 'Total time in seconds Pilot takes to push LDS, RDS, CDS and EDS configurations.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'pilot_xds_push_time_sum{%(queriesSelector)s}',
          },
        },
      },
    },
  }
