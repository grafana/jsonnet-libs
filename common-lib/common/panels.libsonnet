local g = import './g.libsonnet';

{
  all: {
    stat: import './panels/all/stat/main.libsonnet',
    timeSeries: import './panels/all/timeSeries/main.libsonnet',
  },
  network: {
    timeSeries: import './panels/network/timeSeries/main.libsonnet',
  },
  system: {
    stat: import './panels/system/stat/main.libsonnet',
  },
}
