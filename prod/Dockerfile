FROM ubuntu:16.04

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    software-properties-common \
    libssl1.0.0 && \
  add-apt-repository -y ppa:exonum/rocksdb && \
  add-apt-repository -y ppa:maarten-fonville/protobuf && \
  add-apt-repository -y ppa:fsgmhoward/shadowsocks-libev && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libprotobuf10 \
    libsnappy1v5 \
    libsodium23 \
    librocksdb5.17

# Cleanup: remove `software-properties-common` (which we don't need) and apt lists.
RUN apt-get remove -y --auto-remove software-properties-common && \
  rm -rf /var/lib/apt/lists/*
