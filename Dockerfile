# Build Geth in a stock Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc git musl-dev linux-headers

RUN cd / && \ 
    git clone https://github.com/EthereumCommonwealth/go-callisto && \
    cd go-callisto && \
    git pull && \
    git checkout refs/heads/CLO/1.0 && \
    make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-callisto/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 30303 30303/udp

ENTRYPOINT ["geth"]
