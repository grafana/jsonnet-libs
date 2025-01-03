{
  new(signals, config):: {
    cpu: (import './cpu.libsonnet').new(signals),
    memory: (import './memory.libsonnet').new(signals),
    interface: (import './interface.libsonnet').new(signals),
    system: (import './system.libsonnet').new(signals),
  },
}
