local g = import 'g.libsonnet';

{
  stat: import './panels/stat/main.libsonnet',
  timeSeries: import './panels/timeSeries/main.libsonnet',
}
