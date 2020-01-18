FROM golang:alpine as golang
WORKDIR /go/src/mantle
COPY . .
RUN apk add --no-cache git libc-dev musl-dev build-base gcc
RUN go mod init github.com/nektro/mantle
RUN go get -v -u -d .
RUN go mod edit -replace=github.com/satori/go.uuid@v1.2.0=github.com/satori/go.uuid@master
RUN go mod tidy
RUN go get -v -u .
RUN CGO_ENABLED=1 go install -ldflags '-extldflags "-static"'

FROM alpine
COPY --from=golang /go/bin/mantle /app

EXPOSE 8000
VOLUME /.config
ENTRYPOINT ["/app"]
CMD ["./mantle"]
