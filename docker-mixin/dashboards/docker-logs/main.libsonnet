local variables = import 'variables.libsonnet';
local targets = import 'targets.libsonnet';
local panels = import 'panels.libsonnet';
local dashboards = import 'dashboards.libsonnet';

{
  // note, some of these functions don't use their `config` parameter. However,
  // we still provide it so as to have a consistent interface.
  variables(config): variables,
  targets(config):  targets,
  panels(config): panels(targets),
  dashboards(config): dashboards(config, variables, panels(targets)),
}