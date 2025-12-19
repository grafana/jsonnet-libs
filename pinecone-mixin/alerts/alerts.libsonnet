{
  new(this): {
    prometheusAlerts+:: {
      groups+: [
        {
          name: 'pinecone',
          rules: [
            // Add your alert rules here
          ],
        },
      ],
    },
  },
}


