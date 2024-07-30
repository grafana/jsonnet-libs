{
  new(this): {
    groups+: [
      {
        name: this.config.uid + 'zookeeper-alerts',
        rules:
          [],
      },
    ],
  },
}
