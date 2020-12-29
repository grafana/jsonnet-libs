local images = import 'images.libsonnet';
{
  step(name, commands, image=images._images.runner, settings={}):: {
    name: name,
    commands: commands,
    image: image,
    settings: settings,
  },

  withStep(step):: {
    steps+: [step],
  },

  withInlineStep(name, commands, image=images._images.runner, settings={}, environment={}):: $.withStep($.step(name, commands, image, settings) + environment),

  pipeline(name, steps=[]):: {
    kind: 'pipeline',
    type: 'docker',
    name: name,
    steps: steps,
  },
}
