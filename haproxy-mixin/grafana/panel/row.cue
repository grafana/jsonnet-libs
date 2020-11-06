package panel

#Row: Base & {
	title:       string
	collapse:    bool | *true
	collapsed:   bool | *true
	datasource?: string
	gridPos: {h: 1, w: 24}
	panels: [...Base] | *[]
	// read-only repeatRowId?: int
	showTitle: bool | *true
	titleSize: "h1" | "h2" | "h3" | "h4" | "h5" | *"h6"
	type:      "row"
}
