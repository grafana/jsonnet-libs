local k = import 'ksonnet-util/kausal.libsonnet';
{
  local container = k.core.v1.container,

  nginx_container::
    container.new('nginx', $._images.nginx)
    + container.withPorts(k.core.v1.containerPort.new('http', 80))
    + k.util.resourcesRequests('50m', '100Mi'),

  local deployment = k.apps.v1.deployment,

  nginx_deployment:
    deployment.new('nginx', 1, [$.nginx_container])
    + k.util.configMapVolumeMount($.nginx_config_map, '/etc/nginx/nginx.conf', k.core.v1.volumeMount.withSubPath('nginx.conf'))
    + k.util.configMapVolumeMount($.nginx_html_config_map, '/var/www/html')
    + k.util.podPriority('critical'),

  nginx_service:
    k.util.serviceFor($.nginx_deployment),

  local oauth2_proxy = import 'oauth2_proxy/oauth2-proxy.libsonnet',

  oauth2_proxy:
    if !($._config.oauth_enabled)
    then {}
    else oauth2_proxy {
      _config+:: $._config {
        oauth_upstream: 'http://nginx.%(namespace)s.svc.%(cluster_dns_suffix)s/' % $._config,
      },
    },
}
