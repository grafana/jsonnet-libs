local k = import "kausal.libsonnet";

k {
  local configMap = $.core.v1.configMap,

  nginx_config_map:
    configMap.new("nginx-config") +
    configMap.withData({
      "nginx.conf": |||
        worker_processes     5;  ## Default: 1
        error_log            /dev/stderr;
        pid                  nginx.pid;
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
          resolver     kube-dns.kube-system.svc.cluster.local;
          server {
            listen 80;
            location ~ ^/prometheus(/?)(.*)$ {
              proxy_pass      http://prometheus.%(namespace)s.svc.cluster.local/prometheus/$2$is_args$args;
            }
            location ~ /alertmanager(/?)(.*)$ {
              proxy_pass      http://alertmanager.%(namespace)s.svc.cluster.local/alertmanager/$2$is_args$args;
            }
            location ~ ^/grafana(/?)(.*)$ {
              proxy_pass      http://grafana.%(namespace)s.svc.cluster.local/$2$is_args$args;
            }
            location ~ /(index.html)? {
              root /etc/nginx;
            }
          }
        }
      ||| % $._config,
      "index.html": |||
        <html>
          <head><title>Admin</title></head>
          <body>
            <h1>Admin</h1>
            <ul>
              <li><a href="/prometheus">Prometheus</a></li>
              <li><a href="/alertmanager">Alertmanager</a></li>
              <li><a href="/grafana">Grafana</a></li>
            </ul>
          </body>
        </html>
      |||
    }),

  local container = $.core.v1.container,

  nginx_container::
    container.new("nginx", $._images.nginx) +
    container.withPorts($.core.v1.containerPort.new("http", 80)) +
    $.util.resourcesRequests("50m", "100Mi"),

  local deployment = $.apps.v1beta1.deployment,

  nginx_deployment:
    deployment.new("nginx", 1, [$.nginx_container]) +
    $.util.configVolumeMount("nginx-config", "/etc/nginx"),

  nginx_service:
    $.util.serviceFor($.nginx_deployment),
}
