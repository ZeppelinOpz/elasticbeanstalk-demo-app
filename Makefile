all: build

build:
	(docker stop angular-build > /dev/null 2>&1 || true)  && (docker rm angular-build > /dev/null 2>&1 || true) 
	docker build . -f Dockerfile.angular -t angular
	docker run --name angular-build -v $(PWD):/var/app/goangular -it angular ng build
	(docker stop angular-build > /dev/null 2>&1 || true)  && (docker rm angular-build > /dev/null 2>&1 || true)

run:
	docker-compose up -d

stop:
	docker-compose down

run: stop build run

.PHONY: all 