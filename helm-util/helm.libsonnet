local d = import 'github.com/sh0rez/docsonnet/doc-util/main.libsonnet';
{
  local this = self,

  '#':: d.pkg(
    name='helm-util',
    url='github.com/grafana/jsonnet-libs/helm-util/helm.libsonnet',
    help='`helm-util` provides utilities for using helm in jsonnet',
  ),

  _calledFrom:: error 'new(std.thisFile) was not called',

  new(calledFrom):: self {
    _calledFrom: calledFrom,
  },

  // This common label is usually set to 'Helm', this is not true anymore.
  // You can override this with any value you choose.
  // https://helm.sh/docs/chart_best_practices/labels/#standard-labels
  defaultLabels:: { 'app.kubernetes.io/managed-by': 'Helmraiser' },

  '#template':: d.fn(
    |||
      `template` expands the Helm Chart to its underlying resources and returns them in an `Object`,
      so they can be consumed and modified from within Jsonnet.

      This functionality requires Helmraiser support in Jsonnet (e.g. using Grafana Tanka) and also
      the `helm` binary installed on your `$PATH`.
    |||,
    [
      d.arg('name', d.T.string),
      d.arg('chart', d.T.string),
      d.arg('conf', d.T.object),
    ]
  ),
  template(name, chart, conf={})::
    local cfg = conf { calledFrom: this._calledFrom };
    local chartData = std.native('helmTemplate')(name, chart, cfg);

    this.patchLabels(chartData, this.defaultLabels),

  '#patchKubernetesObjects':: d.fn(
    '`patchKubernetesObjects` finds all Kubernetes objects and patches them`',
    [
      d.arg('object', d.T.object),
      d.arg('patch', d.T.object),
    ]
  ),
  patchKubernetesObjects(object, patch)::
    if std.isObject(object)
    then
      // a Kubernetes object is characterized by having an apiVersion and Kind
      if std.objectHas(object, 'apiVersion') && std.objectHas(object, 'kind')
      then object + patch
      else
        std.mapWithKey(
          function(key, obj)
            this.patchKubernetesObjects(obj, patch),
          object
        )
    else if std.isArray(object)
    then
      std.map(
        function(obj)
          this.patchKubernetesObjects(obj, patch),
        object
      )
    else object,

  '#patchLabels':: d.fn(
    '`patchLabels` finds all Kubernetes objects and adds labels',
    [
      d.arg('object', d.T.object),
      d.arg('labels', d.T.object),
    ]
  ),
  patchLabels(object, labels={})::
    this.patchKubernetesObjects(
      object,
      {
        metadata+: {
          labels+: labels,
        },
      }
    ),
}
