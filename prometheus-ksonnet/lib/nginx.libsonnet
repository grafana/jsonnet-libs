{
  local buildHeaders(service, allowWebsockets, subfilter) =
    |||
      proxy_pass      %(url)s$2$is_args$args;
      proxy_set_header    Host $host;
      proxy_set_header    X-Real-IP $remote_addr;
      proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header    X-Forwarded-Proto $scheme;
      proxy_set_header    X-Forwarded-Host $http_host;
    ||| % service + if allowWebsockets then |||
      # Allow websocket connections https://www.nginx.com/blog/websocket-nginx/
      proxy_set_header    Upgrade $http_upgrade;
      proxy_set_header    Connection "Upgrade";
    ||| else '' + if subfilter then |||
      sub_filter 'href="/' 'href="/%(path)s/';
      sub_filter 'src="/' 'src="/%(path)s/';
      sub_filter 'endpoint:"/' 'endpoint:"/%(path)s/';  # for XHRs.
      sub_filter 'href:"/v1/' 'href:"/%(path)s/v1/';
      sub_filter_once off;
      sub_filter_types text/css application/xml application/json application/javascript;
      proxy_redirect   "/" "/%(path)s/";
    ||| % service else '',

  local buildLocation(service) =
    |||
      location ~ ^/%(path)s(/?)(.*)$ {
    ||| % service +
              buildHeaders(
                service,
                if 'allowWebsockets' in service then service.allowWebsockets else false,
                if 'subfilter' in service then service.subfilter else false,
              ) +
    |||
      }
    |||,

  local configMap = $.core.v1.configMap,

  nginx_config_map:
    local vars = {
      location_stanzas: [
        buildLocation(service)
        for service in $._config.admin_services
      ],
      locations: std.join('\n', self.location_stanzas),
      link_stanzas: [
        |||
          <li><a href="/%(path)s">%(title)s</a></li>
        ||| % service
        for service in $._config.admin_services
      ],
      links: std.join('\n', self.link_stanzas),
    };

    configMap.new('nginx-config') +
    configMap.withData({
      'nginx.conf': |||
        worker_processes     5;  ## Default: 1
        error_log            /dev/stderr;
        pid                  /tmp/nginx.pid;
        worker_rlimit_nofile 8192;

        events {
          worker_connections  4096;  ## Default: 1024
        }

        http {
          default_type application/octet-stream;
          log_format   main '$remote_addr - $remote_user [$time_local]  $status '
            '"$request" $body_bytes_sent "$http_referer" '
            '"$http_user_agent" "$http_x_forwarded_for"';
          access_log   /dev/stderr  main;
          sendfile     on;
          tcp_nopush   on;
          resolver     kube-dns.kube-system.svc.%(cluster_dns_suffix)s;
          server {
            listen 80;
            %(locations)s
            location ~ /(index.html)? {
              root /etc/nginx;
            }
          }
        }
      ||| % ($._config + vars),
      'index.html': |||
        <html>
          <head><title>Admin</title></head>
          <body>
            <h1>Admin</h1>
            <ul>
              %(links)s
            </ul>
          </body>
        </html>
      ||| % vars,
    }),

  local container = $.core.v1.container,

  nginx_container::
    container.new('nginx', $._images.nginx) +
    container.withPorts($.core.v1.containerPort.new('http', 80)) +
    $.util.resourcesRequests('50m', '100Mi'),

  local deployment = $.apps.v1beta1.deployment,

  nginx_deployment:
    deployment.new('nginx', 1, [$.nginx_container]) +
    $.util.configVolumeMount('nginx-config', '/etc/nginx') +
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
