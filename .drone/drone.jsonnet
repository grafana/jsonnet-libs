local triggers = import 'lib/drone/triggers.libsonnet';
local pipeline = (import 'lib/drone/drone.libsonnet').pipeline;
local withInlineStep = (import 'lib/drone/drone.libsonnet').withInlineStep;

[
  pipeline('ci')
  + withInlineStep('lint', ['make lint'], image='grafana/jsonnet-build:7f1cb84')
  + triggers.master
  + triggers.pr,
]
