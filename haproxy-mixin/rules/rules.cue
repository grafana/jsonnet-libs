import "github.com/prometheus/prometheus/pkg/rulefmt"

groups: [
	...rulefmt.#RuleGroup & {rules: [...rulefmt.#RecordingRule]},
]

groups: []
