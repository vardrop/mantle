FROM golang:alpine as golang
WORKDIR /go/src/andesite
COPY . .
RUN apk add --no-cache git libc-dev musl-dev build-base gcc
RUN go mod init github.com/nektro/andesite
RUN go get -v -u .
RUN go mod edit -replace=github.com/satori/go.uuid@v1.2.0=github.com/satori/go.uuid@master
RUN go mod tidy
RUN CGO_ENABLED=1 go install -ldflags '-extldflags "-static"'

FROM scratch
COPY --from=golang /go/bin/andesite /app

EXPOSE 8080
VOLUME /data
ENTRYPOINT ["/app"]
CMD andesite
