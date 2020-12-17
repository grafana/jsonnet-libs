{
  local this = self,

  _config+:: {
    slack_url: 'http://slack',
    slack_channel: 'general',
  },

  build_slack_receiver(name, slack_channel)::
    {
      name: name,
      slack_configs: [{
        api_url: this._config.slack_url,
        channel: slack_channel,
        send_resolved: true,
        title: '{{ template "__alert_title" . }}',
        text: '{{ template "__alert_text" . }}',
        actions: [
          {
            type: 'button',
            text: 'Runbook :green_book:',
            url: '{{ (index .Alerts 0).Annotations.runbook_url }}',
          },
          {
            type: 'button',
            text: 'Source :information_source:',
            url: '{{ (index .Alerts 0).GeneratorURL }}',
          },
          {
            type: 'button',
            text: 'Silence :no_bell:',
            url: '{{ template "__alert_silence_link" . }}',
          },
          {
            type: 'button',
            text: 'Dashboard :grafana:',
            url: '{{ (index .Alerts 0).Annotations.dashboard_url }}',
          },
        ],
      }],
    },

  alertmanager_config+:: {
    route+: {
      group_by: ['alertname'],
      receiver: 'slack',
    },

    receivers+: [
      this.build_slack_receiver('slack', this._config.slack_channel),
    ],
  },
}
