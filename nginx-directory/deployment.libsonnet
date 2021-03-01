local kausal = import 'ksonnet-util/kausal.libsonnet';
{
  local _config = self._config,
  local k = kausal { _config+:: _config },
  local container = k.core.v1.container,

  nginx_container::
    container.new('nginx', $._images.nginx) +
    container.withPorts($.core.v1.containerPort.new('http', 80)) +
    k.util.resourcesRequests('50m', '100Mi'),

  local deployment = $.apps.v1.deployment,

  nginx_deployment:
    deployment.new('nginx', 1, [$.nginx_container]) +
    k.util.configMapVolumeMount($.nginx_config_map, '/etc/nginx') +
    k.util.configMapVolumeMount($.nginx_html_config_map, '/var/www/html') +
    k.util.podPriority('critical'),

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
