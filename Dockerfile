# Build Stage
FROM golang:alpine AS build
COPY httpenv.go /go
RUN go build httpenv.go

# Test Stage
FROM build AS test
COPY httpenv_test.go /go
RUN go test -v

# final stage
FROM alpine
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv
COPY --from=0 --chown=httpenv:httpenv /go/httpenv /httpenv
EXPOSE 8888
# we're not changing user in this example, but you could:
# USER httpenv
CMD ["/httpenv"]
