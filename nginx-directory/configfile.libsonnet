local k = import 'ksonnet-util/kausal.libsonnet';

{
  local buildHeaders(service, redirect, allowWebsockets, subfilter) =
    if redirect then |||
      return 302 %(url)s;
    ||| % service

    else |||
           proxy_pass      %(url)s$1$is_args$args;
           proxy_set_header    Host $host;
           proxy_set_header    X-Real-IP $remote_addr;
           proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header    X-Forwarded-Proto $scheme;
           proxy_set_header    X-Forwarded-Host $http_host;
           proxy_read_timeout  %(nginx_proxy_read_timeout)s;
           proxy_send_timeout  %(nginx_proxy_send_timeout)s;
         ||| % (service + $._config)

         + if allowWebsockets then |||
           # Allow websocket connections https://www.nginx.com/blog/websocket-nginx/
           proxy_set_header    Upgrade $http_upgrade;
           proxy_set_header    Connection "Upgrade";
         |||
         else ''

              + if subfilter then |||
                sub_filter 'href="/' 'href="/%(path)s/';
                sub_filter 'src="/' 'src="/%(path)s/';
                sub_filter 'endpoint:"/' 'endpoint:"/%(path)s/';  # for XHRs.
                sub_filter 'href:"/v1/' 'href:"/%(path)s/v1/';
                sub_filter_once off;
                sub_filter_types text/css application/xml application/json application/javascript;
                proxy_redirect   "/" "/%(path)s/";
              ||| % service
              else '',

  local buildLocation(service) =
    |||
      location ~ ^%(path)s(.*)$ {
    ||| % service +
    buildHeaders(
      service,
      if 'redirect' in service then service.redirect else false,
      if 'allowWebsockets' in service then service.allowWebsockets else false,
      if 'subfilter' in service then service.subfilter else false,
    ) +
    |||
      }
    |||,

  local configMap = k.core.v1.configMap,

  nginx_config_map:
    local variables = {
      locations: std.lines([
        buildLocation(service)
        for service in std.set($.appsWithoutChildren + $.appChildren, function(s) s.url)
      ]),
    };

    configMap.new('nginx-config') +
    configMap.withData({
      'nginx.conf': (importstr 'files/nginx.conf') % ($._config + variables),
    }),
}
