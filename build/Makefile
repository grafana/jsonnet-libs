.uptodate: Dockerfile
	docker build -t grafana/jsonnet-build:$(shell git rev-parse --short HEAD) .
	touch $@

publish-build-image:
	docker push grafana/jsonnet-build:$(shell git rev-parse --short HEAD)
