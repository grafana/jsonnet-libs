package panel

#Table: Base & {
	type:        "table"
	fieldConfig: #FieldConfig
	options: {
		showHeader?: bool | *true
		sortBy?: [{displayName: string, desc: bool}]
	}
	overrides?: [...#Override]
	transformations?: [...Transformation]
}

Transformation: {
	id: string
	options: {}
}
