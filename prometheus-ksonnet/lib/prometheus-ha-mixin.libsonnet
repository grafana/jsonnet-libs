(import 'prometheus/ha-mixin.libsonnet') +
{

  name:: error 'must specify name',
  local name = self.name,

  _config+:: $._config { name: name },
}
