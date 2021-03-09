local kausal = import 'ksonnet-util/kausal.libsonnet';
{
  local _config = self._config,
  local k = kausal { _config+:: _config },

  local buildHeaders(service, redirect, allowWebsockets, subfilter, custom) =
    (if std.length(custom) > 0 then std.join('\n', custom) + '\n' else '')
    + if redirect then |||
      return 302 %(url)s;
    ||| % service else |||
      proxy_pass      %(url)s$2$is_args$args;
      proxy_set_header    Host $host;
      proxy_set_header    X-Real-IP $remote_addr;
      proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header    X-Forwarded-Proto $scheme;
      proxy_set_header    X-Forwarded-Host $http_host;
      proxy_read_timeout  %(nginx_proxy_read_timeout)s;
      proxy_send_timeout  %(nginx_proxy_send_timeout)s;
    ||| % (service + $._config) + if allowWebsockets then |||
      # Allow websocket connections https://www.nginx.com/blog/websocket-nginx/
      proxy_set_header    Upgrade $http_upgrade;
      proxy_set_header    Connection "Upgrade";
    ||| else '' + if subfilter then |||
      sub_filter 'href="/' 'href="/%(path)s/';
      sub_filter 'src="/' 'src="/%(path)s/';
      sub_filter 'action="/' 'action="/%(path)s/';
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
      if 'redirect' in service then service.redirect else false,
      if 'allowWebsockets' in service then service.allowWebsockets else false,
      if 'subfilter' in service then service.subfilter else false,
      if 'custom' in service then service.custom else [],
    ) +
    |||
      }
    |||,

  local configMap = k.core.v1.configMap,

  nginx_config_map:
    local vars = {
      location_stanzas: [
        buildLocation(service)
        for service in std.uniq($.servicesByWeight($._config.admin_services), function(s) s.url)
      ],
      locations: std.join('\n', self.location_stanzas),
    };

    configMap.new('nginx-config') +
    configMap.withData({
      'nginx.conf': (importstr 'files/nginx.conf') % ($._config + vars),
    }),

  servicesByWeight(services)::
    std.sort(services, function(s) if std.objectHas(s, 'weight') then s.weight else 0),
}
