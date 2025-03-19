{
  new(this): {
    groups: [
      {
        name: 'openldap-alerts',
        rules: [
          {
            alert: 'OpenLDAPConnectionSpike',
            expr: |||
              increase(openldap_monitor_counter_object{dn="cn=Current,cn=Connections,cn=Monitor"}[5m]) > %(alertsWarningConnectionSpike)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A sudden spike in OpenLDAP connections indicates potential high usage or security issues.',
              description:
                (
                  'There are {{ printf "%%.0f" $value }} OpenLDAP connections on instance {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningConnectionSpike)s.'
                ) % this.config,
            },
          },
          {
            alert: 'OpenLDAPHighSearchOperationRateSpike',
            expr: |||
              100 * (
                rate(openldap_monitor_operation{dn="cn=Search,cn=Operations,cn=Monitor"}[5m]) 
                / 
                clamp_min(rate(openldap_monitor_operation{dn="cn=Search,cn=Operations,cn=Monitor"}[15m] offset 5m), 0.0001)
              ) > %(alertsWarningHighSearchOperationRateSpike)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A significant spike in OpenLDAP search operations indicates inefficient queries, potential abuse, or unintended heavy load.',
              description:
                (
                  'The rate of search operations in OpenLDAP on instance {{$labels.instance}} has increased by {{ printf "%%.0f" $value }} percent in the last 5 minutes, ' +
                  'compared to the average over the last 15 minutes, which is above the threshold of %(alertsWarningHighSearchOperationRateSpike)s percent.'
                ) % this.config,
            },
          },
          {
            alert: 'OpenLDAPDialFailures',
            expr: |||
              increase(openldap_dial{result!="ok"}[10m]) > %(alertsWarningDialFailureSpike)s
            ||| % this.config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Significant increase in LDAP dial failures indicates network issues, problems with the LDAP service, or configuration errors that may lead to service unavailability.',
              description:
                (
                  'LDAP dial failures on instance {{$labels.instance}} have increased by {{ printf "%%.0f" $value }} in the last 10 minutes, ' +
                  'which is above the threshold of %(alertsWarningDialFailureSpike)s.'
                ) % this.config,
            },
          },
          {
            alert: 'OpenLDAPBindFailureRateIncrease',
            expr: |||
              increase(openldap_bind{result!="ok"}[10m]) > %(alertsWarningBindFailureRateIncrease)s
            ||| % this.config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Significant increase in LDAP bind failures indicates authentication issues, potential security threats or problems with user directories.',
              description:
                (
                  'LDAP bind failures on instance {{$labels.instance}} have increased by {{ printf "%%.0f" $value }} in the last 10 minutes, ' +
                  'which is above the threshold of %(alertsWarningBindFailureRateIncrease)s.'
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
