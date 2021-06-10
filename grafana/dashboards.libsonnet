{
  folderID(folder)::
    local lower = std.asciiLower(folder);
    local underscore = std.strReplace(lower, '_', '-');
    local space = std.strReplace(underscore, ' ', '-');
    space,

  local folderID(folder) = self.folderID(folder),

  // It's super common for the dashboards in a single folder to be too
  // large to fit inside a single Kubernetes ConfigMap. We can specify
  // how many ConfigMaps to use for a folder (aka how many shards).

  // add a new empty folder and set config map shard size
  addFolder(name, shards=1):: {
    grafanaDashboardFolders+:: {
      [name]: {
        id: folderID(name),
        name: name,
        shards: shards,
        dashboards: {},
      },
    },
  },

  // add a new dashboard, creating the folder if necessary
  addDashboard(name, dashboard, folder=''):: {
    local hasShards = std.objectHas(super.grafanaDashboardFolders, folder) && std.objectHas(super.grafanaDashboardFolders[folder], 'shards'),
    grafanaDashboardFolders+:: {
      [folder]+: {
        id: folderID(folder),
        name: folder,
        [if !hasShards then 'shards']: 1,
        dashboards+: {
          [name]+: dashboard,
        },
      },
    },
  },

  addMixinDashboards(mixins, mixinProto={}):: {
    local generalShards = super.grafanaGeneralFolderShards,
    local grafanaDashboards = super.grafanaDashboards,
    grafanaDashboardFolders+:: std.foldr(
      function(name, acc)
        acc
        + (
          if std.objectHasAll(mixins[name], 'grafanaDashboards')
             && std.length(mixins[name].grafanaDashboards) > 0
          then
            local key = (
              if std.objectHasAll(mixins[name], 'grafanaDashboardFolder')
              then $.folderID(mixins[name].grafanaDashboardFolder)
              else 'general'
            );
            {
              [key]+: {
                dashboards+: (mixins[name] + mixinProto).grafanaDashboards,
                shards:
                  if std.objectHasAll(mixins[name], 'grafanaDashboardShards')
                  then mixins[name].grafanaDashboardShards
                  else 1,
                name:
                  if std.objectHasAll(mixins[name], 'grafanaDashboardFolder')
                  then mixins[name].grafanaDashboardFolder
                  else '',
                id: $.folderID(self.name),
              },
            }
          else {}
        ),
      std.objectFields(mixins),
      {}
    ) + {
      general+: {
        shards: generalShards,
        dashboards+: grafanaDashboards + mixinProto,
        name: '',
        id: '',
      },
    },
  },

  withGeneralFolderShards(shards):: {
    grafanaGeneralFolderShards: shards,
  },

  grafanaGeneralFolderShards:: 1,
  grafanaDashboardFolders+:: {},
}
