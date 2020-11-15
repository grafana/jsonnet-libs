package drone

import (
	drone "github.com/drone/drone-yaml/yaml"
)

let pipeline = drone.#Pipeline & {
	platform: {os: "linux", arch: "amd64"}
}

let build_image = "jdbgrafana/haproxy-mixin-build-image:0.0.1"

pipelines: [
	pipeline & {
		name: "pr"
		steps: [
			{
				name:  "check .drone/drone.yml"
				image: build_image
				commands: [
					"make .drone/drone.yml",
					"git diff --exit-code -- .drone/drone.yml",
				]
			},
		]
	},
	pipeline & {
		name: "default"
		steps: [
			{
				name:  "fmt"
				image: build_image
				commands: [
					"make fmt",
				]
			},
			{
				name:  ".drone/drone.yml"
				image: build_image
				commands: [
					"make .drone/drone.yml",
				]
			},
			{
				name:  "build"
				image: build_image
				commands: [
					"make build",
				]
			},
			{
				name:  "lint"
				image: build_image
				commands: [
					"make lint",
				]
			},
		]
	},
]
