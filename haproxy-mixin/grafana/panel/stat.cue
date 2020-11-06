package panel

#Stat: Base & {
	type:        "stat"
	fieldConfig: #FieldConfig
	options: {
		colorMode:   string | *"value"
		graphMode:   string | *"none"
		justifyMode: string | *"auto"
		orientation: string | *"auto"
		reduceOptions?: {
			properties: {
				calcs:   [string] | *["mean"]
				fields?: string
				values:  bool | *false
			}
		}
		textMode: string | *"auto"
	}
}
