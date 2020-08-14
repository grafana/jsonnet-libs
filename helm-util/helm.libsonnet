local d = import 'github.com/sh0rez/docsonnet/doc-util';
{
  local this = self,

  '#': d.pkg(
    name='helm-util',
    url='github.com/grafana/jsonnet-libs/helm-util/helm.libsonnet',
    help='`helm-util` provides utilities for using helm in jsonnet',
  ),

  '#helmTemplate': d.fn(
    '`helmTemplate` wraps the helmTemplate native function and returns a rendered chart as a map of kubernetes manifests',
    [
      d.arg('name', d.T.string),
      d.arg('chart', d.T.string),
      d.arg('conf', d.T.object),
      d.arg('labels', d.T.object),
    ]
  ),
  helmTemplate(name, chart, conf={}, labels={})::
    this.patchLabels(
      std.native('helmTemplate')(name, chart, conf),
      labels { 'app.kubernetes.io/managed-by': 'Helmraiser' }
    ),

  '#patchLabels': d.fn(
    '`patchLabels` iterates over all objects and adds labels if the object has `metadata`',
    [
      d.arg('object', d.T.object),
      d.arg('labels', d.T.object),
    ]
  ),
  patchLabels(object, labels={})::
    if std.isObject(object)
    then
      if std.objectHas(object, 'metadata')
      then
        object {
          metadata+: {
            labels+: labels,
          },
        }
      else
        std.mapWithKey(
          function(key, obj)
            this.patchLabels(obj, labels),
          object
        )
    else if std.isArray(object)
    then
      std.map(
        function(obj)
          this.patchLabels(obj, labels),
        object
      )
    else object,
}
