package panel

#Graph: Base & {
	type: "graph"
	// Display values as a bar chart.
	bars:          bool | *false
	dashLength:    int | *10
	dashes:        bool | *false
	decimals?:     int
	fieldConfig:   #FieldConfig
	fill:          int | *1
	fillGradient:  int & >0 & <10 | *0
	hiddenSeries:  bool | *false
	legend:        #Legend
	lines:         bool | *true
	linewidth:     int | *1
	nullPointMode: "null as zero" | "connected" | *"null"
	options: {
		dataLinks: [...#Link]
	}
	percentage:   bool | *false
	pointradius?: int
	points:       bool | *false
	renderer:     string | *"flot"
	seriesOverrides: [...#SeriesOverride]
	spaceLength: int | *10
	stack:       bool | *false
	steppedLine: bool | *false
	thresholds:  #Threshold
	timeFrom?:   string
	timeRegions?: [{}]
	timeShift?: string
	tooltip: {
		shared: bool | *true
		let None = 0
		let Increasing = 1
		let Decreasing = 2
		sort:       None | Increasing | *Decreasing
		value_type: string | *"individual"
	}
	xaxis?: {
		name:     string
		buckets?: string
		mode:     "series" | "histogram" | *"time"
		show:     bool | *true
		values?: [{}]
	}
	yaxes?: [...{
		decimals?: int
		format:    string | *"short"
		label:     string | *null
		logBase:   int | *1
		max:       int | *null
		min:       int | *null
		show:      bool | *true
	}]
	yaxis: {
		align:      bool | *false
		alignLevel: int | *0
	}
}

#Legend: {
	alignAsTable?: bool
	avg:           bool | *false
	current:       bool | *false
	max:           bool | *false
	min:           bool | *false
	rightSide:     bool | *false
	show:          bool | *true
	sideWidth?:    int
	total:         bool | *false
	values:        bool | *true
}

#SeriesOverride: {
	alias?:         string
	bars?:          #Graph.bars
	color?:         string
	dashes?:        #Graph.dashes
	dashLength?:    #Graph.dashLength
	fill?:          #Graph.fill
	fillBelowTo?:   string
	fillGradient?:  #Graph.fillGradient
	hiddenSeries?:  #Graph.hiddenSeries
	hideTooltip?:   bool
	legend?:        bool
	lines?:         #Graph.lines
	linewidth?:     #Graph.linewidth
	nullPointMode?: #Graph.nullPointMode
	pointradius?:   int
	points?:        #Graph.points
	spaceLength?:   #Graph.spaceLength
	stack?:         #Graph.stack
	steppedLine?:   #Graph.steppedLine
	transform?:     string
	yaxis?:         int
	zindex?:        int
}
