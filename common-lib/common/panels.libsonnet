local g = import './g.libsonnet';

{
  all: {
    stat: import './panels/all/stat/main.libsonnet',
    timeSeries: import './panels/all/timeSeries/main.libsonnet',
    table: import './panels/all/table/main.libsonnet',
  },
  network: {
    timeSeries: import './panels/network/timeSeries/main.libsonnet',
  },
  system: {
    stat: import './panels/system/stat/main.libsonnet',
  },
  cpu: {
    stat: import './panels/cpu/stat/main.libsonnet',
    timeSeries: import './panels/cpu/timeSeries/main.libsonnet',
  },
  filesystem: {
    timeSeries: import './panels/filesystem/timeSeries/main.libsonnet',
    table: import './panels/filesystem/table/main.libsonnet',
  },
}
