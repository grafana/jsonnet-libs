local k = import 'ksonnet-util/kausal.libsonnet';
{
  local configMap = k.core.v1.configMap,
  local page_html = (importstr 'files/page.html'),

  local links(apps) = std.lines([
    (importstr 'files/link.html') % app
    for app in apps
  ]),

  nginx_html_config_map:
    configMap.new('nginx-html')
    + configMap.withData({
      'index.html': page_html % {
        links: links($.apps),
        page_name: $._config.cluster_name,
      },
      'app.svg': (importstr 'files/app.svg'),
    } + {
      [app.key]: page_html % {
        links: links(app.children),
        page_name: '%s: %s' % [$._config.cluster_name, app.title],
      }
      for app in $.appsWithChildren
    }),
}
