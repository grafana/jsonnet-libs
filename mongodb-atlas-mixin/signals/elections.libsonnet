function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {

      stepUpCmdCalled: {
        name: 'Step-up elections called',
        type: 'raw',
        description: 'Number of step-up elections called.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_stepUpCmd_called{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}} - called',
          },
        },
      },

      stepUpCmdSuccessful: {
        name: 'Step-up elections successful',
        type: 'raw',
        description: 'Number of successful step-up elections.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_stepUpCmd_successful{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}} - successful',
          },
        },
      },

      priorityTakeoverCalled: {
        name: 'Priority takeover elections called',
        type: 'raw',
        description: 'Number of priority takeover elections called.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_priorityTakeover_called{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}} - called',
          },
        },
      },

      priorityTakeoverSuccessful: {
        name: 'Priority takeover elections successful',
        type: 'raw',
        description: 'Number of successful priority takeover elections.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_priorityTakeover_successful{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}} - successful',
          },
        },
      },

      catchUpTakeoverCalled: {
        name: 'Catch-up takeover elections called',
        type: 'raw',
        description: 'Number of catch-up takeover elections called.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_catchUpTakeover_called{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}} - called',
          },
        },
      },

      catchUpTakeoverSuccessful: {
        name: 'Catch-up takeover elections successful',
        type: 'raw',
        description: 'Number of successful catch-up takeover elections.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_catchUpTakeover_successful{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}} - successful',
          },
        },
      },

      electionTimeoutCalled: {
        name: 'Election timeout elections called',
        type: 'raw',
        description: 'Number of election timeout elections called.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_electionTimeout_called{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}} - called',
          },
        },
      },

      electionTimeoutSuccessful: {
        name: 'Election timeout elections successful',
        type: 'raw',
        description: 'Number of successful election timeout elections.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_electionTimeout_successful{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}} - successful',
          },
        },
      },

      numCatchUps: {
        name: 'Number of catch-ups',
        type: 'raw',
        description: 'Number of catch-up operations.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_numCatchUps{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      numCatchUpsSkipped: {
        name: 'Number of catch-ups skipped',
        type: 'raw',
        description: 'Number of catch-ups skipped.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_numCatchUpsSkipped{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      numCatchUpsSucceeded: {
        name: 'Number of catch-ups succeeded',
        type: 'raw',
        description: 'Number of catch-ups succeeded.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_numCatchUpsSucceeded{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      numCatchUpsFailedWithError: {
        name: 'Number of catch-ups failed with error',
        type: 'raw',
        description: 'Number of catch-ups failed with error.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_numCatchUpsFailedWithError{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      numCatchUpsTimedOut: {
        name: 'Number of catch-up timeouts',
        type: 'raw',
        description: 'Number of catch-up timeouts.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'increase(mongodb_electionMetrics_numCatchUpsTimedOut{%(queriesSelector)s, rs_nm=~"$rs_nm"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      averageCatchUpOps: {
        name: 'Average catch-up operations',
        type: 'raw',
        aggLevel: 'instance',
        aggFunction: 'sum',
        description: 'Average catch-up operations.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_averageCatchUpOps{%(queriesSelector)s, rs_nm=~"$rs_nm"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
