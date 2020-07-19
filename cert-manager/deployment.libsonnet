{
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,

  cert_manager_container::
    container.new('cert-manager', $._images.cert_manager) +
    container.withPorts(containerPort.new(name='cert-manager', port=9402)) +
    container.withImagePullPolicy('IfNotPresent') +
    container.withArgs(
      [
        '--v=2',  // loglevel
        '--cluster-resource-namespace=$(POD_NAMESPACE)',  // optionally customizable
        '--leader-election-namespace=kube-system',  // optionally customizable
        //'--default-issuer-name=', // unset by default
        //'--default-issuer-kind=', // unset by default
        //'--default-issuer-group=', // unset by default
        '--webhook-namespace=$(POD_NAMESPACE)',
        '--webhook-ca-secret=cert-manager-webhook-ca',
        '--webhook-serving-secret=cert-manager-webhook-tls',
        std.format('--webhook-dns-names=cert-manager-webhook,cert-manager-webhook.%(ns)s,cert-manager-webhook.%(ns)s.svc', { ns: $._config.namespace }),
        '--default-issuer-kind=ClusterIssuer',
      ] +
      (if $._config.default_issuer != null then ['--default-issuer-name=' + $._config.default_issuer] else []) +
      (if $._config.default_issuer_group != null then ['--default-issuer-group=' + $._config.default_issuer_group] else [])
    ) +

    container.withEnv([
      $.core.v1.envVar.fromFieldPath('POD_NAMESPACE', 'metadata.namespace'),
    ]),

  deployment:
    deployment.new(name='cert-manager', replicas=1, containers=[$.cert_manager_container], podLabels={
      app: 'controller',
      /* TODO: labels */
    },) +
    deployment.spec.template.spec.withServiceAccountName('cert-manager'),
}
