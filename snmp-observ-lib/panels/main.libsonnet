{
  new(signals, this):: {
    cpu: (import './cpu.libsonnet').new(signals, this),
    fleet: (import './fleet.libsonnet').new(signals, this),
    memory: (import './memory.libsonnet').new(signals, this),
    interface: (import './interface.libsonnet').new(signals, this),
    system: (import './system.libsonnet').new(signals, this),
  },
}
