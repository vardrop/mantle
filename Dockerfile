FROM golang:alpine as golang
RUN apk add --no-cache git libc-dev musl-dev build-base gcc git
WORKDIR /go/src
RUN git clone https://github.com/nektro/mantle
WORKDIR /go/src/mantle
RUN go mod init github.com/nektro/mantle
RUN go get -v -u github.com/rakyll/statik
RUN $GOPATH/bin/statik -src="./www/"
RUN go get -v -u .
RUN go mod edit -replace=github.com/satori/go.uuid@v1.2.0=github.com/satori/go.uuid@master
RUN go mod tidy
RUN CGO_ENABLED=1 go install -ldflags '-extldflags "-static"'

FROM alpine
COPY --from=golang /go/bin/mantle /app/mantle

EXPOSE 8000
VOLUME /.config/mantle
CMD ["/app/mantle"]
