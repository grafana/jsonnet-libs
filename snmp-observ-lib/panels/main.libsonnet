{
  new(signals, this):: {
    cpu: (import './cpu.libsonnet').new(signals, this),
    fleet: (import './fleet.libsonnet').new(signals, this),
    memory: (import './memory.libsonnet').new(signals, this),
    interface: (import './interface.libsonnet').new(signals, this),
    system: (import './system.libsonnet').new(signals, this),
    temperature: (import './temperature.libsonnet').new(signals, this),
    power: (import './power.libsonnet').new(signals, this),
    fans: (import './fans.libsonnet').new(signals, this),
    fiber: (import './fiber.libsonnet').new(signals, this),
  },
}
