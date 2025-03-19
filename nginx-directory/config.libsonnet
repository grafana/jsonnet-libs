{
  _config+:: {
    namespace: error 'namespace required',
    cluster_dns_suffix: error 'cluster_dns_suffix required',
    // log_format is enclosed in single quotes in the config file. Make sure to escape them properly if you want to use them.
    log_format: '$remote_addr - $remote_user [$time_local]  $status "$request" $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"',
    title: 'Admin',

    admin_services+: [
      // an entry should look like this:
      //  {
      //    # Required
      //    title: 'Prometheus',
      //    path: 'prometheus',
      //    url: 'http://prometheus.default.svc.cluster.local./prometheus/',
      //
      //    # Optional
      //    params: '',
      //    read_timeout: '60',
      //    send_timeout: '60',
      //    redirect: false,
      //    allowWebsockets: false,
      //    subfilter: false,
      //    custom: [],
      //  },
    ],


    // Backwards compatible options

    oauth_enabled: false,
    // Nginx proxy_read_timeout (in seconds) 60s is the nginx default
    nginx_proxy_read_timeout: '60',
    // Nginx proxy_send_timeout (in seconds) 60s is the nginx default
    nginx_proxy_send_timeout: '60',

    // If true, the entries will be sorted by title
    nginx_directory_sorted: false,
  },

  _images+:: {
    nginx: 'nginx:1.15.1-alpine',
  },
}
