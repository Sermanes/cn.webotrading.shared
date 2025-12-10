DOCKER_REGISTRY = registry.digitalocean.com/computernerd/
PROJECT = PROJECT_NAME
DOCKER_TAG = TAG

.PHONY: install-deps tests format linting ci build docker-buildx docker-push swagger

install-deps:
	go mod init || true
	go mod tidy
	go install github.com/mgechev/revive@latest

tests:
	go clean -testcache && go test -v -failfast ./... -short

format:
	go fmt ./...

linting:
	revive -formatter stylish -config linting.toml ./...

ci:	tests linting

before-push: tests format linting
