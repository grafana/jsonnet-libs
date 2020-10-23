import "github.com/prometheus/prometheus/pkg/rulefmt"

groups: [
	rulefmt.#RuleGroup & {
		rules: [rulefmt.#AlertingRule]
	},
]
groups: [
	{
		name: "HAProxyAlerts"
		rules: [
			{
				alert: "HAProxyDroppingLogs"
				expr:  "rate(haproxy_process_dropped_logs_total[5m]!= 0"
				for:   "5s"
				labels: {
					severity: "critical"
				}
				annotations: {
					description: "HAProxy {{$labels.job}} on {{$labels.instance}} is dropping logs."
					summary:     "HAProxy dropping logs"
				}
			},
		]
	},
]
