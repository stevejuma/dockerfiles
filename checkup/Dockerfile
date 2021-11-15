FROM golang:alpine as builder
LABEL maintainer "Steve Juma <stevejuma@ju.ma>"
ENV CHECKUP_VERSION v0.2.0

RUN	apk --no-cache add \
	ca-certificates \
	gcc \
	git \
	libc-dev

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN go get github.com/sourcegraph/checkup/cmd/checkup@${CHECKUP_VERSION}

FROM alpine:latest

COPY --from=builder /go/bin/checkup /usr/bin/checkup
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs

ENTRYPOINT [ "checkup" ]