local api = import 'api.libsonnet';
local legacy = import 'legacy.libsonnet';

{
  v1: api.v1 {
    patchRule(group, rule, patch)::
      if 'groups_map' in super
      then super.patchRule(group, rule, patch)
      else legacy.v1.patchRule(group, rule, patch),

    legacy: legacy.v1,
  },
}
