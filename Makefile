

DOCKER_IMAGE="hello.com/helloworld:latest"

build:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -a -o artifacts/simple-image/kube-sample-apiserver

docker-build:
	docker build -t ${DOCKER_IMAGE} ./artifacts/simple-image

docker-push:
	kind load docker-image ${DOCKER_IMAGE} --name=demo

do-all: build docker-build docker-push .redeploy
	@echo "Done"

.redeploy:
	kubectl delete -f artifacts/example/deployment.yaml && \
	kubectl apply -f artifacts/example/deployment.yaml
