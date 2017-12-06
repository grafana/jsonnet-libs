cmd/promtail/.uptodate: cmd/promtail/promtail cmd/promtail/Dockerfile
	docker build -t kausal/promtail:$(shell git rev-parse --short HEAD) ./cmd/promtail
	touch $@

cmd/promtail/promtail: pkg/kausal/interface.pb.go $(exec find . -type f -name *.go)
	GOOS=linux go build -o $@ ./$(@D)

pkg/kausal/interface.pb.go: pkg/kausal/interface.proto
	protoc -I ../vendor:./$(@D) --go_out=plugins=grpc:${GOPATH}/src ./$(patsubst %.pb.go,%.proto,$@)

clean:
	rm -f pkg/kausal/interface.pb.go cmd/promtail/promtail cmd/promtail/.uptodate
