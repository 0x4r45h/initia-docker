FROM golang:1.22.2-bookworm as builder
ARG NODE_VERSION
ARG ORACLE_VERSION
USER root
RUN apt-get update && apt-get install -y \
    make \
    curl \
    git \
    && apt-get clean
WORKDIR /root
# Make node binaries
RUN git clone --branch $NODE_VERSION --single-branch https://github.com/initia-labs/initia.git
WORKDIR initia
#RUN git checkout $NODE_VERSION
RUN make install

#Make Oracle Binaries
WORKDIR /root
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
    perl \
    lz4 \
    git \
    iputils-ping \
    && apt-get clean

COPY --from=builder /go/bin/initiad /usr/local/bin/initiad
COPY --from=builder /root/slinky/build/slinky /usr/local/bin/slinky
COPY --from=builder /go/pkg/mod/github.com/initia-labs/movevm@v0.2.8/api/libmovevm.x86_64.so /usr/local/lib/
COPY --from=builder /go/pkg/mod/github.com/initia-labs/movevm@v0.2.8/api/libcompiler.x86_64.so /usr/local/lib/

# Ensure the library can be found by the dynamic linker
RUN ldconfig

ENTRYPOINT ["/usr/local/bin/initiad"]
CMD ["--help"]