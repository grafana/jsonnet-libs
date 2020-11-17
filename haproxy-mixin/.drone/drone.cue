package drone

import (
	drone "github.com/drone/drone-yaml/yaml"
)

let pipeline = drone.#Pipeline & {
	platform: {os: "linux", arch: "amd64"}
}

let build_image = "jdbgrafana/haproxy-mixin-build-image:0.0.1"

let step = {
	check_artifacts: {
		name:  "check artifacts"
		image: build_image
		commands: [
			"make build",
			"git diff --exit-code",
		]
	}
}

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
			{
				name:  "check formatting"
				image: build_image
				commands: [
					"make fmt",
					"git diff --exit-code",
				]
			},
			step.check_artifacts,
			{
				name:  "lint mixin"
				image: build_image
				commands: [
					"make lint",
				]
			},
		]
		trigger: event: include: ["pull_request"]
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
		trigger: event: include: ["custom"]
	},
	pipeline & {
		name: "release"
		steps: [
			step.check_artifacts,
			{
				name:  "make dist/haproxy-mixin.tar.gz"
				image: build_image
				commands: [
					"make dist/haproxy-mixin.tar.gz",
				]
			},
			{
				name:  "publish"
				image: "plugins/github-release"
				settings: {
					api_key: from_secret: "github_token"
					files: value: ["dist/*"]
				}
			},
		]
		trigger: event: include: ["tag"]
	},
]
