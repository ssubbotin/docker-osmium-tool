FROM ubuntu:20.04 AS builder

MAINTAINER Sergey Subbotin <ssubbotin@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV PROTOZERO_VERSION 1.7.1
ENV OSMIUM_VERSION 2.19.0
ENV OSMIUM_TOOL_VERSION 1.15.0

RUN apt-get update \
 && apt-get -q -y --no-install-recommends install \
    wget \
    ca-certificates \
    clang \
    cmake \
    g++ \
    git \
    libboost-dev \
    libboost-program-options-dev \
    libbz2-dev \
    libexpat1-dev \
    liblz4-dev \
    make \
    pandoc \
    zlib1g-dev \
 && apt-get -qq clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN wget https://github.com/mapbox/protozero/archive/refs/tags/v${PROTOZERO_VERSION}.tar.gz \
 && tar xzvf v${PROTOZERO_VERSION}.tar.gz \
 && rm v${PROTOZERO_VERSION}.tar.gz \
 && mv protozero-${PROTOZERO_VERSION} protozero \
 && cd protozero \
 && mkdir build && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd /build \
 && rm -rf protozero

RUN wget https://github.com/osmcode/libosmium/archive/v${OSMIUM_VERSION}.tar.gz \
 && tar xzvf v${OSMIUM_VERSION}.tar.gz \
 && rm v${OSMIUM_VERSION}.tar.gz \
 && mv libosmium-${OSMIUM_VERSION} libosmium \
 && cd libosmium \
 && mkdir build && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF .. \
 && make \
 && make install \
 && cd /build \
 && rm -rf libosmium

RUN wget https://github.com/osmcode/osmium-tool/archive/v${OSMIUM_TOOL_VERSION}.tar.gz \
 && tar xzvf v${OSMIUM_TOOL_VERSION}.tar.gz \
 && rm v${OSMIUM_TOOL_VERSION}.tar.gz \
 && mv osmium-tool-${OSMIUM_TOOL_VERSION} osmium-tool \
 && cd osmium-tool \
 && mkdir build && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd /build \
 && rm -rf osmium-tool

FROM ubuntu:20.04

RUN apt-get update \
 && apt-get -q -y --no-install-recommends install \
    libboost-program-options-dev \
    libexpat1-dev \
 && apt-get -qq clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /usr/include/boost

COPY --from=builder /usr/local/bin/osmium /usr/local/bin/osmium

WORKDIR /data
ENTRYPOINT ["/usr/local/bin/osmium"]
