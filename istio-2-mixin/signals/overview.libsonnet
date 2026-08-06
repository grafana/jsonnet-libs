// Overview: proxy/gateway/istiod resource usage, config object counts and gateway/proxy traffic.
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

      proxyCount: {
        name: 'Proxies',
        description: 'Number of proxies in the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'count',
        sources: {
          prometheus: {
            expr: 'istio_build{%(queriesGroupSelector)s, %(componentProxyFilter)s}' % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      gatewayCount: {
        name: 'Gateways',
        description: 'Number of gateways in the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeGatewayFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeGatewayFilter)s, %(eventDeleteFilter)s}) or max(up * 0))' % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      virtualServiceCount: {
        name: 'Virtual services',
        description: 'Number of virtual services in the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeVirtualServiceFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeVirtualServiceFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      destinationRuleCount: {
        name: 'Destination rules',
        description: 'Number of destination rules in the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeDestinationRuleFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeDestinationRuleFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      serviceEntryCount: {
        name: 'Service entries',
        description: 'Number of service entries in the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeServiceEntryFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeServiceEntryFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      workloadEntryCount: {
        name: 'Workload entries',
        description: 'Number of workload entries in the Istio system.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeWorkloadEntryFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeWorkloadEntryFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % selectors,
            legendCustomTemplate: '',
          },
        },
      },

      istiodCPUUsage: {
        name: 'Istiod CPU usage',
        description: 'vCPU usage for various components of the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'process_cpu_seconds_total{%(queriesGroupIstiodSelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - istiod',
          },
        },
      },

      gatewayCPUUsage: {
        name: 'Gateway CPU usage',
        description: 'vCPU usage for various components of the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_process_cpu_seconds_total{%(queriesGroupGatewaySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - gateway',
          },
        },
      },

      proxyCPUUsage: {
        name: 'Proxy CPU usage',
        description: 'vCPU usage for various components of the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_process_cpu_seconds_total{%(queriesGroupProxySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - proxy',
          },
        },
      },

      istiodOpenFileDescriptors: {
        name: 'Istiod open file descriptors',
        description: 'Number of open file descriptors for various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'process_open_fds{%(queriesGroupIstiodSelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - istiod',
          },
        },
      },

      gatewayOpenFileDescriptors: {
        name: 'Gateway open file descriptors',
        description: 'Number of open file descriptors for various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_process_open_fds{%(queriesGroupGatewaySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - gateway',
          },
        },
      },

      proxyOpenFileDescriptors: {
        name: 'Proxy open file descriptors',
        description: 'Number of open file descriptors for various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_process_open_fds{%(queriesGroupProxySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - proxy',
          },
        },
      },

      istiodVirtualMemory: {
        name: 'Istiod virtual memory',
        description: 'Available virtual memory compared to the resident memory for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'process_virtual_memory_bytes{%(queriesGroupIstiodSelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - istiod - virtual',
          },
        },
      },

      istiodResidentMemory: {
        name: 'Istiod resident memory',
        description: 'Available virtual memory compared to the resident memory for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'process_resident_memory_bytes{%(queriesGroupIstiodSelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - istiod - resident',
          },
        },
      },

      gatewayVirtualMemory: {
        name: 'Gateway virtual memory',
        description: 'Available virtual memory compared to the resident memory for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_process_virtual_memory_bytes{%(queriesGroupGatewaySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - gateway - virtual',
          },
        },
      },

      gatewayResidentMemory: {
        name: 'Gateway resident memory',
        description: 'Available virtual memory compared to the resident memory for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_process_resident_memory_bytes{%(queriesGroupGatewaySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - gateway - resident',
          },
        },
      },

      proxyVirtualMemory: {
        name: 'Proxy virtual memory',
        description: 'Available virtual memory compared to the resident memory for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_process_virtual_memory_bytes{%(queriesGroupProxySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - proxy - virtual',
          },
        },
      },

      proxyResidentMemory: {
        name: 'Proxy resident memory',
        description: 'Available virtual memory compared to the resident memory for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_process_resident_memory_bytes{%(queriesGroupProxySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - proxy - resident',
          },
        },
      },

      istiodHeapAllocated: {
        name: 'Istiod heap allocated',
        description: 'Heap memory information for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_alloc_bytes{%(queriesGroupIstiodSelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - istiod - alloc',
          },
        },
      },

      istiodHeapInUse: {
        name: 'Istiod heap in use',
        description: 'Heap memory information for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_inuse_bytes{%(queriesGroupIstiodSelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - istiod - inuse',
          },
        },
      },

      istiodHeapSystem: {
        name: 'Istiod heap system',
        description: 'Heap memory information for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_sys_bytes{%(queriesGroupIstiodSelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - istiod - sys',
          },
        },
      },

      gatewayHeapAllocated: {
        name: 'Gateway heap allocated',
        description: 'Heap memory information for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_go_memstats_heap_alloc_bytes{%(queriesGroupGatewaySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - gateway - alloc',
          },
        },
      },

      gatewayHeapInUse: {
        name: 'Gateway heap in use',
        description: 'Heap memory information for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_go_memstats_heap_inuse_bytes{%(queriesGroupGatewaySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - gateway - inuse',
          },
        },
      },

      gatewayHeapSystem: {
        name: 'Gateway heap system',
        description: 'Heap memory information for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_go_memstats_heap_sys_bytes{%(queriesGroupGatewaySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - gateway - sys',
          },
        },
      },

      proxyHeapAllocated: {
        name: 'Proxy heap allocated',
        description: 'Heap memory information for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_go_memstats_heap_alloc_bytes{%(queriesGroupProxySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - proxy - alloc',
          },
        },
      },

      proxyHeapInUse: {
        name: 'Proxy heap in use',
        description: 'Heap memory information for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_go_memstats_heap_inuse_bytes{%(queriesGroupProxySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - proxy - inuse',
          },
        },
      },

      proxyHeapSystem: {
        name: 'Proxy heap system',
        description: 'Heap memory information for the various components of the Istio system.',
        type: 'gauge',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_agent_go_memstats_heap_sys_bytes{%(queriesGroupProxySelector)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - proxy - sys',
          },
        },
      },

      gatewayHTTPGRPCRequestRate: {
        name: 'Gateway HTTP/GRPC request rate',
        description: 'HTTP/GRPC request rate for the components of the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupGatewaySelector)s, %(reporterSourceFilter)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - gateway',
          },
        },
      },

      proxyHTTPGRPCRequestRate: {
        name: 'Proxy HTTP/GRPC request rate',
        description: 'HTTP/GRPC request rate for the components of the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupProxySelector)s, %(reporterSourceFilter)s}' % selectors,
            legendCustomTemplate: '{{cluster}} - proxy',
          },
        },
      },

      gatewayHTTPOKResponses: {
        name: 'Gateway HTTP OK responses',
        description: 'Recent number of successful (1xx, 2xx, 3xx) vs error (4xx, 5xx) HTTP responses received by various components of the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupGatewaySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - gateway - ok',
          },
        },
      },

      gatewayHTTPErrorResponses: {
        name: 'Gateway HTTP error responses',
        description: 'Recent number of successful (1xx, 2xx, 3xx) vs error (4xx, 5xx) HTTP responses received by various components of the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupGatewaySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - gateway - error',
          },
        },
      },

      proxyHTTPOKResponses: {
        name: 'Proxy HTTP OK responses',
        description: 'Recent number of successful (1xx, 2xx, 3xx) vs error (4xx, 5xx) HTTP responses received by various components of the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupProxySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - proxy - ok',
          },
        },
      },

      proxyHTTPErrorResponses: {
        name: 'Proxy HTTP error responses',
        description: 'Recent number of successful (1xx, 2xx, 3xx) vs error (4xx, 5xx) HTTP responses received by various components of the Istio system.',
        type: 'counter',
        aggLevel: 'group',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{%(queriesGroupProxySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s}' % selectors,
            rangeFunction: 'increase',
            legendCustomTemplate: '{{cluster}} - proxy - error',
          },
        },
      },
    },
  }
