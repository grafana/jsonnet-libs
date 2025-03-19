{
  new(this): {

    groups: [
      {
        name: 'golang-alerts-' + this.config.uid,
        rules: [],
      },
    ],
  },
}
