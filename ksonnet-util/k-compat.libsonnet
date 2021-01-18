local k = import 'k.libsonnet';

k
+ (
  if std.trace(
    'Deprecated: ksonnet-lib is deprecated, please consider using https://github.com/jsonnet-libs/k8s-alpha.',
    std.objectHas(k, '__ksonnet')
  )
  then
    (import 'legacy-types.libsonnet')
    + (import 'legacy-custom.libsonnet')
    + (import 'legacy-noname.libsonnet')({
      new(name=''):: super.new() + (if name != '' then super.mixin.metadata.withName(name) else {}),
    })
  else
    (import 'legacy-subtypes.libsonnet')
    + (import 'legacy-noname.libsonnet')({
      new(name=''):: super.new(name),
    })
)
