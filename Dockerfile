FROM ubuntu:16.04

ENV RUST_VERSION=1.32.0 \
  ROCKSDB_LIB_DIR=/usr/lib \
  SNAPPY_LIB_DIR=/usr/lib/x86_64-linux-gnu \
  CARGO_TARGET_DIR=../target

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    software-properties-common \
    gcc \
    g++ \
    pkg-config \
    libssl-dev \
    libcurl4-openssl-dev \
    libelf-dev \
    libdw-dev \
    binutils-dev \
    libiberty-dev \
    curl && \
  add-apt-repository -y ppa:exonum/rocksdb && \
  add-apt-repository -y ppa:maarten-fonville/protobuf && \
  add-apt-repository -y ppa:fsgmhoward/shadowsocks-libev && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libprotobuf-dev \
    libsnappy-dev \
    libsodium-dev \
    librocksdb5.17 \
    protobuf-compiler
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $RUST_VERSION && \
  ln -s $HOME/.cargo/bin/* /usr/bin && \
  ln -s /cargo/git $HOME/.cargo/git && \
  ln -s /cargo/registry $HOME/.cargo/registry
WORKDIR /project