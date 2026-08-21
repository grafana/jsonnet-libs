// Control plane: pilot xDS activity, galley validations and sidecar injections.
local selectorsLib = import './selectors.libsonnet';

function(this)
  local selectors = selectorsLib(this);
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    datasource: 'datasource',
    aggLevel: 'none',
    discoveryMetric: {
      prometheus: 'istiod_uptime_seconds',
    },
    signals: {

      pilotCDSxDSPushes: {
        name: 'CDS xDS pushes',
        description: 'Number of xDS pushes by Istiod over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeCDSFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - CDS',
          },
        },
      },

      pilotEDSxDSPushes: {
        name: 'EDS xDS pushes',
        description: 'Number of xDS pushes by Istiod over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeEDSFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - EDS',
          },
        },
      },

      pilotLDSxDSPushes: {
        name: 'LDS xDS pushes',
        description: 'Number of xDS pushes by Istiod over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeLDSFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - LDS',
          },
        },
      },

      pilotRDSxDSPushes: {
        name: 'RDS xDS pushes',
        description: 'Number of xDS pushes by Istiod over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeRDSFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - RDS',
          },
        },
      },

      pilotSDSxDSPushes: {
        name: 'SDS xDS pushes',
        description: 'Number of xDS pushes by Istiod over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeSDSFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - SDS',
          },
        },
      },

      pilotNDSxDSPushes: {
        name: 'NDS xDS pushes',
        description: 'Number of xDS pushes by Istiod over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeNDSFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - NDS',
          },
        },
      },

      pilotxDSProxyPushLatencyBucket: {
        name: 'xDS proxy push latency',
        description: 'The latency of xDS pushes by Istiod over the entire time range for the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'sum by(le, job, cluster) (increase(pilot_proxy_convergence_time_bucket{%(queriesGroupIstiodSelector)s}[$__range:]))' % selectors,
            legendCustomTemplate: '{{cluster}}',
          },
        },
      },

      galleyValidationsPassed: {
        name: 'Galley validations passed',
        description: 'Number of galley validations over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'galley_validation_passed{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - passed',
          },
        },
      },

      galleyValidationsFailed: {
        name: 'Galley validations failed',
        description: 'Number of galley validations over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'galley_validation_failed{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - failed',
          },
        },
      },

      envoyxDSBytesSendRate: {
        name: 'Envoy xDS bytes sent',
        description: 'The send and receive data rates from all envoy proxies in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'envoy_cluster_upstream_cx_rx_bytes_total{%(queriesGroupSelector)s, %(clusterNamexDSGRPCFilter)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - sent',
          },
        },
      },

      envoyxDSBytesReceiveRate: {
        name: 'Envoy xDS bytes received',
        description: 'The send and receive data rates from all envoy proxies in the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'envoy_cluster_upstream_cx_tx_bytes_total{%(queriesGroupSelector)s, %(clusterNamexDSGRPCFilter)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - received',
          },
        },
      },

      pilotCDSxDSRejections: {
        name: 'CDS xDS rejections',
        description: 'The xDS related errors across the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_cds_reject{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - CDS reject',
          },
        },
      },

      pilotEDSxDSRejections: {
        name: 'EDS xDS rejections',
        description: 'The xDS related errors across the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_eds_reject{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - EDS reject',
          },
        },
      },

      pilotRDSxDSRejections: {
        name: 'RDS xDS rejections',
        description: 'The xDS related errors across the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_rds_reject{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - RDS reject',
          },
        },
      },

      pilotLDSxDSRejections: {
        name: 'LDS xDS rejections',
        description: 'The xDS related errors across the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_lds_reject{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - LDS reject',
          },
        },
      },

      pilotxDSWriteTimeouts: {
        name: 'xDS write timeouts',
        description: 'The xDS related errors across the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_xds_write_timeout{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - write timeout',
          },
        },
      },

      pilotxDSInternalErrors: {
        name: 'xDS internal errors',
        description: 'The xDS related errors across the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_total_xds_internal_errors{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - internal',
          },
        },
      },

      pilotxDSProxyRejects: {
        name: 'xDS proxy rejects',
        description: 'The xDS related errors across the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_total_xds_rejects{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - proxy rejects',
          },
        },
      },

      pilotxDSInboundListenerConflicts: {
        name: 'xDS inbound listener conflicts',
        description: 'The xDS related errors across the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_conflict_inbound_listener{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - in listener conflict',
          },
        },
      },

      pilotxDSOutboundListenerTCPConflicts: {
        name: 'xDS outbound listener TCP conflicts',
        description: 'The xDS related errors across the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'pilot_conflict_outbound_listener_tcp_over_current_tcp{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - out listener tcp conflict',
          },
        },
      },

      sidecarInjectionSuccesses: {
        name: 'Sidecar injection successes',
        description: 'Number of sidecar injections over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'sidecar_injection_success_total{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - success',
          },
        },
      },

      sidecarInjectionFailures: {
        name: 'Sidecar injection failures',
        description: 'Number of sidecar injections over the entire time range for the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'sidecar_injection_failure_total{%(queriesGroupIstiodSelector)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - failure',
          },
        },
      },
    },
  }
