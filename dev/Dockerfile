FROM ubuntu:16.04

ENV ROCKSDB_LIB_DIR=/usr/lib \
  SNAPPY_LIB_DIR=/usr/lib/x86_64-linux-gnu \
  CARGO_TARGET_DIR=/target

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
  curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
  add-apt-repository -y ppa:exonum/rocksdb && \
  add-apt-repository -y ppa:maarten-fonville/protobuf && \
  add-apt-repository -y ppa:fsgmhoward/shadowsocks-libev && \
  add-apt-repository -y 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main' && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libprotobuf-dev \
    libsnappy-dev \
    libsodium-dev \
    librocksdb5.17 \
    protobuf-compiler \
    clang-8

ARG RUST_VERSION=1.36.0
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $RUST_VERSION && \
  ln -s $HOME/.cargo/bin/* /usr/bin && \
  mkdir -p /cargo/git && \
  ln -s /cargo/git $HOME/.cargo/git && \
  mkdir -p /cargo/registry && \
  ln -s /cargo/registry $HOME/.cargo/registry
WORKDIR /project
VOLUME ["/cargo", "/target", "/project"]
