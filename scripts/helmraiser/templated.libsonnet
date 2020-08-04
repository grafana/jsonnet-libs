{
  _config+:: {
    name: error 'must provide name',
    namespace: error 'must provide namespace',
    chartPrefix: error 'must provide chartPrefix',
  },

  lowercaseFirstChar(s)::
    std.asciiLower(s[0]) + std.substr(s, 1, std.length(s)),

  replaceDash(s)::
    std.strReplace(s, '-', '_'),

  // appendKind is adding a kubernetes object `o` into a hierachy of manifests
  // `m` within the the tree `<kind>.<metadata.name>`. For CRDs it will turn
  // around this to group them into a `customResourceDefinition` object, so all
  // crds can be easily disabled or modified.
  appendKind(m, o)::
    if o == null then
      m
    else
      local kind = $.lowercaseFirstChar(o.kind);
      local name =
        $.replaceDash(
          $.replaceHelmVariables(
            o.metadata.name
          )
        );
      if kind == 'customResourceDefinition' then
        m {
          [kind]+: {
            [name]+: o,
          },
        }
      else
        m {
          [name]+: {
            [kind]+: o,
          },
        }
  ,

  replaceHelmVariablesKey(s)::
    std.strReplace(
      s,
      'XX_HELM_RELEASE_XX-%s-' % $._config.chartPrefix,
      '',
    ),

  replaceHelmVariablesString(s)::
    std.strReplace(
      std.strReplace(
        std.strReplace(
          s,
          'XX_HELM_NAMESPACE_XX',
          $._config.namespace
        ),
        'XX_HELM_RELEASE_XX-%s' % $._config.chartPrefix,
        $._config.name
      ),
      'XX_HELM_RELEASE_XX',
      $._config.name,
    ),

  replaceHelmVariables(obj)::
    if std.type(obj) == 'object' then
      {
        [$.replaceHelmVariablesKey(key)]: $.replaceHelmVariables(obj[key])
        for key in std.objectFields(obj)
      }
    else if std.type(obj) == 'array' then
      std.map(function(x) $.replaceHelmVariables(x), obj)
    else if std.type(obj) == 'string' then
      $.replaceHelmVariablesString(obj)
    else
      obj,

  configureHelmChart(yaml)::
    std.prune(
      $.replaceHelmVariables(
        std.foldl(
          $.appendKind,
          std.native('parseYaml')(yaml),
          {}
        )
      )
    ),
}
