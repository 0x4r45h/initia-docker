FROM golang:1.22.2-bookworm as builder
ARG ORACLE_VERSION
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    git \
    && apt-get clean
WORKDIR /root
#Make Oracle Binaries
RUN git clone --branch $ORACLE_VERSION --single-branch https://github.com/skip-mev/slinky.git
WORKDIR slinky
RUN make build

FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y \
    curl \
    nano \
    jq \
    dnsutils \
    wget \
    unzip \
    lz4 \
    git \
    iputils-ping \
    iproute2 \
    && apt-get clean

COPY --from=builder /root/slinky/build/slinky /usr/local/bin/slinky

ENTRYPOINT ["/usr/local/bin/slinky"]
CMD ["--help"]