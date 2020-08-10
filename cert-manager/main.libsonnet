{
  local generated =
    std.native('helmTemplate')(
      'cert-manager',
      'jetstack/cert-manager',
      {
        values: {
          installCRDs: true,
          global: {
            podSecurityPolicy: {
              enabled: true,
              useAppArmor: false,
            },
          },
        },
        flags: [
          '--version=v0.13.0',
          '--namespace=%s' % $._config.namespace,
        ],
      }
    ),

  local patch_labels(o, app, name) =
    local selectors = {
      // manual generated lib used these selectors
      // keeping these minimizes impact on production
      app: app,
      name: name,
    };
    local labels = selectors {
      'app.kubernetes.io/managed-by': 'Helmraiser',
    };
    if std.isObject(o)
    then
      if std.objectHas(o, 'kind')
      then
        local t = std.asciiLower(o.kind);
        if t == 'deployment' then
          o {
            metadata+: {
              labels+: labels,
            },
            spec+: {
              selector: {
                matchLabels: selectors,
              },
              template+: {
                metadata+: {
                  labels: selectors,
                },
              },
            },
          }
        else if t == 'service' then
          o {
            metadata+: {
              labels+: labels,
            },
            spec+: {
              selector: selectors,
            },
          }
        else
          o {
            metadata+: {
              labels+: labels,
            },
          }
      else
        std.mapWithKey(
          function(key, obj)
            patch_labels(obj, app, name),
          o
        )
    else if std.isArray(o)
    then
      std.map(
        function(obj)
          patch_labels(obj, app, name),
        o
      )
    else o
  ,

  labeled: std.mapWithKey(
    function(key, obj)
      if std.length(std.findSubstr('cainjector', key)) > 0
      then patch_labels(obj, 'cainjector', 'cert-manager-cainjector')
      else if std.length(std.findSubstr('webhook', key)) > 0
      then patch_labels(obj, 'webhook', 'cert-manager-webhook')
      else patch_labels(obj, 'controller', 'cert-manager')
    ,
    generated
  ),

  crds: std.native('parseYaml')(importstr 'files/00-crds.yaml'),
}
