local generated = import 'generated.libsonnet';

{
  local configured = (generated { _config+:: $._config }),

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

  local templated = (import 'templated.libsonnet') { _config+:: $._config },
  crds: templated.configureHelmChart(importstr 'files/00-crds.yaml'),

  cainjector: std.mapWithKey(
    function(key, obj)
      patch_labels(obj, 'cainjector', 'cert-manager-cainjector'),
    {
      cainjector_deployment: configured.cainjector_deployment,
      cainjector_psp_clusterrolebinding: configured.cainjector_psp_clusterrolebinding,
      cainjector_psp_clusterrole: configured.cainjector_psp_clusterrole,
      cainjector_psp: configured.cainjector_psp,
      cainjector_rbac: configured.cainjector_rbac,
      cainjector_serviceaccount: configured.cainjector_serviceaccount,
    }
  ),

  controller: std.mapWithKey(
    function(key, obj)
      patch_labels(obj, 'controller', 'cert-manager'),
    {
      deployment: configured.deployment,
      psp: configured.psp,
      psp_clusterrole: configured.psp_clusterrole,
      psp_clusterrolebinding: configured.psp_clusterrolebinding,
      rbac: configured.rbac,
      service: configured.service,
      serviceaccount: configured.serviceaccount,
    }
  ),

  webhook: std.mapWithKey(
    function(key, obj)
      patch_labels(obj, 'webhook', 'cert-manager-webhook'),
    {
      webhook_deployment: configured.webhook_deployment,
      webhook_mutating_webhook: configured.webhook_mutating_webhook,
      webhook_psp_clusterrolebinding: configured.webhook_psp_clusterrolebinding,
      webhook_psp_clusterrole: configured.webhook_psp_clusterrole,
      webhook_psp: configured.webhook_psp,
      webhook_rbac: configured.webhook_rbac,
      webhook_serviceaccount: configured.webhook_serviceaccount,
      webhook_service: configured.webhook_service,
      webhook_validating_webhook: configured.webhook_validating_webhook,
    }
  ),
}
