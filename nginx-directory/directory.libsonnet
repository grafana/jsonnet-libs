local config = import 'config.libsonnet';
local configfile = import 'configfile.libsonnet';
local deployment = import 'deployment.libsonnet';
local html = import 'html.libsonnet';

config + configfile + html + deployment {

  addApp(key, title, path, url):: {
    apps_map+:: {
      [key]: {
        key: key,
        title: title,
        path: path,
        params: '',
        url: url,
        icon: 'app.svg',
        children_map:: {},
        children_order:: [],
        children: $._flattenMap(self.children_map, self.children_order),
      },
    },
    app_order+:: [key],
  },

  _makeKey(app):: if std.objectHas(app, 'key') then app.key
  else std.strReplace(std.stripChars(app.path, '/'), '/', '_'),  // strip initial slash, replace rest with underscore

  _makeMap(appList):: {
    [$._makeKey(app)]: {
      key: $._makeKey(app),
      title: app.title,
      path: '/' + app.path,
      params: if std.objectHas(app, 'params') then app.params else '',
      icon: if std.objectHas(app, 'icon') then app.icon else '',
      url: app.url,
      children_map:: if std.objectHas(app, 'children') then $._makeMap(app.children) else {},
      children_order:: if std.objectHas(app, 'children') then [$._makeKey(child) for child in app.children] else [],
      children: $._flattenMap(self.children_map, self.children_order),
    }
    for app in appList
  },

  withLegacyConfigs(admin_services):: {
    apps_map+:: $._makeMap(admin_services),
    app_order+:: std.objectFields($._makeMap(admin_services)),
  },

  withParams(params):: {
    params: params,
  },

  withWebsockets():: {
    allowWebsockets: true,
  },

  withIcon(icon):: {
    icon: icon,
  },

  withChildren(children):: {
    children+: children,
  },

  _flattenMap(map, order):: [map[key] for key in order],

  apps:: $._flattenMap($.apps_map, $.app_order),
  appsWithChildren:: std.filter(function(app) std.length(app.children) > 0, $.apps),
  appsWithoutChildren:: std.filter(function(app) std.length(app.children) == 0, $.apps),
  appChildren:: std.flattenArrays(std.map(function(app) app.children, $.appsWithChildren)),
}
