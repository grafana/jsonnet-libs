{
  oauth2_proxy_secret:
    $.core.v1.secret.new('oauth2-proxy', {
      OAUTH2_PROXY_COOKIE_SECRET: std.base64($._config.cookie_secret),
      OAUTH2_PROXY_CLIENT_SECRET: std.base64($._config.client_secret),
      OAUTH2_PROXY_CLIENT_ID: std.base64($._config.client_id),
    }),


  local container = $.core.v1.container,
  oauth2_proxy_container::
    container.new('oauth2-proxy', $._images.oauth2_proxy) +
    container.withPorts($.core.v1.containerPort.new('http', 80)) +
    container.withArgs([
      '-http-address=0.0.0.0:80',
      '-redirect-url=%s' % $._config.redirect_url,
      '-upstream=%s' % $._config.upstream,
      '-email-domain=%s' % $._config.email_domain,
      '-pass-basic-auth=%s' % $._config.pass_basic_auth,
    ]) +
    container.withEnvFromSecret('oauth2-proxy'),


  local deployment = $.apps.v1beta1.deployment,
  oauth2_proxy_deployment:
    deployment.new('oauth2-proxy', 1, [$.oauth2_proxy_container]),

  oauth2_proxy_service:
    $.util.serviceFor($.oauth2_proxy_deployment),
}
