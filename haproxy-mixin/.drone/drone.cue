package drone

import (
	drone "github.com/drone/drone-yaml/yaml"
)

let pipeline = drone.#Pipeline & {
	platform: {os: "linux", arch: "amd64"}
}

pipelines: [
	pipeline & {
		name: "pr"
		steps: [
			{
				name:  "check .drone/drone.yml"
				image: "haproxy-mixin-build-image:0.0.1"
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
				image: "haproxy-mixin-build-image:0.0.1"
				commands: [
					"make fmt",
				]
			},
			{
				name:  ".drone/drone.yml"
				image: "haproxy-mixin-build-image:0.0.1"
				commands: [
					"make .drone/drone.yml",
				]
			},
			{
				name:  "build"
				image: "haproxy-mixin-build-image:0.0.1"
				commands: [
					"make build",
				]
			},
			{
				name:  "lint"
				image: "haproxy-mixin-build-image:0.0.1"
				commands: [
					"make lint",
				]
			},
		]
	},
]
