
$(eval SHELL:=/bin/bash)

include .env
export

MTLS_URL := https://localhost:443

default:
	@echo "mTLS testing"

build-cient:
	docker build --build-arg IMAGE_VERSION \
		--tag local/client client

up:
	docker-compose --env-file .env up -d --build

logs:
	docker-compose logs

logs-follow:
	docker-compose logs --follow

down: 
	docker-compose down

curl-test-with-certs:
	curl --cacert certs/ca.crt --key certs/client.key --cert certs/client.crt -k  ${MTLS_URL}

curl-test-without-certs:
	curl ${MTLS_URL}

curl-test-through-client:
	curl http://localhost:9090