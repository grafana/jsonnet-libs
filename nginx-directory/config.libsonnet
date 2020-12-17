{
  _config+:: {
    // oauth2-proxy
    oauth_enabled: false,

    // Nginx proxy_read_timeout (in seconds) 60s is the nginx default
    nginx_proxy_read_timeout: '60',
    // Nginx proxy_send_timeout (in seconds) 60s is the nginx default
    nginx_proxy_send_timeout: '60',

    namespace: error 'namespace required',
    cluster_dns_suffix: error 'cluster_dns_suffix required',
  },
}
