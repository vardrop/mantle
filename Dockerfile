FROM golang:alpine as golang
RUN apk add --no-cache git libc-dev musl-dev build-base gcc ca-certificates
WORKDIR /go/src/mantle
COPY . .
RUN go mod init github.com/nektro/mantle
RUN go get -v -u github.com/rakyll/statik
RUN $GOPATH/bin/statik -src="./www/"
RUN go get -v -u -d .
RUN go mod edit -replace=github.com/satori/go.uuid@v1.2.0=github.com/satori/go.uuid@master
RUN go mod tidy
RUN go get -v -u .
RUN CGO_ENABLED=1 go install -ldflags '-extldflags "-static"'

FROM alpine
COPY --from=golang /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=golang /go/bin/mantle /app/mantle

EXPOSE 8000
VOLUME /root/.config/mantle
CMD ["/app/mantle"]
