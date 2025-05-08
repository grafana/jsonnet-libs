local d = import 'github.com/jsonnet-libs/docsonnet/doc-util/main.libsonnet';
{
  local this = self,

  '#isKubernetesObject':: d.fn(
    |||
      `isKubernetesObject` determines whether `object` is a Kubernetes object.

      Note: this is characterized by being an object with `apiVersion` and `kind` fields.
    |||,
    [d.arg('object', d.T.any)]
  ),
  isKubernetesObject(object)::
    std.isObject(object)
    && std.objectHas(object, 'apiVersion')
    && std.objectHas(object, 'kind'),

  '#findKubernetesObjects':: d.fn(
    '`findKubernetesObjects` returns an array of all Kubernetes objects it finds in `object`',
    [d.arg('object', d.T.any)]
  ),
  findKubernetesObjects(object, kind=null, name=null)::
    // Find Kubernetes objects by descending recursively.
    if self.isKubernetesObject(object) then
      // Stop descending immediately, and check whether this object meets the
      // kind and name filters, if provided.
      if
        (kind == null || object.kind == kind)
        && (name == null || object.metadata.name == name)
      then
        [object]
      else []

    else if std.isObject(object) then
      // Recurse into the object's values, flattening the returned arrays into one.
      std.flatMap(
        function(v) self.findKubernetesObjects(v, kind, name),
        std.objectValues(object)
      )

    else if std.isArray(object) then
      // Recurse into the array's elements, flattening the returned arrays into one.
      std.flatMap(
        function(v) self.findKubernetesObjects(v, kind, name),
        object
      )

    else [],

  '#patchKubernetesObjects':: d.fn(
    '`patchKubernetesObjects` applies `patch` to all Kubernetes objects it finds in `object`.',
    [
      d.arg('object', d.T.object),
      d.arg('patch', d.T.object),
    ]
  ),
  patchKubernetesObjects(object, patch, kind=null, name=null)::
    if std.isObject(object)
    then
      if self.isKubernetesObject(object)
         && (kind == null || object.kind == kind)
         && (name == null || object.metadata.name == name)
      then object + patch
      else
        std.mapWithKey(
          function(key, obj)
            this.patchKubernetesObjects(obj, patch, kind, name),
          object
        )
    else if std.isArray(object)
    then
      std.map(
        function(obj)
          this.patchKubernetesObjects(obj, patch, kind, name),
        object
      )
    else object,

  '#patchLabels':: d.fn(
    '`patchLabels` finds all Kubernetes objects and adds labels to them.',
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
