FROM golang:alpine as golang
WORKDIR /go/src/mantle
COPY . .
RUN apk add --no-cache git libc-dev musl-dev build-base gcc
RUN go get -v -u .
RUN CGO_ENABLED=1 go build -ldflags '-extldflags "-static"' -o mantle

FROM alpine
COPY --from=golang /go/bin/mantle /app
VOLUME /data
USER guest
EXPOSE 8080

ENTRYPOINT ["/app"]
