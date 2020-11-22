{
  local container = $.core.v1.container,

  nginx_container::
    container.new('nginx', $._images.nginx) +
    container.withPorts($.core.v1.containerPort.new('http', 80)) +
    $.util.resourcesRequests('50m', '100Mi'),

  local deployment = $.apps.v1.deployment,

  nginx_deployment:
    deployment.new('nginx', 1, [$.nginx_container]) +
    $.util.configMapVolumeMount($.nginx_config_map, '/etc/nginx') +
    $.util.configMapVolumeMount($.nginx_html, '/var/www/html') +
    $.util.podPriority('critical'),

  nginx_service:
    $.util.serviceFor($.nginx_deployment),

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
