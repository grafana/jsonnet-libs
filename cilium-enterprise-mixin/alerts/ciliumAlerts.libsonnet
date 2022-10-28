{
  // TODO: All alerts should have configurable cluster, or at least specify which cluster the alert is coming from
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'Cilium Endpoints',
        rules: [
          {
            alert: 'Cilium Agent Endpoint Failures',
            expr: 'sum(cilium_endpoint_state{endpoint_state="invalid"}) by (pod, endpoint_state)',
            labels: {
              severity: 'info',
            },
            'for': '2m',
          },
          {
            alert: 'Cilium Agent Non-Ready Endpoint State',
            expr: 'sum(cilium_endpoint_state{endpoint_state!~"ready"}) by (pod, endpoint_state)',
            labels: {
              severity: 'info',
            },
            'for': '15m',
          },
          {
            alert: 'Cilium Agent Endpoint Update Failure',
            expr: 'sum(rate(cilium_k8s_client_api_calls_total{method=~"(PUT|POST|PATCH)", endpoint="endpoint",return_code!~"2[0-9][0-9]"}[5m])) by (pod, method, return_code)',
            annotations: {
              summary: 'API Calls to Cilium Agent API to create or update Endpoints are failing on pod {{$labels.pod}} ({{$labels.method}} {{$labels.return_code}}).',
            },
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
          {
            alert: 'Cilium Agent CNI API Error Endpoint create',
            expr: 'sum(rate(cilium_api_limiter_processed_requests_total{api_call=~"endpoint-create",outcome="fail"}[1m])) by (pod,api_call)',
            annotations: {
              summary: 'Cilium Endpoint API endpoint rate limiter on Pod {{$labels.pod}} is reporting errors while doing endpoint create.\nThis may cause CNI and prevent Cilium scheduling.',
            },
            labels: {
              severity: 'info',
            },
            'for': '2m',
          },
          {
            alert: 'Cilium Agent API Endpoint Errors',
            expr: 'sum(rate(cilium_agent_api_process_time_seconds_count{return_code!~"2[0-9][0-9]", return_code!="404", path="/v1/endpoint"}[5m])) by (pod, return_code)',
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
      {
        name: 'Cilium IPAM',
        rules: [
          {
            alert: 'Cilium Operator Exhausted IPAM IPs',
            expr: 'sum(cilium_operator_ipam_ips{type="available"})',
            annotations: {
              summary: 'Cilium operator has exhausted its IPAM IPs. This is a critical issue which may cause Pods to fail to be scheduled.',
            },
            labels: {
              severity: 'info',
            },
            'for': '1m',
          },
          {
            // Should be relative time range of 600-0
            alert: 'Cilium Operator Low Available IPAM IPs',
            expr: 'sum(cilium_operator_ipam_ips{type!="available"}) / sum(cilium_operator_ipam_ips)',
            annotations: {
              summary: 'Cilium operator has used up over 90% of its available IPs. If available IPs become exhausted then the operator may not be able to schedule Pods.',
            },
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
      {
        name: 'Cilium Maps',
        rules: [
          {
            alert: 'Cilium Agent Map Operation Failures',
            expr: 'sum(rate(cilium_bpf_map_ops_total{k8s_app="cilium", outcome="fail",pod=~"$pod"}[5m])) by (pod)',
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
          {
            alert: 'Cilium Agent BPF Map Pressure',
            expr: 'cilium_bpf_map_pressure{}',
            annotations: {
              summary: 'Map {{$labels.map_name}} on Cilium Agent Pod is currently experiencing high map pressure. The map is currently over 90% full. Full maps will begin to experience errors on updates which may result in unexpected behaviour.',
            },
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
      {
        name: 'Cilium NAT',
        rules: [
          {
            alert: 'Cilium Agent NAT Table Full',
            expr: 'sum(rate(cilium_drop_count_total{reason="No mapping for NAT masquerade"}[1m])) by (pod)',
            annotations: {
              summary: 'Cilium Agent Pod {{$labels.pod}} is dropping packets due to "No mapping for NAT masquerade" errors. This likely means that the Cilium agents NAT table is full.\nThis is a potentially critical issue that can lead to connection issues for packets leaving the cluster.\n\nSee: https://docs.cilium.io/en/v1.9/concepts/networking/masquerading/ for more info.',
            },
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
      {
        name: 'Cilium API',
        rules: [
          {
            alert: 'Cilium Agent API High Error Rate',
            expr: 'sum(rate(cilium_k8s_client_api_calls_total{endpoint!="metrics",return_code!~"2[0-9][0-9]"}[5m])) by (pod, endpoint, return_code)',
            annotations: {
              summary: 'Cilium Agent API on Pod {{$labels.pod}} is experiencing a high error rate for response code: {{$labels.response_code}} on endpoint {{$labels.endpoint}}.',
            },
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
      {
        name: 'Cilium BPF',
        rules: [
          {
            alert: 'Cilium Agent BPF Map Pressure High',
            expr: 'sum(bpf_map_pressure{}) by (map_name, pod)',
            annotations: {
              summary: 'Cilium agent Pod {{$labels.pod}} is experiencing high bpf map pressure (i.e. the percent of maximum map used for a particular map) for map: {{$labels.map_name}}.\nHigh map pressure may cause the degradation of Ciliums functionality.\n\nNote: This metric is disabled by default.',
            },
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
      {
        name: 'Cilium Conntrack',
        rules: [
          {
            alert: 'Cilium Agent Conntrack Table Full',
            expr: 'sum(rate(cilium_drop_count_total{reason="CT: Map insertion failed"}[5m])) by (pod)',
            annotations: {
              summary: 'Ciliums conntrack map is failing on new insertions on agent Pod {{$labels.pod}}, this likely means that the conntrack BPF map is full. This is a potentially critical issue and may result in unexpected packet drops.\n\nIf this is firing, it is recommend to look at both CPU/memory resource utilization dashboards. As well as conntrack GC run dashboards for more details on what the issue is.',
            },
            labels: {
              severity: 'info',
            },
            'for': '2m',
          },
          {
            // TODO: According to alert dump this should have two conditions/time ranges
            alert: 'Cilium Agent Conn Track Failed GC Runs',
            expr: 'sum(rate(cilium_datapath_conntrack_gc_runs_total{status="uncompleted"}[5m]))',
            annotations: {
              summary: 'Cilium Agent Conntrack GC runs are failing.',
              description: 'Cilium Agent Conntrack GC runs have been reported as not completing. Runs reported "uncompleted" may indicate a problem with ConnTrack GC.\nCilium failing to GC its ConnTrack table may cause further ConnTrack issues later. This may result in dropped packets or other issues.',
            },
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
      {
        name: 'Cilium Drops',
        rules: [
          {
            alert: 'Cilium Agent High Denied Rate',
            expr: 'sum(rate(cilium_drop_count_total{reason="Policy denied"}[1m])) by (reason, pod)',
            annotations: {
              summary: 'Cilium Agent Pod {{$labels.pod}} is experiencing a high drop rate due to policy rule denies. This likely means that a network policy is not configured correctly.',
            },
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
      {
        name: 'Cilium Policy',
        rules: [
          {
            alert: 'Cilium Agent Policy Map Pressure',
            expr: 'sum(cilium_bpf_map_pressure{map_name=~"cilium_policy_.*"}) by (pod)',
            annotations: {
              summary: 'Cilium Agent {{$labels.pod}} is experiencing BPF map pressure on policy map: {{$labels.map_name}}.',
              description: 'Cilium Agent {{$labels.pod}} is experiencing BPF map pressure on policy map: {{$labels.map_name}}. This means that the map is running low on capacity. A full policy map may result in packet drops.',
            },
            labels: {
              severity: 'info',
            },
            'for': '2m',
          },
        ],
      },
      {
        name: 'Cilium Identity',
        rules: [
          {
            alert: 'Cilium Node Local High Identity Allocation',
            expr: '(sum(cilium_identity{type="node_local"}) by (pod) / (2^16-1))',
            annotations: {
              summary: 'Cilium agent Pod {{$labels.pod}} is using a very high percent of its maximum per-node identity limit (65535) . If this capacity is exhausted Cilium may be unable to allocate new identities.',
            },
            labels: {
              severity: 'warning',
            },
            'for': '5m',
          },
          {
            alert: 'Running Out of Cilium Cluster Identities',
            expr: 'sum(cilium_identity{type="cluster_local"}) / (2^16-256) > .8',
            annotations: {
              summary: 'Cilium is using a very high percent of its maximum cluster identity limit (65280) . If this capacity is exhausted Cilium may be unable to allocate new identities.',
            },
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
      {
        name: 'Cilium Nodes',
        rules: [
          {
            alert: 'Cilium Node Connectivity Status Error',
            expr: 'sum(cilium_node_connectivity_status{}) by (pod) != (sum(cilium_node_connectivity_status{}) / count(cilium_version))',
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
          {
            alert: 'Cilium Unreachable Nodes',
            expr: 'sum(cilium_unreachable_nodes{}) by (pod)',
            labels: {
              severity: 'info',
            },
            'for': '5m',
          },
        ],
      },
    ],
  },
}
