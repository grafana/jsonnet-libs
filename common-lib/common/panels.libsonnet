local g = import './g.libsonnet';

{
  all: {
    stat: import './panels/all/stat/main.libsonnet',
    timeSeries: import './panels/all/timeSeries/main.libsonnet',
    table: import './panels/all/table/main.libsonnet',
    statusHistory: import './panels/all/statusHistory/main.libsonnet',
  },
  network: {
    timeSeries: import './panels/network/timeSeries/main.libsonnet',
  },
  system: {
    stat: import './panels/system/stat/main.libsonnet',
    table: import './panels/system/table/main.libsonnet',
    statusHistory: import './panels/system/statusHistory/main.libsonnet',
  },
  cpu: {
    stat: import './panels/cpu/stat/main.libsonnet',
    timeSeries: import './panels/cpu/timeSeries/main.libsonnet',
  },
  memory: {
    stat: import './panels/memory/stat/main.libsonnet',
    timeSeries: import './panels/memory/timeSeries/main.libsonnet',
  },
  filesystem: {
    timeSeries: import './panels/filesystem/timeSeries/main.libsonnet',
    table: import './panels/filesystem/table/main.libsonnet',
    stat: import './panels/filesystem/stat/main.libsonnet',
  },
  disk: {
    timeSeries: import './panels/disk/timeSeries/main.libsonnet',
  },
}
