local k = import 'k.libsonnet';
local configMap = k.core.v1.configMap;
{

  nginx_html_config_map:
    local vars = {
      link_stanzas: [
        (importstr 'files/link.html') % ({ params: '' } + service)
        for service in $._config.admin_services
      ],
      links: std.join('\n', self.link_stanzas),
    };

    configMap.new('nginx-config-html') +
    configMap.withData({
      'index.html': (importstr 'files/index.html') % vars,
    }),
}
