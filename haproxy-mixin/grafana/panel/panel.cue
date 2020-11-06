package panel

Base: {
	title?:       string
	id?:           int
	type:         "row" | "stat" | "table" | *"graph"
	datasource:   string | *"default"
	description?: string
	gridPos:      #GridPos
	links?: [{
		title?:      string
		targetBlank: bool | *true
		url?:        string
	}]
	repeat?:          string
	repeatDirection?: string
	targets:          [...#Target] | *[]
	transparent:      bool | *false
}

#GridPos: {
	h:  int | *8
	w:  int | *12
	x?: int
	y?: int
}

#Target: {
	expr:         string
	format?:      "table" | "heatmap" | *"time_series"
	legendFormat: string | *""
	instant?:     bool
	interval:     string | *""
	refId:        string
}
