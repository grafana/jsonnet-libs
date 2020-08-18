local helm = import 'github.com/grafana/jsonnet-libs/helm-util/helm.libsonnet';
{
  values:: {
    installCRDs: true,
    global: {
      podSecurityPolicy: {
        enabled: true,
        useAppArmor: false,
      },
    },
  },

  local generated =
    helm.template(
      'cert-manager',
      'jetstack/cert-manager',
      {
        values: $.values,
        flags: [
          '--version=%s' % $._config.version,
          '--namespace=%s' % $._config.namespace,
        ],
      }
    ),

  local patch_labels(o, app, name) =
    local labels = {
      // manual generated lib used these labels as selectors
      // keeping these minimizes impact on production
      app: app,
      name: name,
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
                matchLabels: labels,
              },
              template+: {
                metadata+: {
                  labels: labels,
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
              selector: labels,
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
      else
        if std.length(std.findSubstr('webhook', key)) > 0
        then patch_labels(obj, 'webhook', 'cert-manager-webhook')
        else patch_labels(obj, 'controller', 'cert-manager')
    ,
    generated
  ),

  crds:
    if $._config.custom_crds
    then std.native('parseYaml')(importstr 'files/00-crds.yaml')
    else {},
} + {
  local _containers = super.labeled.cert_manager_deployment.spec.template.spec.containers,
  labeled+: {
    cert_manager_deployment+: {
      spec+: {
        template+: {
          spec+: {
            containers: [
              _container {
                ports: [
                  {
                    containerPort: 9402,
                    protocol: 'TCP',
                    name: 'http-metrics',
                  },
                ],
              }
              for _container in _containers
            ],
          },
        },
      },
    },
  },
}
