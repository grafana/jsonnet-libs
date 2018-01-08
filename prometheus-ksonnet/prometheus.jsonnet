local k = import "ksonnet.beta.2/k8s.libsonnet";

local configMap = k.core.v1.configMap,
  deployment = k.apps.v1beta1.deployment,
  container = deployment.mixin.spec.template.spec.containersType,
  volume = deployment.mixin.spec.template.spec.volumesType,
  clusterRole = k.rbac.v1beta1.clusterRole,
  policyRule = k.rbac.v1beta1.clusterRole.rulesType,
  clusterRoleBinding = k.rbac.v1beta1.clusterRoleBinding,
  subject = k.rbac.v1beta1.clusterRoleBinding.subjectsType,
  serviceAccount = k.core.v1.serviceAccount;

local prometheusConfig = |||
   global:
     scrape_interval: 30s

   rule_files:
   - alerts.rules
   - recording.rules

   scrape_configs:
   - job_name: 'kubernetes-pods'
     kubernetes_sd_configs:
       - role: pod

     tls_config:
       ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
     bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

     # You can specify the following annotations (on pods):
     #   prometheus.io.scrape: false - don't scrape this pod
     #   prometheus.io.scheme: https - use https for scraping
     #   prometheus.io.port - scrape this port
     #   prometheus.io.path - scrape this path
     relabel_configs:

     # Always use HTTPS for the api server
     - source_labels: [__meta_kubernetes_service_label_component]
       regex: apiserver
       action: replace
       target_label: __scheme__
       replacement: https

     # Drop anything annotated with prometheus.io.scrape=false
     - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
       action: drop
       regex: false

     # Drop any endpoint who's pod port name is not http
     - source_labels: [__meta_kubernetes_pod_container_port_name]
       action: keep
       regex: http$

     # Allow pods to override the scrape scheme with prometheus.io.scheme=https
     - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scheme]
       action: replace
       target_label: __scheme__
       regex: ^(https?)$
       replacement: $1

     # Allow service to override the scrape path with prometheus.io.path=/other_metrics_path
     - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
       action: replace
       target_label: __metrics_path__
       regex: ^(.+)$
       replacement: $1

     # Allow services to override the scrape port with prometheus.io.port=1234
     - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
       action: replace
       target_label: __address__
       regex: (.+?)(\:\d+)?;(\d+)
       replacement: $1:$3

     # Drop pods without a name label
     - source_labels: [__meta_kubernetes_pod_label_name]
       action: drop
       regex: ^$

     # Rename jobs to be <namespace>/<name, from pod name label>
     - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_pod_label_name]
       action: replace
       separator: /
       target_label: job
       replacement: $1

     # But also include the namespace as a separate lable, for routing alerts
     - source_labels: [__meta_kubernetes_namespace]
       action: replace
       target_label: namespace

     # Rename instances to be the pod name
     - source_labels: [__meta_kubernetes_pod_name]
       action: replace
       target_label: instance

     # Include node name as a extra field
     - source_labels: [__meta_kubernetes_pod_node_name]
       target_label: node

   # This scrape config gather all nodes
   - job_name: 'kubernetes-nodes'
     kubernetes_sd_configs:
       - role: node

     # couldn't get prometheus to validate the kublet cert for scraping, so don't bother for now
     tls_config:
       insecure_skip_verify: true
     bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

     relabel_configs:
     - target_label: __address__
       replacement: kubernetes.default.svc.cluster.local:443
     - target_label: __scheme__
       replacement: https
     - source_labels: [__meta_kubernetes_node_name]
       regex: (.+)
       target_label: __metrics_path__
       replacement: /api/v1/nodes/${1}/proxy/metrics

   # This scrape config just pulls in the default/kubernetes service
   - job_name: 'kubernetes-service'
     kubernetes_sd_configs:
       - role: endpoints

     tls_config:
       insecure_skip_verify: true
     bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

     relabel_configs:
     - source_labels: [__meta_kubernetes_service_label_component]
       regex: apiserver
       action: keep

     - target_label: __scheme__
       replacement: https

     - source_labels: []
       target_label: job
       replacement: default/kubernetes
|||;

