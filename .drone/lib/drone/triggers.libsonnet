{
  master:: {
    trigger+: {
      branch+: ['master'],
      event+: {
        include+: ['push'],
      },
    },
  },
  pr:: {
    trigger+: {
      event+: {
        include+: ['pull_request'],
      },
    },
  },
}
