function(this) {
  local legendCustomTemplate = '{{ instance }}',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'sum',
  alertsInterval: '2m',
  discoveryMetric: {
    prometheus: 'tomcat_session_sessioncounter_total',
  },
  signals: {
    totalSessions: {
      name: 'Total sessions',
      nameShort: 'Total sessions',
      type: 'raw',
      description: 'The total number of sessions.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(increase(tomcat_session_sessioncounter_total{%(queriesSelector)s, host=~"$host", context=~"$context"}[$__interval:] offset -$__interval)) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total sessions',
        },
      },
    },

    rejectedSessions: {
      name: 'Rejected sessions',
      nameShort: 'Rejected sessions',
      type: 'raw',
      description: 'The number of rejected sessions.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(increase(tomcat_session_rejectedsessions_total{%(queriesSelector)s, host=~"$host", context=~"$context"}[$__interval:] offset -$__interval)) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - rejected sessions',
        },
      },
    },

    expiredSessions: {
      name: 'Expired sessions',
      nameShort: 'Expired sessions',
      type: 'raw',
      description: 'The number of expired sessions.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(increase(tomcat_session_expiredsessions_total{%(queriesSelector)s, host=~"$host", context=~"$context"}[$__interval:] offset -$__interval)) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - expired sessions',
        },
      },
    },

    sessionRate: {
      name: 'Session rate',
      nameShort: 'Session rate',
      type: 'counter',
      description: 'The rate of sessions.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'tomcat_session_sessioncounter_total{%(queriesSelector)s, host=~"$host", context=~"$context"}',
          rangeFunction: 'increase',
          legendCustomTemplate: legendCustomTemplate + ' - {{host}}{{context}} - sessions',
        },
      },
    },

    rejectedSessionRate: {
      name: 'Rejected rate',
      nameShort: 'Rejected rate',
      type: 'counter',
      description: 'The rate of rejected sessions.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'tomcat_session_rejectedsessions_total{%(queriesSelector)s, host=~"$host", context=~"$context"}',
          rangeFunction: 'increase',
          legendCustomTemplate: legendCustomTemplate + ' - {{host}}{{context}} - rejected',
        },
      },
    },

    expiredSessionRate: {
      name: 'Expired rate',
      nameShort: 'Expired rate',
      type: 'counter',
      description: 'The rate of expired sessions.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'tomcat_session_expiredsessions_total{%(queriesSelector)s, host=~"$host", context=~"$context"}',
          rangeFunction: 'increase',
          legendCustomTemplate: legendCustomTemplate + ' - {{host}}{{context}} - expired',
        },
      },
    },

    totalSessionProcessingTime: {
      name: 'Total session processing time',
      nameShort: 'Total session processing time',
      type: 'raw',
      description: 'The total time spent processing sessions.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'sum(increase(tomcat_session_processingtime_total{%(queriesSelector)s, host=~"$host", context=~"$context"}[$__interval:] offset -$__interval) / clamp_min(increase(tomcat_session_sessioncounter_total{%(queriesSelector)s, host=~"$host", context=~"$context"}[$__interval:] offset -$__interval), 1)) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total',
        },
      },
    },

    sessionProcessingTime: {
      name: 'Session processing time',
      nameShort: 'Session processing time',
      type: 'raw',
      description: 'The time spent processing sessions.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'increase(tomcat_session_processingtime_total{%(queriesSelector)s, host=~"$host", context=~"$context"}[$__interval:] offset -$__interval) / clamp_min(increase(tomcat_session_sessioncounter_total{%(queriesSelector)s, host=~"$host", context=~"$context"}[$__interval:] offset -$__interval), 1)',
          legendCustomTemplate: legendCustomTemplate + ' - {{host}}{{context}}',
        },
      },
    },

    totalServletRequests: {
      name: 'Total servlet requests',
      nameShort: 'Total servlet requests',
      type: 'raw',
      description: 'The total number of servlet requests.',
      unit: 'r/s',
      sources: {
        prometheus: {
          expr: 'sum(rate(tomcat_servlet_requestcount_total{%(queriesSelector)s, module=~"$host$context", servlet=~"$servlet"}[$__rate_interval])) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total requests',
        },
      },
    },


    totalServletErrors: {
      name: 'Total servlet errors',
      nameShort: 'Total servlet errors',
      type: 'raw',
      description: 'The total number of servlet errors.',
      unit: 'r/s',
      sources: {
        prometheus: {
          expr: 'sum(rate(tomcat_servlet_errorcount_total{%(queriesSelector)s, module=~"$host$context", servlet=~"$servlet"}[$__rate_interval])) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total errors',
        },
      },
    },

    servletRequestRate: {
      name: 'Servlet request rate',
      nameShort: 'Servlet request rate',
      type: 'counter',
      description: 'The rate of servlet requests.',
      unit: 'r/s',
      sources: {
        prometheus: {
          expr: 'tomcat_servlet_requestcount_total{%(queriesSelector)s, module=~"$host$context", servlet=~"$servlet"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{module}}{{servlet}} - requests',
        },
      },
    },

    servletErrorRate: {
      name: 'Servlet error rate',
      nameShort: 'Servlet error rate',
      type: 'counter',
      description: 'The rate of servlet errors.',
      unit: 'r/s',
      sources: {
        prometheus: {
          expr: 'tomcat_servlet_errorcount_total{%(queriesSelector)s, module=~"$host$context", servlet=~"$servlet"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{module}}{{servlet}} - errors',
        },
      },
    },

    totalServletProcessingTime: {
      name: 'Total servlet processing time',
      nameShort: 'Total servlet processing time',
      type: 'raw',
      description: 'The total time spent processing servlet requests.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'sum(increase(tomcat_servlet_processingtime_total{%(queriesSelector)s, module=~"$host$context", servlet=~"$servlet"}[$__interval:] offset -$__interval) / clamp_min(increase(tomcat_servlet_requestcount_total{%(queriesSelector)s, module=~"$host$context", servlet=~"$servlet"}[$__interval:] offset -$__interval), 1)) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total',
        },
      },
    },

    servletProcessingTime: {
      name: 'Servlet processing time',
      nameShort: 'Servlet processing time',
      type: 'raw',
      description: 'The time spent processing servlet requests.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'increase(tomcat_servlet_processingtime_total{%(queriesSelector)s, module=~"$host$context", servlet=~"$servlet"}[$__interval:] offset -$__interval) / clamp_min(increase(tomcat_servlet_requestcount_total{%(queriesSelector)s, module=~"$host$context", servlet=~"$servlet"}[$__interval:] offset -$__interval), 1)',
          legendCustomTemplate: legendCustomTemplate + ' - {{module}}{{servlet}}',
        },
      },
    },
  },
}
