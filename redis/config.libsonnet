{
  _config+: {
    namespace: error 'must specify namespace',
    redis+: {
      password: error 'must specify password',
      port: 6379,
      sentinel_port: 26379,
      replicas: 3,
      down_after_milliseconds: 15000,
      diskSize: '50Gi',
      timeout: 0,
      clientOutputBufferLimits: {
        normal: {
          hardLimit: '0',
          softLimit: '0',
          softSeconds: 0,
        },
        slave: {
          hardLimit: '256mb',
          softLimit: '64mb',
          softSeconds: 60,
        },
        pubsub: {
          hardLimit: '32mb',
          softLimit: '8mb',
          softSeconds: 60,
        },
      },
    },
  },
}
