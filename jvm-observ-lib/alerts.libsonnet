{
  new(this): {

    groups: [
      {
        name: this.config.uid,
        rules:
          [
            {
              alert: 'JvmMemoryFillingUp',
              expr: '(%s/%s) * 100 > %s' %
                    [
                      this.signals.memory.memoryUsedHeap.asRuleExpression(),
                      this.signals.memory.memoryMaxHeap.asRuleExpression(),
                      this.config.alertHeapWarning,
                    ],
              'for': '5m',
              keep_firing_for: '5m',
              labels: {
                severity: 'warning',
              },
              annotations: {
                summary: 'JVM heap memory filling up.',
                description: 'JVM heap memory usage is at {{ printf "%%.0f" $value }}%% over the last 5 minutes on {{$labels.instance}}, which is above the threshold of %(alertHeapWarning)s%%.'
                             % this.config,
              },
            },
          ]
          +
          (
            // add only this alert if signal is present for this metricsSource:
            if std.length(this.signals.threads.threadsDeadlocked.asRuleExpression()) > 0
            then
              [
                {
                  alert: 'JvmThreadsDeadlocked',
                  expr: '%s > 0' % this.signals.threads.threadsDeadlocked.asRuleExpression(),
                  'for': '2m',
                  keep_firing_for: '5m',
                  labels: {
                    severity: 'critical',
                  },
                  annotations: {
                    summary: 'JVM deadlock detected.',
                    description: 'JVM deadlock detected: Threads in the JVM application {{$labels.instance}} are in a cyclic dependency with each other. The restart is required to resolve the deadlock.'
                                 % this.config,
                  },
                },
              ] else []
          ),
      },
    ],
  },
}
