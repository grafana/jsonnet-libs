// Built based upon the specification in https://github.com/grafana/dashboard-spec/blob/_gen/specs/7.0/Dashboard.yml.
package grafana

import (
	"time"
	"github.com/jdbaldry/haproxy-mixin/grafana/panel"
)

#Dashboard: {
	title: string
	annotations?: {
		list: [#Annotation]
	}
	description?: string
	editable:     bool | *true
	graphTooltip: int | *0
	id?:          int
	panels?: [...panel.Base]
	refresh?:      string
	schemaVersion: int | *25
	style:         string | *"dark"
	tags:          [string] | *[]
	templating: {
		list?: [...Template]
	}
	time: {
		from: string | *"now-6h"
		to:   string | *"now"
	}
	timepicker: #TimePicker
	timezone?:  string
	uid?:       string
}

#Annotation: {
	name?:       string
	datasource?: string | *"default"
	enable?:     bool | *true
	hide?:       bool | *true
	iconColor?:  string
	rawQuery?:   string
	showIn?:     int | *0
}

#TimePicker: {
	hidden:            bool | *false
	refresh_intervals: [...time.#Duration] | *["5s", "10s", "30s", "1m", "5m", "15m", "30m", "1h", "2h", "1d"]
}
