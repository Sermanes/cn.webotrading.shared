DOCKER_REGISTRY = registry.digitalocean.com/computernerd/
PROJECT = PROJECT_NAME
DOCKER_TAG = TAG

.PHONY: install-deps tests format linting ci build docker-buildx docker-push swagger

install-deps:
	go mod init || true
	go mod tidy
	go install github.com/mgechev/revive@latest
	go install github.com/swaggo/swag/cmd/swag@latest

tests:
	go clean -testcache && go test -v -failfast ./... -short

format:
	go fmt ./...

linting:
	revive -formatter stylish -config linting.toml ./...

ci:	tests linting

before-push: tests format linting

docker-buildx:
	docker buildx build --no-cache --progress=plain -t $(DOCKER_REGISTRY)$(PROJECT):$(DOCKER_TAG) -f Dockerfile --platform linux/amd64  .

docker-push:
	docker push $(DOCKER_REGISTRY)$(PROJECT):$(DOCKER_TAG)

docker-run:
	docker run --env-file .env --network computernerd  $(DOCKER_REGISTRY)$(PROJECT):$(DOCKER_TAG) 

swagger:
	swag init --parseDependency --parseInternal
