local k = import 'k.libsonnet';
local configMap = k.core.v1.configMap;
{
  isHidden(service)::
    std.objectHas(service, 'hidden') && service.hidden == true,

  nginx_html_config_map:
    local vars = {
      link_stanzas: [
        // adding a "hidden" field set to true will cause the link to not be rendered in HTML

        if !$.isHidden(service) then (importstr 'files/link.html') % ({ params: '' } + service) else null
        for service in $._config.admin_services
      ],
      links: std.join('\n', self.link_stanzas),
    };

    configMap.new('nginx-config-html') +
    configMap.withData({
      'index.html': (importstr 'files/index.html') % vars,
    }),
}
