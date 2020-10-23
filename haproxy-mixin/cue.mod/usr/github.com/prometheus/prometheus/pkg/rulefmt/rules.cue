package rulefmt

import "time"

#RecordingRule: {
	record: string
	expr: string
}

#AlertingRule: {
	alert: string
	expr: string
	for: time.Duration
	labels?: {[string]: string}
	annotations?: {[string]: string}
}