local alertConfig = |||
  ALERT FrontendError
    IF          sum(rate(request_duration_seconds_count{job=~"[a-z]+/frontend", status_code=~"5.."}[1m])) by (namespace, job, route)
                  /
                sum(rate(request_duration_seconds_count{job=~"[a-z]+/frontend"}[1m])) by (namespace, job, route) * 100 > 0.1
    FOR         15m
    LABELS      { severity = 'critical' }
    ANNOTATIONS {
       summary     = '{{ printf "%0.1f%%" $value }} of requests to {{ $labels.job }} ({{ $labels.route }}) are failing.',
       description = '',
    }

  ALERT PodCrashLooping
    IF          drop_common_labels(rate(kube_pod_container_status_restarts[15m])) > 0
    FOR         1h
    LABELS      { severity = 'critical' }
    ANNOTATIONS {
      summary     = '{{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container }}) is restarting {{ $value }} times per second',
      description = '',
    }

  ALERT PodNotReady
    IF          drop_common_labels(kube_pod_status_ready{condition='true'}) != 1
    FOR         1h
    LABELS      { severity='critical' }
    ANNOTATIONS {
      summary = '{{ $labels.namespace }}/{{ $labels.pod }} is not ready.',
      description = '',
    }

  ALERT DeploymentGenerationMismatch
    IF          kube_deployment_status_observed_generation != kube_deployment_metadata_generation
    FOR         15m
    LABELS      { severity = 'critical' }
    ANNOTATIONS {
      summary    = 'Deployment {{ $labels.namespace }}/{{ labels.deployment }} generation mismatch',
      description = '',
    }

  ALERT DeploymentReplicasMismatch
    IF          kube_deployment_spec_replicas != kube_deployment_status_replicas_available
    FOR         15m
    LABELS      { severity='critical' }
    ANNOTATIONS {
      summary = 'Deployment {{ $labels.namespace }}/{{ $labels.deployment }} replica mismatch',
      description = '',
    }

  ALERT PrometheusBadConfig
    IF     prometheus_config_last_reload_successful{job='default/prometheus'} == 0
    FOR    10m
    LABELS { severity = 'critical' }
    ANNOTATIONS {
      summary     = 'Prometheus failed to reload config',
      description = 'Config error with prometheus, see container logs',
    }

  ALERT AlertmanagerBadConfig
    IF     alertmanager_config_last_reload_successful{job='default/alertmanager'} == 0
    FOR    10m
    LABELS { severity = 'critical' }
    ANNOTATIONS {
      summary     = 'Alertmanager failed to reload config',
      description = 'Config error with alertmanager, see container logs',
    }

  ALERT NodeNotReady
    IF     max(kube_node_status_ready{condition='false'} == 1) by (node)
    FOR    1h
    LABELS { severity = 'warning' }
    ANNOTATIONS {
      summary     = 'Node not ready for a long time',
      description = '{{ $labels.node }} has been unready for more than an hour',
    }

  ALERT ScrapeFailed
    IF     up != 1
    FOR    15m
    LABELS { severity = 'warning' }
    ANNOTATIONS {
      summary     = 'Prometheus failed to scrape a target',
      description = '',
    }
|||;

local recordingRules = |||
  namespace:container_cpu_usage_seconds_total:sum_rate =
    sum(rate(container_cpu_usage_seconds_total{image!=""}[5m])) by (namespace)

  namespace:container_memory_usage_bytes:sum =
    sum(container_memory_usage_bytes{image!=""}) by (namespace)

  namespace_name:container_cpu_usage_seconds_total:sum_rate =
    sum by (namespace, label_name) (
       sum(rate(container_cpu_usage_seconds_total{image!=""}[5m])) by (namespace, pod_name)
     * on (namespace, pod_name) group_left(label_name)
       label_replace(
         label_replace(kube_pod_labels, "pod_name", "$1", "pod", "(.*)"),
         "namespace", "$1", "exported_namespace", "(.*)"
       )
    )


  namespace_name:container_memory_usage_bytes:sum =
    sum by (namespace, label_name) (
      sum(container_memory_usage_bytes{image!=""}) by (pod_name, namespace)
    * on (namespace, pod_name) group_left(label_name)
      label_replace(
        label_replace(kube_pod_labels, "pod_name", "$1", "pod", "(.*)"),
        "namespace", "$1", "exported_namespace", "(.*)"
      )
    )
|||;

{
  prometheus_service_account:
    serviceAccount.new() +
    serviceAccount.mixin.metadata.name("prometheus"),

  prometheus_cluster_role:
    clusterRole.new() +
    clusterRole.mixin.metadata.name("prometheus") +
    clusterRole.rules([
      policyRule.new() +
      policyRule.apiGroups([""]) +
      policyRule.resources(["nodes", "nodes/proxy", "services", "endpoints", "pods"]) +
      policyRule.verbs(["get", "list", "watch"]),
    ]),

  prometheus_cluster_role_binding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata.name("prometheus") +
    clusterRoleBinding.mixin.roleRef.apiGroup("rbac.authorization.k8s.io") +
    { roleRef+: { kind: "ClusterRole" } } +
    clusterRoleBinding.mixin.roleRef.name("prometheus") +
    clusterRoleBinding.subjects([
      subject.new() +
      { kind: "ServiceAccount" } +
      subject.name("prometheus") +
      subject.namespace("default"),
    ]),

  prometheus_config:
    $.util.configMap("prometheus-config") +
    configMap.data({
      "prometheus.yml": prometheusConfig,
      "alerts.rules": alertConfig,
      "recording.rules": recordingRules,
    }),

  prometheus_container::
    $.util.container("prometheus", $._images.prometheus) +
    $.util.containerPort("http", 80) +
    container.args([
      "-config.file=/etc/prometheus/prometheus.yml",
      "-web.listen-address=:80",
      "-alertmanager.url=http://alertmanager.default.svc.cluster.local/admin/alertmanager",
      "-web.external-url=https://localhost/admin/prometheus",
    ]),

  prometheus_watch_container::
    $.util.container("watch", $._images.watch) +
    container.args([
      "-v", "-t", "-p=/etc/prometheus",
      "curl", "-X", "POST", "--fail", "-o", "-", "-sS", "http://localhost:80/admin/prometheus/-/reload",
    ]),

  prometheus_deployment:
    $.util.deployment("prometheus", [
      $.prometheus_container,
      $.prometheus_watch_container,
    ]) +
    $.util.configVolumeMount(
      "prometheus-config",
      "/etc/prometheus",
    ) +
    deployment.mixin.spec.template.metadata.annotations({ "prometheus.io.path": "/admin/prometheus/metrics" }) +
    deployment.mixin.spec.template.spec.serviceAccount("prometheus"),

  prometheus_service:
    $.util.serviceFor($.prometheus_deployment),
}
