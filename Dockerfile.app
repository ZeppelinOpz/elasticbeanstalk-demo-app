FROM golang:1.11

RUN mkdir -p /go/src/goangular-app
COPY . /go/src/goangular-app
WORKDIR /go/src/goangular-app
RUN go get .
CMD go run main.go

EXPOSE 3000