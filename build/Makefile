.uptodate: Dockerfile
	docker buildx build --platform linux/amd64 -t grafana/jsonnet-build:$(shell git rev-parse --short HEAD) .
	touch $@

publish-build-image:
	docker push grafana/jsonnet-build:$(shell git rev-parse --short HEAD)
