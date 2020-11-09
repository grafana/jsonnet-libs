{
  apps_map: {},
  app_order:: [],

  _config+:: {
    cluster_name: error 'cluster_name required',

    // oauth2-proxy
    oauth_enabled: false,

    // Nginx proxy_read_timeout (in seconds) 60s is the nginx default
    nginx_proxy_read_timeout: '60',
    // Nginx proxy_send_timeout (in seconds) 60s is the nginx default
    nginx_proxy_send_timeout: '60',
  },

  _images+:: {
    nginx: 'nginx:1.15.1-alpine',
  },
}
