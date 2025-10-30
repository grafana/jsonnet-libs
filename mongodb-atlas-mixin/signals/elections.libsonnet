function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {

      stepUpCmdCalled: {
        name: 'Step-up elections called',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of step-up elections called.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_stepUpCmd_called{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - called',
          },
        },
      },

      stepUpCmdSuccessful: {
        name: 'Step-up elections successful',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of successful step-up elections.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_stepUpCmd_successful{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - successful',
          },
        },
      },

      priorityTakeoverCalled: {
        name: 'Priority takeover elections called',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of priority takeover elections called.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_priorityTakeover_called{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - called',
          },
        },
      },

      priorityTakeoverSuccessful: {
        name: 'Priority takeover elections successful',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of successful priority takeover elections.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_priorityTakeover_successful{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - successful',
          },
        },
      },

      catchUpTakeoverCalled: {
        name: 'Catch-up takeover elections called',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of catch-up takeover elections called.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_catchUpTakeover_called{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - called',
          },
        },
      },

      catchUpTakeoverSuccessful: {
        name: 'Catch-up takeover elections successful',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of successful catch-up takeover elections.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_catchUpTakeover_successful{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - successful',
          },
        },
      },

      electionTimeoutCalled: {
        name: 'Election timeout elections called',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of election timeout elections called.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_electionTimeout_called{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - called',
          },
        },
      },

      electionTimeoutSuccessful: {
        name: 'Election timeout elections successful',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of successful election timeout elections.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_electionTimeout_successful{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - successful',
          },
        },
      },

      numCatchUps: {
        name: 'Number of catch-ups',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of catch-up operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_numCatchUps{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      numCatchUpsSkipped: {
        name: 'Number of catch-ups skipped',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of catch-ups skipped.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_numCatchUpsSkipped{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      numCatchUpsSucceeded: {
        name: 'Number of catch-ups succeeded',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of catch-ups succeeded.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_numCatchUpsSucceeded{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      numCatchUpsFailedWithError: {
        name: 'Number of catch-ups failed with error',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of catch-ups failed with error.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_numCatchUpsFailedWithError{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      numCatchUpsTimedOut: {
        name: 'Number of catch-up timeouts',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Number of catch-up timeouts.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_numCatchUpsTimedOut{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      averageCatchUpOps: {
        name: 'Average catch-up operations',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Average catch-up operations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_electionMetrics_averageCatchUpOps{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
